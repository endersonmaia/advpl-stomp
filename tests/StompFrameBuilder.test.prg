#include "stomp.ch"
#include "hbclass.ch"
#include "xhb.ch"

CLASS TTestStompFrameBuilder INHERIT TTestCase

  METHOD testBuildConnectFrame()
  METHOD testBuildDisconectFrame()

ENDCLASS

METHOD testBuildConnectFrame() CLASS TTestStompFrameBuilder
  LOCAL oStompFrame

  oStompFrame := TStompFrameBuilder():buildConnectFrame( "127.0.0.1" )

  ::assertTrue( oStompFrame:isValid(), "frame should be valid")
  ::assertEquals( oStompFrame:cCommand, STOMP_CLIENT_COMMAND_STOMP,  "Frame command should be STOMP" )
  ::assertEquals( oStompFrame:getHeaderValue( STOMP_ACCEPT_VERSION_HEADER ), STOMP_ACCEPTED_VERSIONS, "accepted-versions header should default" )
  ::assertEquals( oStompFrame:getHeaderValue("host"), "127.0.0.1", "header host should be '127.0.0.1'" )

  RETURN ( nil )

 METHOD testBuildDisconectFrame() CLASS TTestStompFrameBuilder
  LOCAL oStompFrame

  oStompFrame := TStompFrameBuilder():buildDisconnectFrame( "receipt-1" )

  ::assertTrue( oStompFrame:isValid(), "frame should be valid" )
  ::assertEquals( oStompFrame:cCommand, STOMP_CLIENT_COMMAND_DISCONNECT, "Frame command should be DISCONNECT" )

 RETURN ( nil )