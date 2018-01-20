#include "stomp.ch"
#include "hbsocket.ch"

#ifdef __HARBOUR__

CLASS TStompSocketHarbour FROM TStompSocket

  METHOD new() CONSTRUCTOR
  METHOD connect( cHost, nPort )
  METHOD send( cStompFrame )
  METHOD receive()
  METHOD disconnect()

ENDCLASS

METHOD new()
  RETURN ( self )

METHOD connect( cHost, nPort ) CLASS TStompSocketHarbour

  IF EMPTY( ::hSocket := hb_socketOpen() )
    ::oError := ErrorNew( "ESocketOpen",,, ProcName(), "Socket create error " + hb_ntos( hb_socketGetError() ) )
    //Throw( ::oError )
  ENDIF

  IF !hb_socketConnect( ::hSocket, { HB_SOCKET_AF_INET, cHost, nPort } )
    ::oError := ErrorNew( "ESocketConnect",,, ProcName(), "Socket connect error " + hb_ntos( hb_socketGetError() ) )
    //Throw( ::oError )
  ENDIF

  RETURN( NIL )

METHOD receive() CLASS TStompSocketHarbour
  LOCAL cBuffer, nLen

  ::cReceivedData := ""
  cBuffer = Space( STOMP_SOCKET_BUFFER_SIZE )
  IF ( nLen := hb_socketRecv( ::hSocket, @cBuffer, STOMP_SOCKET_BUFFER_SIZE, 0 , 1000 ) ) > 0
    ::cReceivedData := ALLTRIM( cBuffer )
  ENDIF

  #ifdef DEBUG
  ? "<<<<", CHR_CRLF
  ? cBuffer, CHR_CRLF
  ? "^^^^", CHR_CRLF
  #endif

  RETURN ( nLen )

//TODO - handle errors
//TODO - handle reconnections
//TODO - handle responses from the server
METHOD send( cStompFrame ) CLASS TStompSocketHarbour

  hb_socketSend( ::hSocket, cStompFrame )

  #ifdef DEBUG
  ? ">>>>", CHR_CRLF
  ? cStompFrame, CHR_CRLF
  ? "^^^^", CHR_CRLF
  #endif

 RETURN ( NIL )

METHOD disconnect() CLASS TStompSocketHarbour

  hb_socketShutdown( ::hSocket )
  hb_socketClose( ::hSocket )

  ::hSocket := nil

  RETURN ( NIL )

#endif