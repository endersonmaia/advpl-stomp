#include "stomp.ch"

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
  DATA lSendReceipt
  DATA cLastReceipt
  DATA cLastMessage
  DATA oStompFrameBuilder

ENDCLASS

METHOD new( cHost, nPort, cLogin, cPassword , cDestination, lSendReceipt ) CLASS TStompClient

  ::oStompFrameBuilder := TStompFrameBuilder():new()
  ::cHost := cHost
  ::nPort := nPort
  ::cDestination := cDestination

  IIF( ValType(lSendReceipt) != 'U', ::lSendReceipt := lSendReceipt, ::lSendReceipt := .F. )

  IF ( ValType(cLogin) == 'C' .AND. ValType(cPassword) == 'C')
    ::cLogin := cLogin
    ::cPassword := cPassword
    ::lHasLoginData := .T.
  ENDIF

  ::lConnected := .F.

  RETURN ( self )

METHOD connect() CLASS TStompClient
  LOCAL oStompFrame, cFrameBuffer, i

  ::oSocket := TStompSocket():new()
  ::oSocket:connect( ::cHost, ::nPort )

  IF ( ::oSocket:isConnected() )
        ::lConnected := .T.

    IF ( ::lHasLoginData == .T. )
      oStompFrame := ::oStompFrameBuilder:buildConnectFrame( ::cDestination, ::cLogin, ::cPassword )
    ELSE
      oStompFrame := ::oStompFrameBuilder:buildConnectFrame( ::cDestination )
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
  ELSE
  //TODO : implement socket connection error handling
  ENDIF

  RETURN ( NIL )

METHOD getErrorMessage() CLASS TStompClient
  RETURN ( ::cErrorMessage )

//TODO - implementar envio de headers
METHOD publish( cDestination, cMessage ) CLASS TStompClient
  LOCAL oStompFrame, cReceiptID := ""

  oStompFrame := ::oStompFrameBuilder:buildSendFrame( cDestination, cMessage )

  IF ( ::lSendReceipt == .T. )
    cReceiptID := HBSTOMP_IDS_PREFIX + _randomAlphabet( HBSTOMP_IDS_LENGHT )
    oStompFrame:addHeader( TStompFrameHeader():new( STOMP_RECEIPT_HEADER,  cReceiptID) )
  ENDIF

  ::oSocket:send( oStompFrame:build(.F.) )

  //TODO - implementar tratamento do retorno, caso exista mensagem reply-to
  IF ( ( ::oSocket:receive() > 0 ) )
    cFrameBuffer := ::oSocket:cReceivedData
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
        cReceiptID := HBSTOMP_IDS_PREFIX + _randomAlphabet( HBSTOMP_IDS_LENGHT )
        oStompFrame:addHeader( TStompFrameHeader():new( STOMP_RECEIPT_HEADER,  cReceiptID) )
      ENDIF

      ::oSocket:send( oStompFrame:build(.F.) )

      IF ( ::oSocket:receive( @cFrameBuffer ) > 0 )
        oStompFrame := oStompFrame:parse( cFrameBuffer )

        DO CASE
        CASE  oStompFrame:cCommand == STOMP_SERVER_COMMAND_MESSAGE
          ::cLastMessage := oStompFrame:cBody
        CASE  oStompFrame:cCommand == STOMP_SERVER_COMMAND_RECEIPT
          ::cLastReceipt := oStompFrame:getHeaderValue( STOMP_RECEIPT_ID_HEADER )
          cDisconnectReceiptID := oStompFrame:getHeaderValue( STOMP_RECEIPT_ID_HEADER )
        CASE  oStompFrame:cCommand == STOMP_SERVER_COMMAND_ERROR
          ::cErrorMessage := oStompFrame:getHeaderValue( STOMP_MESSAGE_HEADER )
        ENDCASE

      ENDIF
    ENDIF
  ENDIF

  ::oSocket:disconnect()
  ::lConnected := .F.

  RETURN ( nil )

METHOD isConnected() CLASS TStompClient
  RETURN ( ::oSocket:isConnected() .AND. (::lConnected == .T. ) )

METHOD subscribe( cDestination, cAckMode, nTimeOut, bProc ) CLASS TStompClient
  LOCAL oStompFrame, i := 0, cFrameBuffer := ""

  oStompFrame := ::oStompFrameBuilder:buildSubscribeFrame( cDestination )
  IIF( ValType( cAckMode ) == 'C', oStompFrame:addHeader( TStompFrameHeader():new( STOMP_ACK_HEADER, cAckMode ) ), )

  ::oSocket:send( oStompFrame:build(.F.) )

  //FIXME : split received data in individual StompFrames
  IF ( ( nLen := ::oSocket:receive() ) > 0 )
    cFrameBuffer := ::oSocket:cReceivedData

    DO WHILE ( Len( cFrameBuffer ) > 0 )
      ? "Frame N: ", STR( ++i ), CRLF

      oStompFrame := oStompFrame:parse( @cFrameBuffer )

      IF ( !oStompFrame:isValid() )
        FOR i := 1 TO oStompFrame:countErrors()
          ? "ERRO: ", oStompFrame:aErrors[i]
        NEXT
      ENDIF

      IF ( oStompFrame:cCommand == STOMP_SERVER_COMMAND_MESSAGE )
        ? "Frame Dump", CRLF, oStompFrame:build(), CRLF
      ELSE
        IF ( oStompFrame:cCommand == STOMP_SERVER_COMMAND_ERROR )
          ::cErrorMessage := oStompFrame:cBody
          BREAK
        ENDIF
      ENDIF

    ENDDO

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

  RETURN ( nil )
