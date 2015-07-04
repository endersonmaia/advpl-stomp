#include "stomp.ch"

FUNCTION main()

  LOCAL oRunner := TTextRunner():New()
  LOCAL oSuite := TTestSuite():New()

  oSuite:AddTest( TTestStompFrame():new() )
  oSuite:AddTest( TTestStompFrameBuilder():new() )

  oRunner:Run( oSuite )

  RETURN ( nil )