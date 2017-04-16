#include "stomp.ch"
#define DEBUG

CLASS TStompSocket

  DATA hSocket
  DATA nStatus
  DATA lConnected
  DATA oError
  DATA cBuffer
  DATA cReceivedData
  DATA cHost
  DATA nPort

  METHOD new() CONSTRUCTOR
  METHOD connect( cHost, nPort )
  METHOD send( cStompFrame )
  METHOD receive( cReceivedData )
  METHOD disconnect()
  METHOD isConnected()

ENDCLASS

METHOD new() CLASS TStompSocket
  ::lConnected := .F.
RETURN ( SELF )

METHOD connect( cHost, nPort ) CLASS TStompSocket

  ::hSocket := tSocketClient():new()
  ::nStatus := ::hSocket:connect( nPort , cHost, STOMP_SOCKET_CONNECTION_TIMEOUT )

  IF ::hSocket:isConnected()
    ::lConnected := .T.
  ENDIF

  RETURN ( nil )

METHOD send( cStompFrame ) CLASS TStompSocket
  LOCAL nSocketSend
  LOCAL nSocketReceive

  nSocketSend := ::hSocket:send( cStompFrame )

  IF ( nSocketSend == Len( cStompFrame ) )

    #ifdef DEBUG
    Conout( ">>>" + CRLF )
    Conout( ALLTRIM( cStompFrame ) + CRLF )
    #endif

    nSocketReceive := ::hSocket:receive( ::cReceivedData , STOMP_SOCKET_CONNECTION_TIMEOUT )

    IF ( ! nSocketReceive > 0 )
      ConOut( "" , "tSocketClient" , "" , "Sem Resposta a requisicao" , "" )
      IF ( lGetError )
        ConOut( ::hSocket:GetError() )
      EndIF
    EndIF
  ELSE
    IF ( lGetError )
      ConOut( ::hSocket:GetError() )
    EndIF
    ConOut( "" , "tSocketClient" , "" , "Problemas no Enviamos da Mensagem" , "" )
  ENDIF

  RETURN ( nil )

METHOD receive() CLASS TStompSocket
  LOCAL cBuffer := SPACE( STOMP_SOCKET_BUFFER_SIZE )
  LOCAL nLen := 0

  ::cReceivedData := ""
  nLen := ::hSocket:receive( @cBuffer, 10000 )
  IF( nResp >= 0 )
    ::cReceivedData := cBuffer
  ENDIF

  #ifdef DEBUG
  Conout( "<<<" + CRLF )
  Conout( ALLTRIM( cBuffer ) + CRLF )
  #endif

  RETURN ( nLen )

METHOD disconnect() CLASS TStompSocket

  ::hSocket:CloseConnection()
	::hSocket	:= NIL

  RETURN ( nil )

METHOD isConnected() CLASS TStompSocket
RETURN ( ::lConnected )