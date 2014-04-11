#include "hbclass.ch"

CLASS TTestStompFrame INHERIT TTestCase

  METHOD testSetBody()
  METHOD testSetCommand()

  METHOD Setup()
  METHOD Teardown()

  DATA oStompFrame

ENDCLASS

METHOD Setup() CLASS TTestStompFrame
	::oStompFrame := StompFrame():new()
  RETURN ( NIL )

METHOD Teardown() CLASS TTestStompFrame
  ::oStompFrame := NIL
  RETURN ( NIL )

METHOD testSetBody() CLASS TTestStompFrame

  ::oStompFrame:setBody('corpo')
  AssertEquals('corpo', ::oStompFrame:cBody, 'Body deve ser corpo')
  
  RETURN ( NIL )

METHOD testSetCommand() CLASS TTestStompFrame

  ::oStompFrame:setCommand('CONNECT')

  AssertEquals('CONNECT', ::oStompFrame:cCommand,  'Command deve ser CONNECT.')

  RETURN ( NIL )