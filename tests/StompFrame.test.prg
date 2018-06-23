#include "stomp.ch"

CLASS TTestStompFrame FROM TTestCase

  METHOD testSetBody()
  METHOD testSetCommand()
  METHOD testAddHeader()
  METHOD testCountHeaders()
  METHOD testValidateCommand()
  METHOD testHeaderExists()
  METHOD testGetHeaderValue()
  METHOD testValidateConnectRequiredHeaders()
  METHOD testValidateConnectedSendRequiredHeaders()
  METHOD testValidateCommandSubscribeHeaders()
  METHOD testValidateSubscribeAckModes()
  METHOD testValidateCommandUnsubscribeHeaders()
  METHOD testValidateCommandBeginHeaders()
  METHOD testValidateCommandCommitHeaders()
  METHOD testValidateCommandAbortHeaders()
  METHOD testValidateCommandAckHeaders()
  METHOD testValidateCommandNackHeaders()
  METHOD testValidateCommandsMustNotHaveBody()
  METHOD testParseOneFrame()
  METHOD testParseTwoFrames()
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

  ::assert:equals( "corpo", ::oStompFrame:cBody, "cBody should be corpo")

  RETURN ( NIL )

METHOD testSetCommand() CLASS TTestStompFrame

  ::oStompFrame:setCommand( "CONNECT" )
  ::assert:equals( "CONNECT", ::oStompFrame:cCommand,  "cCommand should be CONNECT." )

  ::oStompFrame:setCommand( "send" )
  ::assert:equals( "SEND", ::oStompFrame:cCommand,  "setCommand('send') should set CONNECT (upper-case)." )

  RETURN ( NIL )

METHOD testAddHeader() CLASS TTestStompFrame

  ::oStompFrame:addHeader( TStompFrameHeader():new( "name", "value" ) )

  ::assert:equals( "name", ::oStompFrame:aHeaders[1]:getName(), "oHeader:getName() should be name")
  ::assert:equals( "value", ::oStompFrame:aHeaders[1]:getValue(), "oHeader:getValue() should be value")

  RETURN ( NIL )


METHOD testCountHeaders() CLASS TTestStompFrame

  ::assert:equals( 0, ::oStompFrame:countHeaders(), "StompFrame:countHeaders() should return 0 (zero) when no headers is addes to StompFrame" )

  ::oStompFrame:addHeader( TStompFrameHeader():new( "name", "value" ) )
  ::assert:equals( 1, ::oStompFrame:countHeaders(), "StompFrame:countHeaders() should return 1 (one)" )

  ::oStompFrame:addHeader( TStompFrameHeader():new( "other", "value" ) )
  ::assert:equals( 2, ::oStompFrame:countHeaders(), "StompFrame:countHeaders() should return 2 (two)" )

  RETURN ( NIL )

METHOD testValidateCommand() CLASS TTestStompFrame

  ::clearFrame()
  ::assert:false( ::oStompFrame:isValid(), "should be false when stompframe has no command" )

  ::oStompFrame:setCommand( "DISCONNECT" )
  ::assert:true( ::oStompFrame:isValid(), "should be true with valid command" )

  ::oStompFrame:setCommand( "INVALIDCOMMAND" )
  ::assert:false( ::oStompFrame:isValid(), "should be true with valid command" )

  RETURN ( NIL )

METHOD testHeaderExists() CLASS TTestStompFrame

    ::oStompFrame:addHeader( TStompFrameHeader():new( "name", "value" ) )

    ::assert:true( ::oStompFrame:headerExists( "name" ), "should return .T. after added the checked header name" )
    ::assert:false( ::oStompFrame:headerExists( "inexistent" ), "should return .F. checking for unexisting header name")

    ::oStompFrame:addHeader( TStompFrameHeader():new( "other", "value" ) )
    ::oStompFrame:addHeader( TStompFrameHeader():new( "another", "value" ) )

    ::assert:true( ::oStompFrame:headerExists( "another" ), "checking third header shoud be true" )

  RETURN ( NIL )

METHOD testGetHeaderValue() CLASS TTestStompFrame

  ::oStompFrame:addHeader( TStompFrameHeader():new( "name", "value" ) )

  ::assert:equals( "value", ::oStompFrame:getHeaderValue("name"), "should be true for an existant header")

  ::assert:null( ::oStompFrame:getHeaderValue("noheader"), "should be nil searching for an unexistant header" )

  RETURN ( NIL )

METHOD testValidateConnectRequiredHeaders() CLASS TTestStompFrame

  ::clearFrame()
  ::oStompFrame:setCommand( "CONNECT" )
  ::assert:false( ::oStompFrame:isValid(), "should be false CONNECT without required headers")
  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ACCEPT_VERSION_HEADER, "1.2" ) )
  ::assert:false( ::oStompFrame:isValid(), "should be false CONNECT with just one required header" )
  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_HOST_HEADER, "127.0.0.1" ) )
  ::assert:true( ::oStompFrame:isValid(), "should be true CONNECT with all required headers" )

  RETURN ( NIL )

METHOD testValidateConnectedSendRequiredHeaders() CLASS TTestStompFrame

  ::clearFrame()
  ::oStompFrame:setCommand( "SEND" )
  ::assert:false( ::oStompFrame:isValid(), "should be false CONNECT without required headers")

  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_DESTINATION_HEADER, "/queue/1" ) )
  ::assert:true( ::oStompFrame:isValid(), "should be true with destination required header" )

  RETURN ( NIL )

METHOD testValidateCommandSubscribeHeaders() CLASS TTestStompFrame

  ::oStompFrame:setCommand( "SUBSCRIBE" )
  ::assert:false( ::oStompFrame:isValid(), "should be false SUBSCRIBE without required headers")

  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_DESTINATION_HEADER, "/queue/2" ) )
  ::assert:false( ::oStompFrame:isValid(), "should be false SUBSCRIBE with just one required header" )

  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ID_HEADER, "123" ) )
  ::assert:true( ::oStompFrame:isValid(), "should be true SUBSCRIBE with all required headers" )

  RETURN ( NIL )

METHOD testValidateSubscribeAckModes() CLASS TTestStompFrame

  ::oStompFrame:setCommand( "SUBSCRIBE" )
  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_DESTINATION_HEADER, "/queue/2" ) )
  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ID_HEADER, "123" ) )
  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ACK_HEADER, "client" ) )
  ::assert:true( ::oStompFrame:isValid(), "should be true SUBSCRIBE with a valid ACK mode" )

  ::oStompFrame:removeAllHeaders()
  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_DESTINATION_HEADER, "/queue/2" ) )
  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ID_HEADER, "123" ) )
  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ACK_HEADER, "INVALID" ) )
  ::assert:false( ::oStompFrame:isValid(), "should be false SUBSCRIBE with an invalid ACK mode" )

  RETURN ( NIL )

METHOD testValidateCommandUnsubscribeHeaders() CLASS TTestStompFrame

  ::oStompFrame:setCommand( "UNSUBSCRIBE" )
  ::assert:false( ::oStompFrame:isValid(), "should be false UNSUBSCRIBE without required headers")

  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ID_HEADER, "123" ) )
  ::assert:true( ::oStompFrame:isValid(), "should be true UNSUBSCRIBE with id required header" )

  RETURN ( NIL )

METHOD testValidateCommandAckHeaders() CLASS TTestStompFrame

  ::oStompFrame:setCommand( "ACK" )
  ::assert:false( ::oStompFrame:isValid(), "should be false ACK without required headers")

  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ID_HEADER, "123" ) )
  ::assert:true( ::oStompFrame:isValid(), "should be true ACK with id required header" )

  RETURN ( NIL )

METHOD testValidateCommandNackHeaders() CLASS TTestStompFrame

  ::oStompFrame:setCommand( "NACK" )
  ::assert:false( ::oStompFrame:isValid(), "should be false NACK without required headers")

  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ID_HEADER, "123" ) )
  ::assert:true( ::oStompFrame:isValid(), "should be true NACK with id required header" )

  RETURN ( NIL )

METHOD testValidateCommandBeginHeaders() CLASS TTestStompFrame

  ::oStompFrame:setCommand( "BEGIN" )
  ::assert:false( ::oStompFrame:isValid(), "should be false BEGIN without required headers")

  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_TRANSACTION_HEADER, "123" ) )
  ::assert:true( ::oStompFrame:isValid(), "should be true BEGIN with id required header" )

  RETURN ( NIL )

METHOD testValidateCommandCommitHeaders() CLASS TTestStompFrame

  ::oStompFrame:setCommand( "COMMIT" )
  ::assert:false( ::oStompFrame:isValid(), "should be false COMMIT without required headers")

  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_TRANSACTION_HEADER, "123" ) )
  ::assert:true( ::oStompFrame:isValid(), "should be true COMMIT with id required header" )

METHOD testValidateCommandAbortHeaders() CLASS TTestStompFrame

  ::oStompFrame:setCommand( "ABORT" )
  ::assert:false( ::oStompFrame:isValid(), "should be false ABORT without required headers")

  ::oStompFrame:addHeader( TStompFrameHeader():new( STOMP_TRANSACTION_HEADER, "123" ) )
  ::assert:true( ::oStompFrame:isValid(), "should be true ABORT with id required header" )

  RETURN ( NIL )

METHOD testValidateCommandsMustNotHaveBody() CLASS TTestStompFrame

  ::clearFrame()
  ::oStompFrame:setBody("body")
  ::oStompFrame:setCommand("SUBSCRIBE")
  ::assert:false( ::oStompFrame:isValid(), "should be false SUBSCRIBE with a body" )
  ::oStompFrame:setCommand("UNSUBSCRIBE")
  ::assert:false( ::oStompFrame:isValid(), "should be false UNSUBSCRIBE with a body" )
  ::oStompFrame:setCommand("BEGIN")
  ::assert:false( ::oStompFrame:isValid(), "should be false BEGIN with a body" )
  ::oStompFrame:setCommand("COMMIT")
  ::assert:false( ::oStompFrame:isValid(), "should be false COMMIT with a body" )
  ::oStompFrame:setCommand("ABORT")
  ::assert:false( ::oStompFrame:isValid(), "should be false ABORT with a body" )
  ::oStompFrame:setCommand("ACK")
  ::assert:false( ::oStompFrame:isValid(), "should be false ACK with a body" )
  ::oStompFrame:setCommand("NACK")
  ::assert:false( ::oStompFrame:isValid(), "should be false NACK with a body" )
  ::oStompFrame:setCommand("DISCONNECT")
  ::assert:false( ::oStompFrame:isValid(), "should be false DISCONNECT with a body" )

  RETURN ( NIL )

METHOD testParseOneFrame() CLASS TTestStompFrame
  LOCAL cStompFrame := "", oParsedFrame, oError

  // EOL is optional CR + LF or obrigatory LF
  cStompFrame += "COMMAND"        + CHR_CRLF
  cStompFrame += "header1:value1" + CHR_LF
  cStompFrame += "header2:value2" + CHR_CRLF
  cStompFrame += CHR_CRLF
  cStompFrame += "Body"           + CHR_NULL
  cStompFrame += CHR_CRLF         // OPTIONAL

  oParsedFrame := TStompFrame():new()
  oParsedFrame := oParsedFrame:parse( @cStompFrame )

  ::assert:equals( "COMMAND", oParsedFrame:cCommand, "oParsedFrame:cCommand should be 'COMMAND'" )
  ::assert:equals( "header1", oParsedFrame:aHeaders[1]:getName(), "oParsedFrame:aHeaders[1]:getName() should be 'header1'" )
  ::assert:equals( "value1", oParsedFrame:aHeaders[1]:getValue(), "oParsedFrame:aHeaders[1]:getValue() should be 'value1'" )
  ::assert:equals( "header2", oParsedFrame:aHeaders[2]:getName(), "oParsedFrame:aHeaders[2]:getName() should be 'header2'" )
  ::assert:equals( "value2", oParsedFrame:aHeaders[2]:getValue(), "oParsedFrame:aHeaders[2]:getValue() should be 'value2'" )
  ::assert:equals( "Body", oParsedFrame:cBody, "oParsedFrame:cBody should be 'Body'" )

  RETURN ( NIL )

METHOD testParseTwoFrames() CLASS TTestStompFrame
  LOCAL cStompFrame    := "", ;
        cStompFrameTwo := "", ;
        cStompFrameOne := "", ;
        oParsedFrame        , ;
        oError

  // EOL is optional CR + LF or obrigatory LF
  cStompFrameOne += "COMMAND_ONE"    + CHR_CRLF
  cStompFrameOne += "header1:value1" + CHR_LF
  cStompFrameOne += "header2:value2" + CHR_CRLF
  cStompFrameOne += CHR_CRLF
  cStompFrameOne += "Body One"       + CHR_NULL
  cStompFrameOne += CHR_CRLF         // OPTIONAL

  // EOL is optional CR + LF or obrigatory LF
  cStompFrameTwo += "COMMAND_TWO"    + CHR_CRLF
  cStompFrameTwo += "header1:value1" + CHR_LF
  cStompFrameTwo += "header2:value2" + CHR_CRLF
  cStompFrameTwo += CHR_CRLF
  cStompFrameTwo += "Body Two SUPER SIZE"       + CHR_NULL
  cStompFrameTwo += CHR_CRLF         // OPTIONAL

  cStompFrame := cStompFrameOne + cStompFrameTwo

  oParsedFrame := TStompFrame():new()
  oParsedFrame := oParsedFrame:parse( @cStompFrame )

  ::assert:equals( "COMMAND_ONE", oParsedFrame:cCommand, "cCommand should be COMMAND_ONE")
  ::assert:equals( "Body One", oParsedFrame:cBody, "cBody shoud be 'Body One'")

  oParsedFrame := oParsedFrame:parse( @cStompFrame )

  ::assert:equals( "COMMAND_TWO", oParsedFrame:cCommand, "cCommand should be COMMAND_TWO")
  ::assert:equals( "Body Two SUPER SIZE", oParsedFrame:cBody, "cBody shoud be 'Body Two'")

  RETURN ( NIL )

METHOD testRemoveAllHeaders() CLASS TTestStompFrame
  ::clearFrame()
  ::oStompFrame:addHeader( TStompFrameHeader():new("header1", "value1"))
  ::oStompFrame:removeAllHeaders()
  ::assert:equals(0, ::oStompFrame:countHeaders(), "::oStompFrame:countHeaders() should be 0 after ::oStompFrame:removeAllHeaders()")
  RETURN ( nil )