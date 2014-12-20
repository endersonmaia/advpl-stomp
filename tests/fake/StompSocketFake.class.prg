#include "stomp.ch"

CLASS TStompSocketFake FROM TStompSocket

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

ENDCLASS

METHOD new()
	RETURN ( self )