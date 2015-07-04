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
  
  DO CASE
  CASE ( ValType( cName ) == "C" )
  CASE ( ValType( cName ) == "M" )
    BREAK
  OTHERWISE
    //Throw( ErrorNew( "EStompHeaderInvalidType",,, ProcName(), "Invalid type for StompHeader:Name." ) )
  END CASE

  DO CASE
  CASE ( ValType( cValue ) == "C" )
  CASE ( ValType( cValue ) == "M" )
    BREAK
  OTHERWISE
    //Throw( ErrorNew( "EStompHeaderInvalidType",,, ProcName(), "Invalid type for StompHeader:Value." ) )
  END CASE

  ::cName  := cName
  ::cValue := cValue
RETURN ( self )

METHOD getName() CLASS TStompFrameHeader
  RETURN ( ::cName )

METHOD getValue() CLASS TStompFrameHeader
  RETURN ( ::cValue )

METHOD toString() CLASS TStompFrameHeader
  RETURN ( ::cName + ":" + ::cValue )