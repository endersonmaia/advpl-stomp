#include "stomp.ch"

CLASS TStompFrameBuilder

  METHOD buildConnectFrame( cHost )
  METHOD buildSendFrame( cDestination, cMessage )
  METHOD buildSubscribeFrame( cDestination, cID )
  METHOD buildDisconnectFrame( cReceipt )

ENDCLASS

METHOD buildConnectFrame( cHost ) CLASS TStompFrameBuilder
  LOCAL oStompFrame

  oStompFrame := TStompFrame():new()
  oStompFrame:setCommand( STOMP_CLIENT_COMMAND_STOMP )
  oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ACCEPT_VERSION_HEADER, STOMP_ACCEPTED_VERSIONS ) )
  oStompFrame:addHeader( TStompFrameHeader():new( STOMP_HOST_HEADER, cHost ) )

  RETURN ( oStompFrame )

METHOD buildSendFrame( cDestination, cMessage ) CLASS TStompFrameBuilder
  LOCAL oStompFrame

  oStompFrame := TStompFrame():new()
  oStompFrame:setCommand( STOMP_CLIENT_COMMAND_SEND )
  oStompFrame:addHeader( TStompFrameHeader():new( STOMP_DESTINATION_HEADER, cDestination ) )
  oStompFrame:setBody( cMessage )

  RETURN ( oStompFrame )

METHOD buildDisconnectFrame() CLASS TStompFrameBuilder
  LOCAL oStompFrame

  oStompFrame := TStompFrame():new()
  oStompFrame:setCommand( STOMP_CLIENT_COMMAND_DISCONNECT )

  RETURN ( oStompFrame )

METHOD buildSubscribeFrame( cDestination, cID ) CLASS TStompFrameBuilder
  LOCAL oStompFrame

  oStompFrame := TStompFrame():new()
  oStompFrame:setCommand( STOMP_CLIENT_COMMAND_SUBSCRIBE )
  oStompFrame:addHeader( TStompFrameHeader():new( STOMP_DESTINATION_HEADER, cDestination ) )
  oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ID_HEADER, cID ) )

  RETURN ( oStompFrame )