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
  METHOD testRemoveAllHeaders()

  METHOD Setup()
  METHOD Teardown()
  METHOD clearFrame()

  DATA oStompFrame

ENDCLASS

METHOD Setup() CLASS TTestStompFrame
	::oStompFrame := TStompFrame():new()
  RETURN ( NIL )

METHOD Teardown() CLASS TTestStompFrame
  ::oStompFrame := NIL
  RETURN ( NIL )

METHOD clearFrame() CLASS TTestStompFrame
  ::oStompFrame:setBody( "" )
  ::oStompFrame:setCommand( "" )
  ::oStompFrame:removeAllHeaders()

  RETURN ( nil )

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
  
  ::oStompFrame:addHeader( TStompFrameHeader():new( "name", "value" ) )

  ::assertEquals( "name", ::oStompFrame:aHeaders[1]:cName, "oHeader:cName should be name")
  ::assertEquals( "value", ::oStompFrame:aHeaders[1]:cValue, "oHeader:cValue should be value")

  RETURN ( NIL )


METHOD testCountHeaders() CLASS TTestStompFrame

  ::assertEquals( 0, ::oStompFrame:countHeaders(), "StompFrame:countHeaders() should return 0 (zero) when no headers is addes to StompFrame" )

  ::oStompFrame:addHeader( TStompFrameHeader():new( "name", "value" ) )
  ::assertEquals( 1, ::oStompFrame:countHeaders(), "StompFrame:countHeaders() should return 1 (one)" )

  ::oStompFrame:addHeader( TStompFrameHeader():new( "other", "value" ) )
  ::assertEquals( 2, ::oStompFrame:countHeaders(), "StompFrame:countHeaders() should return 2 (two)" )

  RETURN ( NIL )

METHOD testValidateCommand() CLASS TTestStompFrame
  
  ::clearFrame()
  ::assertFalse( ::oStompFrame:isValid(), "should be false when stompframe has no command" )

  ::oStompFrame:setCommand( "DISCONNECT" )
  ::assertTrue( ::oStompFrame:isValid(), "should be true with valid command" )

  ::oStompFrame:setCommand( "INVALIDCOMMAND" )
  ::assertFalse( ::oStompFrame:isValid(), "should be true with valid command" )

  RETURN ( NIL )

METHOD testHeaderExists() CLASS TTestStompFrame

    ::oStompFrame:addHeader( TStompFrameHeader():new( "name", "value" ) )

    ::assertTrue( ::oStompFrame:headerExists( "name" ), "should return .T. after added the checked header name" )
    ::assertFalse( ::oStompFrame:headerExists( "inexistent" ), "should return .F. checking for unexisting header name")

    ::oStompFrame:addHeader( TStompFrameHeader():new( "other", "value" ) )
    ::oStompFrame:addHeader( TStompFrameHeader():new( "another", "value" ) )

    ::assertTrue( ::oStompFrame:headerExists( "another" ), "checking third header shoud be true" )

  RETURN ( NIL )

METHOD testValidateConnectRequiredHeaders() CLASS TTestStompFrame

  ::clearFrame()
  ::oStompFrame:setCommand( "CONNECT" )
  ::assertFalse( ::oStompFrame:isValid(), "should be false CONNECT without required headers")
  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ACCEPT_VERSION_HEADER, "1.2" ) )
  ::assertFalse( ::oStompFrame:isValid(), "should be false CONNECT with just one required header" )
  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_HOST_HEADER, "127.0.0.1" ) )
  ::assertTrue( ::oStompFrame:isValid(), "should be true CONNECT with all required headers" )

  ::clearFrame()
  ::oStompFrame:setCommand( "STOMP" )
  ::assertFalse( ::oStompFrame:isValid(), "should be false STOMP without required headers")
  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ACCEPT_VERSION_HEADER, "1.2" ) )
  ::assertFalse( ::oStompFrame:isValid(), "should be false STOMP with just one required header" )
  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_HOST_HEADER, "127.0.0.1" ) )
  ::assertTrue( ::oStompFrame:isValid(), "should be true STOMP with all required headers" )

  RETURN ( NIL )

METHOD testValidateConnectedSendRequiredHeaders() CLASS TTestStompFrame
  
  ::clearFrame()
  ::oStompFrame:setCommand( "SEND" )
  ::assertFalse( ::oStompFrame:isValid(), "should be false CONNECT without required headers")

  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_DESTINATION_HEADER, "/queue/1" ) )
  ::assertTrue( ::oStompFrame:isValid(), "should be true with destination required header" )

  RETURN ( NIL )

METHOD testValidateCommandSubscribeHeaders() CLASS TTestStompFrame
  
  ::oStompFrame:setCommand( "SUBSCRIBE" )
  ::assertFalse( ::oStompFrame:isValid(), "should be false SUBSCRIBE without required headers")

  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_DESTINATION_HEADER, "/queue/2" ) )
  ::assertFalse( ::oStompFrame:isValid(), "should be false SUBSCRIBE with just one required header" )

  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ID_HEADER, "123" ) )
  ::assertTrue( ::oStompFrame:isValid(), "should be true SUBSCRIBE with all required headers" )

  RETURN ( NIL )

METHOD testValidateCommandUnsubscribeHeaders() CLASS TTestStompFrame
  
  ::oStompFrame:setCommand( "UNSUBSCRIBE" )
  ::assertFalse( ::oStompFrame:isValid(), "should be false UNSUBSCRIBE without required headers")

  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ID_HEADER, "123" ) )
  ::assertTrue( ::oStompFrame:isValid(), "should be true UNSUBSCRIBE with id required header" )

  RETURN ( NIL )

METHOD testValidateCommandAckHeaders() CLASS TTestStompFrame

  ::oStompFrame:setCommand( "ACK" )
  ::assertFalse( ::oStompFrame:isValid(), "should be false ACK without required headers")

  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ID_HEADER, "123" ) )
  ::assertTrue( ::oStompFrame:isValid(), "should be true ACK with id required header" )

  RETURN ( NIL )

METHOD testValidateCommandNackHeaders() CLASS TTestStompFrame

  ::oStompFrame:setCommand( "NACK" )
  ::assertFalse( ::oStompFrame:isValid(), "should be false NACK without required headers")

  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ID_HEADER, "123" ) )
  ::assertTrue( ::oStompFrame:isValid(), "should be true NACK with id required header" )

  RETURN ( NIL )

METHOD testValidateCommandBeginHeaders() CLASS TTestStompFrame

  ::oStompFrame:setCommand( "BEGIN" )
  ::assertFalse( ::oStompFrame:isValid(), "should be false BEGIN without required headers")

  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_TRANSACTION_HEADER, "123" ) )
  ::assertTrue( ::oStompFrame:isValid(), "should be true BEGIN with id required header" )

  RETURN ( NIL )

METHOD testValidateCommandCommitHeaders() CLASS TTestStompFrame

  ::oStompFrame:setCommand( "COMMIT" )
  ::assertFalse( ::oStompFrame:isValid(), "should be false COMMIT without required headers")

  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_TRANSACTION_HEADER, "123" ) )
  ::assertTrue( ::oStompFrame:isValid(), "should be true COMMIT with id required header" )

METHOD testValidateCommandAbortHeaders() CLASS TTestStompFrame

  ::oStompFrame:setCommand( "ABORT" )
  ::assertFalse( ::oStompFrame:isValid(), "should be false ABORT without required headers")

  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_TRANSACTION_HEADER, "123" ) )
  ::assertTrue( ::oStompFrame:isValid(), "should be true ABORT with id required header" )

  RETURN ( NIL )

METHOD testValidateCommandsMustNotHaveBody() CLASS TTestStompFrame
  
  ::clearFrame()
  ::oStompFrame:setBody("body")
  ::oStompFrame:setCommand("SUBSCRIBE")
  ::assertFalse( ::oStompFrame:isValid(), "should be false SUBSCRIBE with a body" )
  ::oStompFrame:setCommand("UNSUBSCRIBE")
  ::assertFalse( ::oStompFrame:isValid(), "should be false UNSUBSCRIBE with a body" )
  ::oStompFrame:setCommand("BEGIN")
  ::assertFalse( ::oStompFrame:isValid(), "should be false BEGIN with a body" )
  ::oStompFrame:setCommand("COMMIT")
  ::assertFalse( ::oStompFrame:isValid(), "should be false COMMIT with a body" )
  ::oStompFrame:setCommand("ABORT")
  ::assertFalse( ::oStompFrame:isValid(), "should be false ABORT with a body" )
  ::oStompFrame:setCommand("ACK")
  ::assertFalse( ::oStompFrame:isValid(), "should be false ACK with a body" )
  ::oStompFrame:setCommand("NACK")
  ::assertFalse( ::oStompFrame:isValid(), "should be false NACK with a body" )
  ::oStompFrame:setCommand("DISCONNECT")
  ::assertFalse( ::oStompFrame:isValid(), "should be false DISCONNECT with a body" )

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

METHOD testRemoveAllHeaders() CLASS TTestStompFrame
  ::clearFrame()
  ::oStompFrame:addHeader( TStompFrameHeader():new("header1", "value1"))
  ::oStompFrame:removeAllHeaders()
  ::assertEquals(0, ::oStompFrame:countHeaders(), "::oStompFrame:countHeaders() should be 0 after ::oStompFrame:removeAllHeaders()")
  RETURN ( nil )