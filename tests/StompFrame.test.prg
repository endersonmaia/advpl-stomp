#include "stomp.ch"
#include "hbclass.ch"
#include "xhb.ch"

CLASS TTestStompFrame INHERIT TTestCase

  METHOD testSetBody()
  METHOD testSetCommand()
  METHOD testAddHeader()
  METHOD testCountHeaders()
  METHOD testValidateCommand()
  METHOD testHeaderExists()
  METHOD testValidateConnectRequiredHeaders()
  METHOD testValidateConnectedSendRequiredHeaders()
  METHOD testValidateCommandSubscribeHeaders()
  METHOD testValidateCommandUnsubscribeHeaders()
  METHOD testValidateCommandBeginHeaders()
  METHOD testValidateCommandCommitHeaders()
  METHOD testValidateCommandAbortHeaders()
  METHOD testValidateCommandAckHeaders()
  METHOD testValidateCommandNackHeaders()
  METHOD testValidateCommandsMustNotHaveBody()
  METHOD testParseConnectFrame()
  METHOD testIsValid()

  METHOD Setup()
  METHOD Teardown()

  DATA oStompFrame

ENDCLASS

METHOD Setup() CLASS TTestStompFrame
	::oStompFrame := TStompFrame():new()
  RETURN ( NIL )

METHOD Teardown() CLASS TTestStompFrame
  ::oStompFrame := NIL
  RETURN ( NIL )

METHOD testSetBody() CLASS TTestStompFrame

  ::oStompFrame:setBody( "corpo" )

  ::assertEquals( "corpo", ::oStompFrame:cBody, "cBody should be corpo")
  
  RETURN ( NIL )

METHOD testSetCommand() CLASS TTestStompFrame

  ::oStompFrame:setCommand( "CONNECT" )
  ::assertEquals( "CONNECT", ::oStompFrame:cCommand,  "cCommand should be CONNECT." )

  ::oStompFrame:setCommand( "send" )
  ::assertEquals( "SEND", ::oStompFrame:cCommand,  "setCommand('send') should set CONNECT (upper-case)." )

  RETURN ( NIL )

METHOD testAddHeader() CLASS TTestStompFrame
  LOCAL oHeader

  oHeader := TStompFrameHeader():new( "name", "value" )
  ::oStompFrame:addHeader( oHeader )

  ::assertEquals( "name", ::oStompFrame:aHeaders[1]:cName, "oHeader:cName should be name")
  ::assertEquals( "value", ::oStompFrame:aHeaders[1]:cValue, "oHeader:cValue should be value")

  RETURN ( NIL )


METHOD testCountHeaders() CLASS TTestStompFrame
  LOCAL oHeader

  ::assertEquals( 0, ::oStompFrame:countHeaders(), "StompFrame:countHeaders() should return 0 (zero) when no headers is addes to StompFrame" )

  oHeader := TStompFrameHeader():new( "name", "value" )
  ::oStompFrame:addHeader( oHeader )
  ::assertEquals( 1, ::oStompFrame:countHeaders(), "StompFrame:countHeaders() should return 1 (one)" )

  oHeader := TStompFrameHeader():new( "other", "value" )
  ::oStompFrame:addHeader( oHeader )
  ::assertEquals( 2, ::oStompFrame:countHeaders(), "StompFrame:countHeaders() should return 2 (two)" )

  RETURN ( NIL )

METHOD testValidateCommand() CLASS TTestStompFrame
  
  ::assertFalse( ::oStompFrame:validateCommand(), "should be false when stompframe has no command" )

  ::oStompFrame:setCommand( "CONNECT" )
  ::assertTrue( ::oStompFrame:validateCommand(), "should be true with valid command" )

  ::oStompFrame:setCommand( "INVALIDCOMMAND" )
  ::assertFalse( ::oStompFrame:validateCommand(), "should be true with valid command" )

  RETURN ( NIL )

METHOD testHeaderExists() CLASS TTestStompFrame
    LOCAL oHeader

    oHeader := TStompFrameHeader():new( "name", "value" )
    ::oStompFrame:addHeader( oHeader )

    ::assertTrue( ::oStompFrame:headerExists( "name" ), "should return .T. after added the checked header name" )
    ::assertFalse( ::oStompFrame:headerExists( "inexistent" ), "should return .F. checking for unexisting header name")

    oHeader := TStompFrameHeader():new( "other", "value" )
    ::oStompFrame:addHeader( oHeader )
    oHeader := TStompFrameHeader():new( "another", "value" )
    ::oStompFrame:addHeader( oHeader )

    ::assertTrue( ::oStompFrame:headerExists( "another" ), "checking third header shoud be true" )

  RETURN ( NIL )

METHOD testValidateConnectRequiredHeaders() CLASS TTestStompFrame
  LOCAL oHeader

  ::oStompFrame:setCommand( "CONNECT" )
  ::assertFalse( ::oStompFrame:validateHeader(), "should be false CONNECT without required headers")

  oHeader := TStompFrameHeader():new( "accept-version", "1.2" )
  ::oStompFrame:addHeader( oHeader )
  ::assertFalse( ::oStompFrame:validateHeader(), "should be false CONNECT with just one required header" )

  ::oStompFrame:setCommand( "STOMP" ) // since 1.2 CONNECT or STOMP can be used
  oHeader := TStompFrameHeader():new( "host", "127.0.0.1" )
  ::oStompFrame:addHeader( oHeader )
  ::assertTrue( ::oStompFrame:validateHeader(), "should be true CONNECT with all required headers" )

  RETURN ( NIL )

METHOD testValidateConnectedSendRequiredHeaders() CLASS TTestStompFrame
  LOCAL oHeader

  ::oStompFrame:setCommand( "SEND" )
  ::assertFalse( ::oStompFrame:validateHeader(), "should be false CONNECT without required headers")

  oHeader := TStompFrameHeader():new( "destination", "/queue/1" )
  ::oStompFrame:addHeader( oHeader )
  ::assertTrue( ::oStompFrame:validateHeader(), "should be true with destination required header" )

  RETURN ( NIL )

METHOD testValidateCommandSubscribeHeaders() CLASS TTestStompFrame
  LOCAL oHeader

  ::oStompFrame:setCommand( "SUBSCRIBE" )
  ::assertFalse( ::oStompFrame:validateHeader(), "should be false SUBSCRIBE without required headers")

  oHeader := TStompFrameHeader():new( "destination", "/queue/2" )
  ::oStompFrame:addHeader( oHeader )
  ::assertFalse( ::oStompFrame:validateHeader(), "should be false SUBSCRIBE with just one required header" )

  oHeader := TStompFrameHeader():new( "id", "123" )
  ::oStompFrame:addHeader( oHeader )
  ::assertTrue( ::oStompFrame:validateHeader(), "should be true SUBSCRIBE with all required headers" )

  RETURN ( NIL )

METHOD testValidateCommandUnsubscribeHeaders() CLASS TTestStompFrame
  LOCAL oHeader

  ::oStompFrame:setCommand( "UNSUBSCRIBE" )
  ::assertFalse( ::oStompFrame:validateHeader(), "should be false UNSUBSCRIBE without required headers")

  oHeader := TStompFrameHeader():new( "id", "123" )
  ::oStompFrame:addHeader( oHeader )
  ::assertTrue( ::oStompFrame:validateHeader(), "should be true UNSUBSCRIBE with id required header" )

  RETURN ( NIL )

METHOD testValidateCommandAckHeaders() CLASS TTestStompFrame
  LOCAL oHeader

  ::oStompFrame:setCommand( "ACK" )
  ::assertFalse( ::oStompFrame:validateHeader(), "should be false ACK without required headers")

  oHeader := TStompFrameHeader():new( "id", "123" )
  ::oStompFrame:addHeader( oHeader )
  ::assertTrue( ::oStompFrame:validateHeader(), "should be true ACK with id required header" )

  RETURN ( NIL )

METHOD testValidateCommandNackHeaders() CLASS TTestStompFrame
  LOCAL oHeader

  ::oStompFrame:setCommand( "NACK" )
  ::assertFalse( ::oStompFrame:validateHeader(), "should be false NACK without required headers")

  oHeader := TStompFrameHeader():new( "id", "123" )
  ::oStompFrame:addHeader( oHeader )
  ::assertTrue( ::oStompFrame:validateHeader(), "should be true NACK with id required header" )

  RETURN ( NIL )

METHOD testValidateCommandBeginHeaders() CLASS TTestStompFrame
  LOCAL oHeader

  ::oStompFrame:setCommand( "BEGIN" )
  ::assertFalse( ::oStompFrame:validateHeader(), "should be false BEGIN without required headers")

  oHeader := TStompFrameHeader():new( "transaction", "123" )
  ::oStompFrame:addHeader( oHeader )
  ::assertTrue( ::oStompFrame:validateHeader(), "should be true BEGIN with id required header" )

  RETURN ( NIL )

METHOD testValidateCommandCommitHeaders() CLASS TTestStompFrame

  ::oStompFrame:setCommand( "COMMIT" )
  ::assertFalse( ::oStompFrame:validateHeader(), "should be false COMMIT without required headers")

  oHeader := TStompFrameHeader():new( "transaction", "123" )
  ::oStompFrame:addHeader( oHeader )
  ::assertTrue( ::oStompFrame:validateHeader(), "should be true COMMIT with id required header" )

METHOD testValidateCommandAbortHeaders() CLASS TTestStompFrame
  LOCAL oHeader

  ::oStompFrame:setCommand( "ABORT" )
  ::assertFalse( ::oStompFrame:validateHeader(), "should be false ABORT without required headers")

  oHeader := TStompFrameHeader():new( "transaction", "123" )
  ::oStompFrame:addHeader( oHeader )
  ::assertTrue( ::oStompFrame:validateHeader(), "should be true ABORT with id required header" )

  RETURN ( NIL )

METHOD testValidateCommandsMustNotHaveBody() CLASS TTestStompFrame
  LOCAL cBody

  ::oStompFrame:setBody("body")
  ::oStompFrame:setCommand("SUBSCRIBE")
  ::assertFalse( ::oStompFrame:validateBody(), "should be false SUBSCRIBE with a body" )
  ::oStompFrame:setCommand("UNSUBSCRIBE")
  ::assertFalse( ::oStompFrame:validateBody(), "should be false UNSUBSCRIBE with a body" )
  ::oStompFrame:setCommand("BEGIN")
  ::assertFalse( ::oStompFrame:validateBody(), "should be false BEGIN with a body" )
  ::oStompFrame:setCommand("COMMIT")
  ::assertFalse( ::oStompFrame:validateBody(), "should be false COMMIT with a body" )
  ::oStompFrame:setCommand("ABORT")
  ::assertFalse( ::oStompFrame:validateBody(), "should be false ABORT with a body" )
  ::oStompFrame:setCommand("ACK")
  ::assertFalse( ::oStompFrame:validateBody(), "should be false ACK with a body" )
  ::oStompFrame:setCommand("NACK")
  ::assertFalse( ::oStompFrame:validateBody(), "should be false NACK with a body" )
  ::oStompFrame:setCommand("DISCONNECT")
  ::assertFalse( ::oStompFrame:validateBody(), "should be false DISCONNECT with a body" )

  RETURN ( NIL )

METHOD testParseConnectFrame() CLASS TTestStompFrame
  LOCAL cStompFrame := "", oParsedFrame, oError

  // EOL is optional CR + LF or obrigatory LF
  cStompFrame += "COMMAND"        + CHR_CRLF
  cStompFrame += "header1:value1" + CHR_LF
  cStompFrame += "header2:value2" + CHR_CRLF
  cStompFrame += CHR_CRLF
  cStompFrame += "Body"           + CHR_NULL
  cStompFrame += CHR_CRLF         // OPTIONAL

  oParsedFrame := ::oStompFrame():new()
  oParsedFrame:parse( cStompFrame )

  ::assertEquals( "COMMAND", oParsedFrame:cCommand, "oParsedFrame:cCommand should be 'COMMAND'" )
  ::assertEquals( "header1", oParsedFrame:aHeaders[1]:cName, "oParsedFrame:aHeaders[1]:cName should be 'header1'" )
  ::assertEquals( "value1", oParsedFrame:aHeaders[1]:cValue, "oParsedFrame:aHeaders[1]:cValue should be 'value1'" )
  ::assertEquals( "header2", oParsedFrame:aHeaders[2]:cName, "oParsedFrame:aHeaders[2]:cName should be 'header2'" )
  ::assertEquals( "value2", oParsedFrame:aHeaders[2]:cValue, "oParsedFrame:aHeaders[2]:cValue should be 'value2'" )
  ::assertEquals( "Body", oParsedFrame:cBody, "oParsedFrame:cBody should be 'Body'" )

  RETURN ( NIL )

METHOD testIsValid() CLASS TTestStompFrame
  LOCAL oHeader

  ::oStompFrame:setCommand( "SEND" )

  ::assertFalse( ::oStompFrame:isValid(), "should return false for an incomplete frame" )

  oHeader := TStompFrameHeader():new( "destination", "/queue/1" )
  ::oStompFrame:addHeader( oHeader )
  ::oStompFrame:setBody("body")

  ::assertTrue( ::oStompFrame:isValid(), "should return true for a complete valid frame" )

  RETURN ( NIL )