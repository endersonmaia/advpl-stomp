#include "stomp.ch"

CLASS TTestStompFrameBuilder FROM TTestCase

  METHOD testBuildConnectFrame()
  METHOD testBuildDisconectFrame()

ENDCLASS

METHOD testBuildConnectFrame() CLASS TTestStompFrameBuilder
  LOCAL oStompFrame

  oStompFrame := TStompFrameBuilder():buildConnectFrame( "127.0.0.1" )

  ::assert:true( oStompFrame:isValid(), "frame should be valid")
  ::assert:equals( oStompFrame:cCommand, STOMP_CLIENT_COMMAND_STOMP,  "Frame command should be STOMP" )
  ::assert:equals( oStompFrame:getHeaderValue( STOMP_ACCEPT_VERSION_HEADER ), STOMP_ACCEPTED_VERSIONS, "accepted-versions header should default" )
  ::assert:equals( oStompFrame:getHeaderValue("host"), "127.0.0.1", "header host should be '127.0.0.1'" )

  RETURN ( nil )

 METHOD testBuildDisconectFrame() CLASS TTestStompFrameBuilder
  LOCAL oStompFrame

  oStompFrame := TStompFrameBuilder():buildDisconnectFrame( "receipt-1" )

  ::assert:true( oStompFrame:isValid(), "frame should be valid" )
  ::assert:equals( oStompFrame:cCommand, STOMP_CLIENT_COMMAND_DISCONNECT, "Frame command should be DISCONNECT" )

 RETURN ( nil )