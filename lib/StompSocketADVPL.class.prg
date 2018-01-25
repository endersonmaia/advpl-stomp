#ifndef __HARBOUR__
#include "stomp.ch"

CLASS TStompSocket

  METHOD new() CONSTRUCTOR
  METHOD connect( cHost, nPort )
  METHOD send( cStompFrame )
  METHOD receive()
  METHOD disconnect()
  METHOD isConnected()

HIDDEN:
  DATA hSocket
  DATA nStatus
  DATA oError
  DATA cBuffer
  DATA cReceivedData
  DATA cHost
  DATA nPort
  DATA lConnected

ENDCLASS

METHOD new() CLASS TStompSocket
  ::lConnected := .F.
  RETURN ( SELF )

METHOD connect( cHost, nPort ) CLASS TStompSocket

  ::hSocket := TSocketClient():new()
  ::nStatus := ::hSocket:connect( nPort , cHost, STOMP_SOCKET_CONNECTION_TIMEOUT )

  IF ::nStatus .AND. ::hSocket:isConnected()
    ::lConnected := .T.
  ENDIF

  RETURN ( NIL )

METHOD send( cStompFrame ) CLASS TStompSocket
  LOCAL nSocketSend, nSocketReceive

  nSocketSend := ::hSocket:send( cStompFrame )

  IF ( nSocketSend == Len( cStompFrame ) )

    #ifdef DEBUG
    ? ">>>>", CHR_CRLF
    ? ALLTRIM( cStompFrame) , CHR_CRLF
    ? "^^^^", CHR_CRLF
    #endif

    nSocketReceive := ::hSocket:receive( ::cReceivedData , STOMP_SOCKET_CONNECTION_TIMEOUT )

    IF ( ! nSocketReceive > 0 )
      ? "TSocketClient - Sem Resposta a requisicao", CHR_CRLF
      IF ( lGetError )
        ? ::hSocket:GetError(), CHR_CRLF
      EndIF
    EndIF
  ELSE
    IF ( lGetError )
      ? ::hSocket:GetError(), CHR_CRLF
    EndIF
    ? "TSocketClient - Problemas no Enviamos da Mensagem", CHR_CRLF
  ENDIF

  RETURN ( NIL )

METHOD receive() CLASS TStompSocket
  LOCAL cBuffer := SPACE( STOMP_SOCKET_BUFFER_SIZE )
  LOCAL nLen := 0

  ::cReceivedData := ""
  nLen := ::hSocket:receive( @cBuffer, STOMP_SOCKET_BUFFER_SIZE )
  IF( nLen >= 0 )
    ::cReceivedData := cBuffer
  ENDIF

  #ifdef DEBUG
  ? "<<<<" CHR_CRLF
  ? ALLTRIM( cBuffer ) , CHR_CRLF
  ? "^^^^", CHR_CRLF
  #endif

  RETURN ( nLen )

METHOD disconnect() CLASS TStompSocket

  ::hSocket:CloseConnection()
  ::hSocket := NIL
  ::lConnected := .F.

  RETURN ( NIL )

METHOD isConnected() CLASS TStompSocket
  RETURN ( ::hSocket:isConnected() .AND. ::lConnected )

#endif // #ifndef __HARBOUR__