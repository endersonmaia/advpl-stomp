#include "stomp.ch"

PROCEDURE main()

  oStomp := StompMessage:new('localhost')
  #ifdef __HARBOUR__
  ? oStomp:connect()
  #else
  ALERT(oStomp:connect())
  #endif 

RETURN