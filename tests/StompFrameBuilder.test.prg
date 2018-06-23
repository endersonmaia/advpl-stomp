#include "stomp.ch"

CLASS TTestStompFrameBuilder FROM TTestCase

  METHOD testBuildConnectFrame()
  METHOD testBuildDisconectFrame()
  METHOD testBuildConnectFrameWithoutHost()
  METHOD testBuildConnectFrameWithLoginInfo()
  METHOD testBuildSubscribeFrame()
  METHOD testBuildAckFrame()
  METHOD testBuildNackFrame()

ENDCLASS

METHOD testBuildConnectFrame() CLASS TTestStompFrameBuilder
  LOCAL oStompFrame

  oStompFrame := TStompFrameBuilder():buildConnectFrame( "127.0.0.1" )

  ::assert:true( oStompFrame:isValid(), "frame should be valid")
  ::assert:equals( oStompFrame:cCommand, STOMP_CLIENT_COMMAND_STOMP,  "Frame command should be STOMP" )
  ::assert:equals( oStompFrame:getHeaderValue( STOMP_ACCEPT_VERSION_HEADER ), STOMP_ACCEPTED_VERSIONS, "accepted-versions header should default" )
  ::assert:equals( oStompFrame:getHeaderValue("host"), "127.0.0.1", "header host should be '127.0.0.1'" )

  RETURN ( nil )

METHOD testBuildConnectFrameWithoutHost() CLASS TTestStompFrameBuilder
  LOCAL oStompFrame

  oStompFrame := TStompFrameBuilder():buildConnectFrame(,,)
  ::assert:false( oStompFrame:isValid(), "frame should not be valid without host")

  RETURN ( nil )

METHOD testBuildConnectFrameWithLoginInfo() CLASS TTestStompFrameBuilder
  LOCAL oStompFrame

  oStompFrame := TStompFrameBuilder():buildConnectFrame( , 'user', 'pass' )
  ::assert:true( oStompFrame:headerExists(STOMP_LOGIN_HEADER), "header login should exist" )
  ::assert:true( oStompFrame:headerExists(STOMP_PASSCODE_HEADER), "header passcode should exist" )

  RETURN ( nil )


METHOD testBuildDisconectFrame() CLASS TTestStompFrameBuilder
  LOCAL oStompFrame

  oStompFrame := TStompFrameBuilder():buildDisconnectFrame( "receipt-1" )

  ::assert:true( oStompFrame:isValid(), "frame should be valid" )
  ::assert:equals( oStompFrame:cCommand, STOMP_CLIENT_COMMAND_DISCONNECT, "Frame command should be DISCONNECT" )

 RETURN ( nil )

 METHOD testBuildSubscribeFrame() CLASS TTestStompFrameBuilder
   LOCAL oStompFrame

   oStompFrame := TStompFrameBuilder():buildSubscribeFrame( "/queue/destination" )

   ::assert:true( oStompFrame:isValid(), "frame should be valid" )
   ::assert:equals( oStompFrame:cCommand, STOMP_CLIENT_COMMAND_SUBSCRIBE, "Frame command should be SUBSCRIBE" )
   ::assert:equals( LEN( oStompFrame:getHeaderValue( STOMP_ID_HEADER ) ), LEN( HBSTOMP_IDS_PREFIX ) + HBSTOMP_IDS_LENGHT, "the size of id header should match" )

 RETURN ( nil )

 METHOD testBuildAckFrame() CLASS TTestStompFrameBuilder
   LOCAL oStompFrame

   oStompFrame := TStompFrameBuilder():buildAckFrame( "ack-id-01" )

   ::assert:true( oStompFrame:isValid(), "frame should be valid" )
   ::assert:equals( oStompFrame:cCommand, STOMP_CLIENT_COMMAND_ACK, "Frame command should be ACK" )
   ::assert:equals( oStompFrame:getHeaderValue( STOMP_ID_HEADER), "ack-id-01", "header id should be ack-id-01" )

 RETURN ( nil )

 METHOD testBuildNackFrame() CLASS TTestStompFrameBuilder
   LOCAL oStompFrame

   oStompFrame := TStompFrameBuilder():buildNackFrame( "ack-id-01" )

   ::assert:true( oStompFrame:isValid(), "frame should be valid" )
   ::assert:equals( oStompFrame:cCommand, STOMP_CLIENT_COMMAND_NACK, "Frame command should be NACK" )
   ::assert:equals( oStompFrame:getHeaderValue( STOMP_ID_HEADER), "ack-id-01", "header id should be ack-id-01" )

 RETURN ( nil )