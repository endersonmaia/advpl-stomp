#ifdef __HARBOUR__
  #include "hbclass.ch"
#else
  #include "totvs.ch"
#endif

#include "stomp.ch"

CLASS TStompFrameBuilder

METHOD connect()
METHOD formatHeader()

ENDCLASS

METHOD connect() CLASS TStompFrameBuilder

  local cConnect
  
//  cConnect := STOMP_CLI_CONNECT
//  cConnect += formatHeader("accept-version",::cAcceptVersions)
//  cCOnnect += formatHeader("host:",::cHost)

RETURN cConnect

METHOD formatHeader(cName, cValue) CLASS TStompFrameBuilder
  local cHeader
  
  cHeader := cName+':'+cValue+CHR_CRLF

RETURN cHeader