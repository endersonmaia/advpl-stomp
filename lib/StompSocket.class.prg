#include "stomp.ch"

CLASS TStompSocket

  DATA hSocket
  DATA nStatus
  DATA oError
  DATA cBuffer
  DATA cReceivedData
  DATA cHost
  DATA nPort

  METHOD new() CONSTRUCTOR

  METHOD connect( cHost, nPort )  VIRTUAL
  METHOD send( cStompFrame )      VIRTUAL
  METHOD receive()                VIRTUAL
  METHOD disconnect()             VIRTUAL
  METHOD isConnected()

ENDCLASS

METHOD new() CLASS TStompSocket
  LOCAL oReturn
  #ifdef __HARBOUR__
  oReturn := TStompSocketHarbour():new()
  #else
  #ifdef __TOTVS__
  oReturn := TStompSocketADVPL():new()
  #endif
  #endif
  RETURN ( oReturn )

 METHOD isConnected() CLASS TStompSocket
   RETURN( ::nStatus )