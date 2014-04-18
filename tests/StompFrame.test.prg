#include "hbclass.ch"

CLASS TTestStompFrame INHERIT TTestCase

  METHOD testSetBody()
  METHOD testSetCommand()
  METHOD testAddHeader()
  METHOD testCountHeaders()
  METHOD testValidateCommand()
  METHOD testHeaderExists()
  METHOD testValidateConnectRequiredHeaders()
  METHOD testValidateConnectedSendRequiredHeaders()
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

  // REQUIRED FOR CONNECT - accept-version, host
  ::assertFalse( ::oStompFrame:validateHeader(), "should be false CONNECT without required headers")

  oHeader := TStompFrameHeader():new( "accept-version", "1.2" )
  ::oStompFrame:addHeader( oHeader )
  ::assertFalse( ::oStompFrame:validateHeader(), "should be false with just onde required header" )

  ::oStompFrame:setCommand( "STOMP" ) // since 1.2 CONNECT or STOMP can be used
  oHeader := TStompFrameHeader():new( "host", "127.0.0.1" )
  ::oStompFrame:addHeader( oHeader )
  ::assertTrue( ::oStompFrame:validateHeader(), "should be true with all required headers" )

  RETURN ( NIL )

METHOD testValidateConnectedSendRequiredHeaders() CLASS TTestStompFrame
  LOCAL oHeader

  ::oStompFrame:setCommand( "SEND" )

  // REQUIRED FOR SEND - destination
  ::assertFalse( ::oStompFrame:validateHeader(), "should be false CONNECT without required headers")

  oHeader := TStompFrameHeader():new( "destination", "/queue/1" )
  ::oStompFrame:addHeader( oHeader )
  ::assertTrue( ::oStompFrame:validateHeader(), "should be true with destination required header" )

  RETURN ( NIL )

METHOD testIsValid() CLASS TTestStompFrame
  LOCAL oHeader

  ::oStompFrame:setCommand( "SEND" )

  ::assertFalse( ::oStompFrame:isValid(), "should return false for an incomplete frame" )

  oHeader := TStompFrameHeader():new( "destination", "/queue/1" )
  ::oStompFrame:addHeader( oHeader )

  ::assertTrue( ::oStompFrame:isValid(), "should return true for a complete valid frame" )

  RETURN ( NIL )