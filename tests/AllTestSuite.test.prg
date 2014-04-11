FUNCTION main()
  LOCAL oRunner := TTextRunner():New()
  LOCAL oSuite := TTestSuite():New()

  oSuite:AddTest( TTestStompFrame():New() )
  
  oRunner:Run( oSuite )

  inkey( 5 )

  RETURN ( nil )