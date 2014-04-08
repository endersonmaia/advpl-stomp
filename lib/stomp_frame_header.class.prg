#ifdef __HARBOUR__
  #include "hbclass.ch"
#else
  #include "totvs.ch"
#endif

#include "stomp_frame_header.ch"

CLASS StompFrameHeader

  DATA cHeaderName
  DATA cHeaderValue

  METHOD new() CONSTRUCTOR

ENDCLASS

METHOD new(cHeaderName,cHeaderValue) CLASS StompFrameHeader
  ::cHeaderName := cHeaderName
  ::cHeaderValue := cHeaderValue
RETURN SELF