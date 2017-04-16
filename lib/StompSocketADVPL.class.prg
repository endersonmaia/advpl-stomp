#ifdef TOTVS
#include "stomp.ch"

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
RETURN ( SELF )

METHOD connect( cHost, nPort ) CLASS TStompSocket

  ::hSocket    := tSocketClient():new()
  ::hSocket:Connect( nPort, cHost, 10 )

  IF (::hSocket:isConnected()
  	::lConnected := .T.
  	::nStatus := STOMP_SOCKET_STATUS_CONNECTED
  ELSE
  	::lConnected := .F.
  	::nStatus := STOMP_SOCKET_STATUS_CONNECTION_FAILED)
  END

  RETURN ( nil )

METHOD send( cStompFrame ) CLASS TStompSocket

  ::cReceivedData := ::hSocket:send( ALLTRIM( cStompFrame ) )

  IF ( ::cReceivedData == Len(cStompFrame) )
    ::nStatus := STOMP_SOCKET_STATUS_DATA_SENT
  ELSE
    ::nStatus := STOMP_SOCKET_STATUS_SEND_FAILED
  ENDIF

  #ifdef DEBUG
  Conout( ">>>" + CRLF )
  Conout( ALLTRIM( cStompFrame ) + CRLF )
  #endif

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

  RETURN ( nil )

METHOD isConnected() CLASS TStomSocket
RETURN ( ::lConnected )

#endif // TOTVS