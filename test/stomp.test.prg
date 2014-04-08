#include "stomp.ch"

#ifdef __HARBOUR__ 
PROCEDURE main()
#else
USER FUNCTION stomp_test
#endif

  oStomp := StompFrame():new()
  oStomp:setType('CONNECT')
  #ifdef __HARBOUR__
  ? oStomp:cType
  #else
  ALERT(oStomp:cType)
  #endif 

RETURN