#ifndef __HARBOUR__
#include "stomp.ch"

CLASS TStompSocket

  METHOD new() CONSTRUCTOR
  METHOD connect( cHost, nPort )
  METHOD send( cStompFrame )
  METHOD receive( cReceivedData )
  METHOD disconnect()
  METHOD isConnected()

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

  BEGIN SEQUENCE

  ::hSocket := TSocketClient():new()
  ::nStatus := ::hSocket:connect( nPort , cHost, STOMP_SOCKET_CONNECTION_TIMEOUT )

  IF (::nStatus == 0) .AND. ::hSocket:isConnected()
    ::lConnected := .T.
  ELSE
    ::disconnect()
    BREAK
  ENDIF

  END SEQUENCE

  RETURN ( NIL )

METHOD send( cStompFrame ) CLASS TStompSocket
  LOCAL nSocketSend

  nSocketSend := ::hSocket:send( ALLTRIM ( cStompFrame ) )

  #ifdef DEBUG
  ? ">>>>", CHR_CRLF
  ? ALLTRIM( cStompFrame) , CHR_CRLF
  ? "^^^^", CHR_CRLF
  #endif

  RETURN ( nSocketSend )

METHOD receive( cReceivedData ) CLASS TStompSocket
  LOCAL cBuffer := SPACE( STOMP_SOCKET_BUFFER_SIZE )
  LOCAL nLen := 0

  ::cReceivedData := ""
  nLen := ::hSocket:receive( @cBuffer, STOMP_SOCKET_BUFFER_SIZE )
  IF( nLen >= 0 )
    ::cReceivedData := ALLTRIM( cBuffer )
    cReceivedData := ::cReceivedData
  ENDIF

  #ifdef DEBUG
  ? "<<<<", CHR_CRLF
  ? ALLTRIM( cBuffer ) , CHR_CRLF
  ? "^^^^", CHR_CRLF
  #endif

  RETURN ( nLen )

METHOD disconnect() CLASS TStompSocket

  ::hSocket:closeConnection()
  ::hSocket := NIL
  ::lConnected := .F.

  RETURN ( NIL )

METHOD isConnected() CLASS TStompSocket
  RETURN ( ::hSocket:isConnected() .AND. ::lConnected )

#endif // #ifndef __HARBOUR__