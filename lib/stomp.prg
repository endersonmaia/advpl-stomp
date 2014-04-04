#include "stomp.ch"

FUNCTION stomp_connect(cAcceptVersion, cHost)

  local cConnect
  
  cConnect := STOMP_CLI_CONNECT
  cConnect += "accept-version:"+cAcceptVersion+CHR_CRLF
  cCOnnect += "host:"+cHost+CHR_CRLF

RETURN cConnect