#include "hbclass.ch"

CLASS TTestStompFrame INHERIT TTestCase

  METHOD testSetBody()
  METHOD testSetCommand()
  METHOD testAddHeader()
  METHOD testCountHeaders()
  METHOD testValidateCommand()

  METHOD Setup()
  METHOD Teardown()

  DATA oStompFrame

ENDCLASS

METHOD Setup() CLASS TTestStompFrame
	::oStompFrame := TStompFrame():new()
  RETURN ( NIL )

METHOD Teardown() CLASS TTestStompFrame
  ::oStompFrame := NIL
  RETURN ( NIL )

METHOD testSetBody() CLASS TTestStompFrame

  ::oStompFrame:setBody('corpo')

  ::assertEquals('corpo', ::oStompFrame:cBody, 'cBody should be corpo')
  
  RETURN ( NIL )

METHOD testSetCommand() CLASS TTestStompFrame

  ::oStompFrame:setCommand('CONNECT')

  ::assertEquals('CONNECT', ::oStompFrame:cCommand,  'cCommand should be CONNECT.')

  RETURN ( NIL )

METHOD testAddHeader() CLASS TTestStompFrame
  LOCAL oHeader

  oHeader := TStompFrameHeader():new( 'name', 'value' )
  ::oStompFrame:addHeader( oHeader )

  ::assertEquals('name', ::oStompFrame:aHeaders[1]:cName, 'oHeader:cName should be name')
  ::assertEquals('value', ::oStompFrame:aHeaders[1]:cValue, 'oHeader:cValue should be value')

  RETURN ( NIL )


METHOD testCountHeaders() CLASS TTestStompFrame
  LOCAL oHeader

  ::assertEquals(0, ::oStompFrame:countHeaders(), 'StompFrame:countHeaders() should return 0 (zero) when no headers is addes to StompFrame')

  oHeader := TStompFrameHeader():new( 'name', 'value' )
  ::oStompFrame:addHeader( oHeader )
  ::assertEquals(1, ::oStompFrame:countHeaders(), 'StompFrame:countHeaders() should return 1 (one)')

  oHeader := TStompFrameHeader():new( 'other', 'value' )
  ::oStompFrame:addHeader(oHeader)
  ::assertEquals(2, ::oStompFrame:countHeaders(), 'StompFrame:countHeaders() should return 2 (two)')

  RETURN ( NIL )

METHOD testValidateCommand() CLASS TTestStompFrame
  
  ::assertFalse(::oStompFrame:validateCommand(), 'should be false when stompframe has no command')

  RETURN ( NIL )