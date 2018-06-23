#include "stomp.ch"

#ifdef __PROTHEUS__
// See : http://tdn.totvs.com/display/tec/TSocketClient

CLASS TStompSocketADVPL FROM TStompSocket

  METHOD connect( cHost, nPort )
  METHOD send( cStompFrame )
  METHOD receive( cReceivedData )
  METHOD disconnect()

ENDCLASS

METHOD connect( cHost, nPort ) CLASS TStompSocketADVPL

  ::hSocket    := tSocketClient():new()
  ::hSocket:Connect( nPort, cHost, 10 )

  IIF (::hSocket:IsConnected(), ::nStatus := STOMP_SOCKET_STATUS_CONNECTED, ::nStatus := STOMP_SOCKET_STATUS_CONNECTION_FAILED)

  RETURN ( nil )


METHOD send( cStompFrame ) CLASS TStompSocketADVPL
  
  ::cReceivedData := ::hSocket:send( cStompFrame )

  IF ( ::cReceivedData == Len(cStompFrame) )
    ::nStatus := STOMP_SOCKET_STATUS_DATA_SENT
  ELSE
    ::nStatus := STOMP_SOCKET_STATUS_SEND_FAILED
  ENDIF

  RETURN ( nil )

METHOD receive() CLASS TStompSocketADVPL

  cBuffer := ""
  nResp := oObj:Receive( @cBuffer, 10000 ) 
  if( nResp >= 0 )
      conout( "--> Dados Recebidos " + StrZero(nResp,5) )
      conout( "--> ["+cBuffer+"]" )
  else
      conout( "--> Não recebi dados" )
  endif

  RETURN ( nil )

METHOD disconnect() CLASS TStompSocketADVPL

  oObj:CloseConnection()

  RETURN ( nil )

#endif