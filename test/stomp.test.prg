#include "stomp.ch"

PROCEDURE MAIN()

  oStomp = StompMessage:new()
?  oStomp:connect("localhost")

RETURN