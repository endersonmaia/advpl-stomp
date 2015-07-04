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
  OutStd( "<<<", hb_EOL() )
  OutStd( ALLTRIM( cBuffer ), hb_EOL() )
  #endif

  RETURN ( nLen )

METHOD send( cStompFrame ) CLASS TStompSocketHarbour

  hb_socketSend( ::hSocket, ALLTRIM( cStompFrame ) )

  #ifdef DEBUG
  OutStd( ">>>", hb_EOL() )
  OutStd( ALLTRIM( cStompFrame ), hb_EOL() )
  #endif

 RETURN ( NIL )

METHOD disconnect() CLASS TStompSocketHarbour

  hb_socketShutdown( ::hSocket )
  hb_socketClose( ::hSocket )

  ::hSocket := nil

  RETURN ( NIL )

#endif