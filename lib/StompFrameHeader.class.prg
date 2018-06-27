#include "stomp.ch"

CLASS TStompFrameHeader

  METHOD new( cName, cValue ) CONSTRUCTOR
  METHOD toString()
  METHOD getName()
  METHOD getValue()

  DATA cName
  DATA cValue

ENDCLASS

METHOD new( cName, cValue ) CLASS TStompFrameHeader
  ::cName  := cName
  ::cValue := cValue
RETURN ( self )

METHOD getName() CLASS TStompFrameHeader
  RETURN ( ::cName )

METHOD getValue() CLASS TStompFrameHeader
  RETURN ( ::cValue )

METHOD toString() CLASS TStompFrameHeader
  RETURN ( ::cName + ":" + ::cValue )