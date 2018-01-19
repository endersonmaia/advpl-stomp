#include "stomp.ch"

//TODO - handle Stomp Server ERROR frames
//TODO - handle TStompSocke exceptions
//TODO - return exceptions to users of TStompClient
//TODO - handle receipts
//TODO - handle transactions

CLASS TStompClient

  METHOD new( cHost, nPort, cLogin, cPassword ) CONSTRUCTOR
  METHOD connect()
  METHOD disconnect()
  METHOD publish( cDestination, cMessage )
  METHOD isConnected()
  METHOD getErrorMessage()
  METHOD subscribeTo( cDestination )
  METHOD readFrame()
  METHOD countFramesToRead()
  METHOD addFrame()

  DATA lRequireReceipt INIT .F.

  HIDDEN:
  DATA oSocket
  DATA cHost
  DATA nPort
  DATA cLogin
  DATA cPassword
  DATA cDestination
  DATA lConnected
  DATA cErrorMessage
  DATA aFrames
  DATA lHasLoginData INIT .F.
  DATA cSessionID

ENDCLASS

METHOD new( cHost, nPort, cLogin, cPassword , cDestination ) CLASS TStompClient

  ::cHost := cHost
  ::nPort := nPort
  ::cDestination := cDestination

  IF ( ValType(cLogin) == 'C' .AND. ValType(cPassword) == 'C')
    ::cLogin := cLogin
    ::cPassword := cPassword
    ::lHasLoginData := .T.
  ENDIF

  ::lConnected := .F.

  RETURN ( self )

METHOD connect() CLASS TStompClient
  LOCAL oStompFrame, cFrameBuffer

  //TODO - handle socket errors
  ::oSocket := TStompSocket():new()
  ::oSocket:connect( ::cHost, ::nPort )

  IF ::lHasLoginData
    oStompFrame := TStompFrameBuilder():buildConnectFrame( ::cDestination, ::cLogin, ::cPassword )
  ELSE
    oStompFrame := TStompFrameBuilder():buildConnectFrame( ::cDestination )
  ENDIF

  ::oSocket:send( oStompFrame:build() )

  IF ( ( ::oSocket:receive() > 0 ) )
    cFrameBuffer := ::oSocket:cReceivedData
    oStompFrame := oStompFrame:parse( cFrameBuffer )

    IF ( oStompFrame:cCommand == STOMP_SERVER_COMMAND_CONNECTED )
      ::lConnected := .T.
      ::cSessionID := oStompFrame:getHeaderValue( STOMP_SESSION_HEADER )
    ELSE
      IF ( oStompFrame:cCommand == STOMP_SERVER_COMMAND_ERROR )
        ::cErrorMessage := oStompFrame:getHeaderValue( STOMP_MESSAGE_HEADER )
      ENDIF
    ENDIF

  ENDIF

  RETURN ( nil )

METHOD getErrorMessage() CLASS TStompClient
  RETURN ( ::cErrorMessage )

METHOD publish( cDestination, cMessage ) CLASS TStompClient
  LOCAL oStompFrame

  oStompFrame := TStompFrameBuilder():buildSendFrame( cDestination, cMessage )
  ::oSocket:send( oStompFrame:build() )

  //TODO - implementar tratamento do retorno, caso exista mensagem reply-to

  RETURN ( nil )

METHOD disconnect() CLASS TStompClient
  LOCAL oStompFrame

  oStompFrame := TStompFrameBuilder():buildDisconnectFrame()
  ::oSocket:send( oStompFrame:build() )

  ::oSocket:disconnect()

  ::lConnected := .F.

  RETURN ( nil )

METHOD isConnected() CLASS TStompClient
  RETURN ( ::lConnected )

METHOD subscribeTo( cDestination ) CLASS TStompClient
  LOCAL oStompFrame, i := 0, cFrameBuffer

  oStompFrame := TStompFrameBuilder():buildSubscribeFrame( cDestination, "1" )
  ::oSocket:send( oStompFrame:build() )

  //FIXME : split received data in individual StompFrames
  IF ( ( nLen := ::oSocket:receive() ) > 0 )
    cFrameBuffer := ::oSocket:cReceivedData

    DO WHILE ( Len( cFrameBuffer ) > 0 )
      OutStd( "Frame N: ", STR( ++i ),  hb_EOL() )

      oStompFrame := oStompFrame:parse( @cFrameBuffer )

      IF ( !oStompFrame:isValid() )
        FOR i := 1 TO oStompFrame:countErrors()
          OutStd( "ERRO: ", oStompFrame:aErrors[i] )
        NEXT
      ENDIF

      IF ( oStompFrame:cCommand == STOMP_SERVER_COMMAND_MESSAGE )
        OutStd( "Frame Dump", hb_EOL(), oStompFrame:build() , hb_EOL() )
      ELSE
        IF ( oStompFrame:cCommand == STOMP_SERVER_COMMAND_ERROR )
          ::cErrorMessage := oStompFrame:cMessage
        ENDIF
      ENDIF
    ENDDO

  ENDIF
  RETURN ( nil )

METHOD countFramesToRead() CLASS TStompClient
  RETURN ( LEN( ::aFrames ) )

METHOD addFrame( oStompFrame ) CLASS TStompClient
  AADD( ::aFrames, oStompFrame )
  RETURN ( NIL )

METHOD readFrame() CLASS TStompClient
  LOCAL oStompFrame

  RETURN ( oStompFrame )