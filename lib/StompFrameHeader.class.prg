#ifdef __HARBOUR__
  #include "hbclass.ch"
#else
  #include "totvs.ch"
#endif

#include "stomp_frame_header.ch"

CLASS TStompFrameHeader

  DATA cName
  DATA cValue

  METHOD new( cName, cValue ) CONSTRUCTOR

ENDCLASS

METHOD new( cName, cValue ) CLASS TStompFrameHeader
  ::cName := cName
  ::cValue := cValue
RETURN SELF