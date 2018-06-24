#ifdef __HARBOUR__
#include "stomp.ch"

CLASS TStompSocket

  METHOD new() CONSTRUCTOR
  METHOD connect( cHost, nPort )
  METHOD send( cStompFrame )
  METHOD receive( @cReceivedData )
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

  IF EMPTY( ::hSocket := hb_socketOpen() )
    ::oError := ErrorNew( "ESocketOpen",,, ProcName(), "Socket create error " + hb_ntos( hb_socketGetError() ) )
  ELSE
    ::lConnected := .T.
  ENDIF

  IF !hb_socketConnect( ::hSocket, { HB_SOCKET_AF_INET, cHost, nPort } )
    ::oError := ErrorNew( "ESocketConnect",,, ProcName(), "Socket connect error " + hb_ntos( hb_socketGetError() ) )
  ELSE
    ::lConnected := .T.
  ENDIF

  RETURN( NIL )

METHOD send( cStompFrame ) CLASS TStompSocket

  hb_socketSend( ::hSocket, ALLTRIM( cStompFrame ) )

  #ifdef DEBUG
  ? ">>>>", CHR_CRLF
  ? cStompFrame, CHR_CRLF
  ? "^^^^", CHR_CRLF
  #endif

 RETURN ( NIL )

//TODO - handle errors
//TODO - handle reconnections
//TODO - handle responses from the server
METHOD receive( cReceivedData ) CLASS TStompSocket
  LOCAL cBuffer := Space( STOMP_SOCKET_BUFFER_SIZE )
  LOCAL nLen := 0

  ::cReceivedData := ""
  nLen := hb_socketRecv( ::hSocket, @cBuffer, STOMP_SOCKET_BUFFER_SIZE, 0 , 10000 )
  IF ( nLen > 0 )
    ::cReceivedData := ALLTRIM( cBuffer )
    cReceivedData := ::cReceivedData
  ENDIF

  #ifdef DEBUG
  ? "<<<<", CHR_CRLF
  ? cBuffer, CHR_CRLF
  ? "^^^^", CHR_CRLF
  #endif

  RETURN ( nLen )

METHOD disconnect() CLASS TStompSocket

  ::lConnected := .F.
  hb_socketShutdown( ::hSocket )
  hb_socketClose( ::hSocket )

  ::hSocket := nil

  RETURN ( NIL )

METHOD isConnected() CLASS TStompSocket
  RETURN ( ::lConnected )

#endif //__HARBOUR__