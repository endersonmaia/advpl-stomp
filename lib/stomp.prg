#ifdef __HARBOUR__
  #include "hbclass.ch"
#else
  #include "totvs.ch"
#endif

#include "stomp.ch"

CLASS StompMessage

  DATA cHost 
  DATA cAcceptVersions
  DATA cLogin
  DATA cPassword

  METHOD new(cHost) CONSTRUCTOR
  METHOD connect()

ENDCLASS

METHOD new(cHost) CLASS StompMessage

  ::cHost := cHost
  ::cAcceptVersions := ACCEPTED_VERSIONS

RETURN SELF

METHOD connect() CLASS StompMessage

  local cConnect
  
  cConnect := STOMP_CLI_CONNECT
  cConnect += "accept-version:"+::cAcceptVersion+CHR_CRLF
  cCOnnect += "host:"+::cHost+CHR_CRLF

RETURN cConnect