#include "stomp.ch"

CLASS TStompFrameBuilder

  METHOD new() CONSTRUCTOR
  METHOD buildConnectFrame( cHost, cLogin, cPassCode )
  METHOD buildSendFrame( cDestination, cMessage )
  METHOD buildSubscribeFrame( cDestination )
  METHOD buildDisconnectFrame( cReceipt )
  METHOD buildAckFrame( cMessageId )
  METHOD buildNackFrame( cMessageId )

ENDCLASS

METHOD new() CLASS TStompFrameBuilder
  RETURN ( SELF )

//TODO - implement build of heart-beat header for CONNECT frame
METHOD buildConnectFrame( cHost, cLogin, cPassCode ) CLASS TStompFrameBuilder
  LOCAL oStompFrame

  oStompFrame := TStompFrame():new()
  oStompFrame:setCommand( STOMP_CLIENT_COMMAND_CONNECT )
  oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ACCEPT_VERSION_HEADER, STOMP_ACCEPTED_VERSIONS ) )

  IF ( ValType(cHost) == 'C' )
    oStompFrame:addHeader( TStompFrameHeader():new( STOMP_HOST_HEADER, cHost) )
  ENDIF

  IF ( ValType(cLogin) == 'C' )
    oStompFrame:addHeader( TStompFrameHeader():new( STOMP_LOGIN_HEADER, cLogin) )
  ENDIF

  IF ( ValType(cPassCode) == 'C' )
    oStompFrame:addHeader( TStompFrameHeader():new( STOMP_PASSCODE_HEADER, cPassCode) )
  ENDIF

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

METHOD buildSubscribeFrame( cDestination ) CLASS TStompFrameBuilder
  LOCAL oStompFrame, cID := ""

  cID := HBSTOMP_IDS_PREFIX + _randomAlphabet( HBSTOMP_IDS_LENGHT )

  oStompFrame := TStompFrame():new()
  oStompFrame:setCommand( STOMP_CLIENT_COMMAND_SUBSCRIBE )
  oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ID_HEADER, cID ) )
  oStompFrame:addHeader( TStompFrameHeader():new( STOMP_DESTINATION_HEADER, cDestination ) )

  RETURN ( oStompFrame )

METHOD buildAckFrame( cMessageId ) CLASS TStompFrameBuilder
  LOCAL oStompFrame

  oStompFrame := TStompFrame():new()
  oStompFrame:setCommand( STOMP_CLIENT_COMMAND_ACK )
  oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ID_HEADER, cMessageId ) )

  RETURN ( oStompFrame )

METHOD buildNackFrame( cMessageId ) CLASS TStompFrameBuilder
  LOCAL oStompFrame

  oStompFrame := TStompFrame():new()
  oStompFrame:setCommand( STOMP_CLIENT_COMMAND_NACK )
  oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ID_HEADER, cMessageId ) )

  RETURN ( oStompFrame )
