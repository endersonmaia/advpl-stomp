#include 'totvs.ch'
#include 'stomp.ch'

//TODO - handle Stomp Server ERROR frames
//TODO - handle TStompSocket errors
//TODO - return exceptions to users of TStompClient
//TODO - handle receipts
//TODO - handle ack, nack
//TODO - handle transactions
//TODO - handle many subscriptions on a single connection

CLASS TStompClient

  METHOD new( cHost, nPort, cLogin, cPassword, cDestination, lSendReceipt ) CONSTRUCTOR
  METHOD connect()
  METHOD disconnect()
  METHOD publish( cDestination, cMessage )
  METHOD isConnected()
  METHOD getErrorMessage()
  METHOD subscribe( cDestination, cAckMode, nTimeOut, bProc )
  METHOD ack( cMessageId )
  METHOD nack( cMessageId )

  DATA lRequireReceipt INIT .F.

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
  DATA lSendReceipt
  DATA cLastReceipt
  DATA cLastMessage
  DATA oStompFrameBuilder
  DATA aSubscriptions
  DATA lGracefullyDisconnected INIT .F.
  DATA oLogger

  METHOD _registerSubscription( cSubscriptionId )

ENDCLASS

METHOD new( cHost, nPort, cLogin, cPassword , cDestination, lSendReceipt ) CLASS TStompClient

  ::oStompFrameBuilder := TStompFrameBuilder():new()
  ::oLogger := Logger():New( 'stomp_client' )
  ::cHost := cHost
  ::nPort := nPort
  ::cDestination := cDestination
  ::aSubscriptions := {}
  ::lSendReceipt := .F.

  IIF( ValType(lSendReceipt) != 'U', ::lSendReceipt := .T., )

  IF ( ValType(cLogin) == 'C' .AND. ValType(cPassword) == 'C')
    ::cLogin := cLogin
    ::cPassword := cPassword
    ::lHasLoginData := .T.
  ENDIF

  ::lConnected := .F.

  RETURN ( self )

METHOD connect() CLASS TStompClient
  LOCAL oStompFrame, cFrameBuffer, i, nStatus

  ::oSocket := TSocketClient():new()
  nStatus := ::oSocket:connect( ::nPort, ::cHost, STOMP_SOCKET_CONNECTION_TIMEOUT )

  IF ( nStatus == 0 .AND. ::oSocket:isConnected() )

    IF ( ::lHasLoginData == .T. )
      oStompFrame := ::oStompFrameBuilder:buildConnectFrame( ::cDestination, ::cLogin, ::cPassword )
    ELSE
      oStompFrame := ::oStompFrameBuilder:buildConnectFrame( ::cDestination )
    ENDIF

    ::oSocket:send( oStompFrame:build() )

    IF ( ::oSocket:receive( @cFrameBuffer, STOMP_SOCKET_BUFFER_SIZE ) > 0 )
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
  ELSE
  //TODO : implement socket connection error handling
  ENDIF

  RETURN ( NIL )

METHOD getErrorMessage() CLASS TStompClient
  RETURN ( ::cErrorMessage )

//TODO - implementar envio de headers
METHOD publish( cDestination, cMessage ) CLASS TStompClient
  LOCAL oStompFrame, cFrameBuffer := "", cReceiptID := ""

  oStompFrame := ::oStompFrameBuilder:buildSendFrame( cDestination, cMessage )

  IF ( ::lSendReceipt == .T. )
    cReceiptID := TSTOMP_IDS_PREFIX + _randomAlphabet( TSTOMP_IDS_LENGHT )
    oStompFrame:addHeader( STOMP_RECEIPT_HEADER,  cReceiptID )
  ENDIF

  ::oSocket:send( oStompFrame:build(.F.) )

  //TODO - implementar tratamento do retorno, caso exista mensagem reply-to
  IF ( ::oSocket:receive( @cFrameBuffer, STOMP_SOCKET_BUFFER_SIZE ) > 0 )
    oStompFrame := oStompFrame:parse( cFrameBuffer )

    DO CASE
    CASE  oStompFrame:cCommand == STOMP_SERVER_COMMAND_MESSAGE
      ::cLastMessage := oStompFrame:cBody
    CASE  oStompFrame:cCommand == STOMP_SERVER_COMMAND_RECEIPT
      ::cLastReceipt := oStompFrame:getHeaderValue( STOMP_RECEIPT_ID_HEADER )
    CASE  oStompFrame:cCommand == STOMP_SERVER_COMMAND_ERROR
      ::cErrorMessage := oStompFrame:getHeaderValue( STOMP_MESSAGE_HEADER )
    ENDCASE

  ENDIF

  RETURN ( nil )

METHOD disconnect() CLASS TStompClient
  LOCAL oStompFrame, cFrameBuffer := "", cReceiptID := "", cDisconnectReceiptID := ""

  IF ( ::oSocket:isConnected() )

    IF ( ::lConnected == .T. )
      oStompFrame := ::oStompFrameBuilder:buildDisconnectFrame()

      IF ( ::lSendReceipt == .T. )
        cReceiptID := TSTOMP_IDS_PREFIX + _randomAlphabet( TSTOMP_IDS_LENGHT )
        oStompFrame:addHeader( STOMP_RECEIPT_HEADER,  cReceiptID )
      ENDIF

      ::oSocket:send( oStompFrame:build() )

      IF ( ::oSocket:receive( @cFrameBuffer, STOMP_SOCKET_BUFFER_SIZE ) > 0 )
        oStompFrame := oStompFrame:parse( cFrameBuffer )

        DO CASE
        CASE  oStompFrame:cCommand == STOMP_SERVER_COMMAND_MESSAGE
          ::cLastMessage := oStompFrame:cBody
          ::lConnected := .F.
        CASE  oStompFrame:cCommand == STOMP_SERVER_COMMAND_RECEIPT
          ::lConnected := .F.
          ::cLastReceipt := oStompFrame:getHeaderValue( STOMP_RECEIPT_ID_HEADER )
          cDisconnectReceiptID := oStompFrame:getHeaderValue( STOMP_RECEIPT_ID_HEADER )
        CASE  oStompFrame:cCommand == STOMP_SERVER_COMMAND_ERROR
          ::cErrorMessage := oStompFrame:getHeaderValue( STOMP_MESSAGE_HEADER )
        ENDCASE

      ENDIF

    ENDIF

    IF ( cReceiptID == cDisconnectReceiptID )
      ::lGracefullyDisconnected := .T.
      ::oSocket:closeConnection()
    ELSE
      ::lGracefullyDisconnected := .F.
      ::oSocket:closeConnection()
    ENDIF
  ENDIF

  ::oSocket:closeConnection()

  RETURN ( nil )

METHOD isConnected() CLASS TStompClient
  RETURN ( ::oSocket:isConnected() .AND. (::lConnected == .T. ) )

METHOD subscribe( cDestination, cAckMode ) CLASS TStompClient
  LOCAL oStompFrame, i := 0, cFrameBuffer := ""

  oStompFrame := ::oStompFrameBuilder:buildSubscribeFrame( cDestination )
  IIF( ValType( cAckMode ) == 'C', oStompFrame:addHeader( STOMP_ACK_HEADER, cAckMode ), )

  ::_registerSubscription( oStompFrame:getHeaderValue ( STOMP_ID_HEADER ) )

  ::oSocket:send( oStompFrame:build(.F.) )

  IF( ::oSocket:send( oStompFrame:build(.F.) ) == oStompFrame:getSize( ) )

    DO WHILE ( ::oSocket:receive( @cFrameBuffer, STOMP_SOCKET_BUFFER_SIZE ) > 0 )

      DO WHILE ( Len( cFrameBuffer ) > 0 )
        oStompFrame := oStompFrame:parse( @cFrameBuffer )

        IF ( !oStompFrame:isValid() )
          ::oLogger:Error( "FRAME INVALIDO : {1}", { oStompFrame:build(.F.) } ) 
          FOR i := 1 TO oStompFrame:countErrors()
            ::oLogger:Error( '{1}', { oStompFrame:aErrors[i] } )
          NEXT
          BREAK
        ENDIF

        IF ( oStompFrame:cCommand == STOMP_SERVER_COMMAND_MESSAGE )
          CONOUT( "Mensagem recebida no subscribe" + CHR_CRLF )
          CONOUT( oStompFrame:cBody + CHR_CRLF ) 
        ELSE
          IF ( oStompFrame:cCommand == STOMP_SERVER_COMMAND_ERROR )
            ::cErrorMessage := oStompFrame:getHeaderValue( STOMP_MESSAGE_HEADER ) + CHR_CRLF + oStompFrame:cBody
            ::oLogger:Error( '{1}', { ::cErrorMessage } )
          ENDIF
        ENDIF

      ENDDO

    ENDDO
  ELSE
    ::oLogger:Error("Failed to subscribe")
  ENDIF
  RETURN ( nil )

METHOD ack( cMessageId ) CLASS TStompClient
  LOCAL oStompFrame

  oStompFrame := ::oStompFrameBuilder:buildAckFrame( cMessageId )

  ::oSocket:send( oStompFrame:build(.F.) )

  RETURN ( nil )

METHOD nack( cMessageId ) CLASS TStompClient
  LOCAL oStompFrame

  oStompFrame := ::oStompFrameBuilder:buildNackFrame( cMessageId )

  ::oSocket:send( oStompFrame:build(.F.) )

  RETURN ( NIL )

METHOD _registerSubscription( cSubscriptionId ) CLASS TStompClient
  AADD( ::aSubscriptions, cSubscriptionId )
  RETURN ( NIL )
