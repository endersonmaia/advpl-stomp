#include "stomp.ch"

CLASS TStompFrameHeader

  METHOD new( cName, cValue ) CONSTRUCTOR
  METHOD toString()
  METHOD getName()
  METHOD getValue()

  HIDDEN:
    DATA cName
    DATA cValue

ENDCLASS

METHOD new( cName, cValue ) CLASS TStompFrameHeader
  
  SWITCH ValType( cName )
    CASE "C"; CASE "M"; exit
    default; Throw( xhb_errorNew( "EStompHeaderInvalidType",,, ProcName(), "Invalid type for StompHeader:Name." ) )
  END

  SWITCH ValType( cValue )
    CASE "C"; CASE "M"; exit
    default; Throw( xhb_errorNew( "EStompHeaderInvalidType",,, ProcName(), "Invalid type for StompHeader:Value." ) )
  END  

  ::cName  := cName
  ::cValue := cValue
RETURN ( self )

METHOD getName() CLASS TStompFrameHeader
  RETURN ( ::cName )

METHOD getValue() CLASS TStompFrameHeader
  RETURN ( ::cValue )

METHOD toString() CLASS TStompFrameHeader
  RETURN ( ::cName + ":" + ::cValue )