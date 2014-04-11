#ifdef __HARBOUR__
  #include "hbclass.ch"
#else
  #include "totvs.ch"
#endif

#include "stomp_frame_header.ch"

CLASS StompFrameHeader

  DATA cName READONLY
  DATA cValue READONLY

  METHOD new( cName, cValue ) CONSTRUCTOR

ENDCLASS

METHOD new( cName, cValue ) CLASS StompFrameHeader
  ::cName := cName
  ::cValue := cValue
RETURN SELF