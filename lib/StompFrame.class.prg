#include "stomp.ch"

CLASS TStompFrame

  DATA cCommand INIT "" READONLY
  DATA aHeaders INIT {} READONLY
  DATA cBody INIT "" READONLY

  CLASSDATA aStompFrameTypes INIT { "SEND", "SUBSCRIBE", "UNSUBSCRIBE", "BEGIN", "COMMIT", "ABORT", "ACK", "NACK", "DISCONNECT", "CONNECT", "STOMP" }

  METHOD new() CONSTRUCTOR
  METHOD build()

  // Content
  METHOD setCommand( cCommand )
  METHOD setBody( cBody )
  METHOD addHeader( oStompFrameHeader )
  METHOD countHeaders()

    // Validations
  METHOD validateCommand()
  METHOD validateHeader()
  METHOD validateBody()
  METHOD isValid()
  METHOD headerExists( cHeaderName )

ENDCLASS

METHOD countHeaders() CLASS TStompFrame
  RETURN ( LEN( ::aHeaders ) )

METHOD new() CLASS TStompFrame
  RETURN SELF

METHOD addHeader ( oStompFrameHeader ) CLASS TStompFrame
  AADD( ::aHeaders, oStompFrameHeader )
  RETURN ( NIL )

METHOD setCommand( cCommand ) CLASS TStompFrame

  ::cCommand := cCommand

  RETURN ( NIL )

METHOD setBody( cBody ) CLASS TStompFrame

  ::cBody := cBody

  RETURN ( NIL )

METHOD validateCommand() CLASS TStompFrame
  LOCAL lReturn := .F.

  SWITCH ::cCommand
  CASE "SEND"
  CASE "SUBSCRIBE"
  CASE "UNSUBSCRIBE"
  CASE "BEGIN"
  CASE "COMMIT"
  CASE "ABORT"
  CASE "ACK"
  CASE "NACK"
  CASE "DISCONNECT"
  CASE "CONNECT"
  CASE "STOMP"
    lReturn := .T.
     EXIT
  END

  RETURN ( lReturn )

METHOD headerExists( cHeaderName )
  LOCAL lReturn := .F., i

  FOR i := 1 TO ::countHeaders()
    IIF( ::aHeaders[i]:cName = cHeaderName, lReturn := .T., )
  NEXT

  RETURN ( lReturn )

METHOD validateHeader() CLASS TStompFrame
  LOCAL lReturn := .F.

  SWITCH ::cCommand
  CASE "CONNECT"
  CASE "STOMP"
    IIF ( ( ::headerExists("accept-version") .AND. ::headerExists("host") ), lReturn := .T., )
  EXIT
  CASE "SEND"
    IIF ( ::headerExists("destination"), lReturn := .T., )
  EXIT
  END

  RETURN ( lReturn )

METHOD validateBody() CLASS TStompFrame
  RETURN .T.

METHOD isValid() CLASS TStompFrame
  LOCAL lReturn := .F.

  lReturn := ::validateCommand()
  lReturn := ::validateHeader()

  RETURN ( lReturn )


METHOD build() CLASS TStompFrame
  LOCAL cStompFrame := "", i

  IF !::isValid()
    RETURN ( .F. )
  ENDIF

  // build COMMAND
  cStompFrame += ::cCommand + CHR_CRLF

  // build HEADERS
  FOR i := 1 TO ::countHeaders()
    cStompFrame += ::aHeaders[i]:cName + ':' + ::aHeaders[i]:cValue
    cStompFrame += CHR_CRLF
  NEXT
  cStompFrame += CHR_CRLF

  // build BODY
  cStompFrame += ::cBody
  cStompFrame += CHR_NULL + CHR_CRLF

  RETURN ( cStompFrame )
