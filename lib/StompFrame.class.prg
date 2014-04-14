#ifdef __HARBOUR__
#include "hbclass.ch"
#else
#include "totvs.ch"
#endif

#include "stomp.ch"

CLASS TStompFrame

  DATA cCommand READONLY
  DATA aHeaders INIT {} READONLY
  DATA cBody READONLY
    
  CLASSDATA aStompFrameTypes INIT { "SEND", "SUBSCRIBE", "UNSUBSCRIBE", "BEGIN", "COMMIT", "ABORT", "ACK", "NACK", "DISCONNECT", "CONNECT", "STOMP" }

  METHOD new() CONSTRUCTOR
  METHOD build()

  // Content
  METHOD setCommand( cCommand )
  METHOD setBody( cBody )
  METHOD addHeader( oStompFrameHeader )
  METHOD countHeaders()

  PROTECTED:
    // Validations
    METHOD validateCommand()
    METHOD validateHeader()
    METHOD validateBody()
    METHOD isValid()
  
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
  
  //SWITCH ::cCommand
  //  OTHERWISE;      RETURN .F.
  //END

  RETURN .T.

METHOD validateHeader() CLASS TStompFrame
  RETURN .T.

METHOD validateBody() CLASS TStompFrame
  RETURN .T.

METHOD isValid() CLASS TStompFrame
  RETURN .T.

METHOD build() CLASS TStompFrame
  LOCAL cStompFrame := "", i := 0

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