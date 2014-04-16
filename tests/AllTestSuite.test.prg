FUNCTION main()

  LOCAL oRunner := TTextRunner():New()
  LOCAL oSuite := TTestSuite():New()

  oSuite:AddTest( TTestStompFrame():new() )
  oSuite:AddTest( TTestStompFrameBuilder():new() )

  oRunner:Run( oSuite )

  inkey( 5 )

  RETURN ( nil )