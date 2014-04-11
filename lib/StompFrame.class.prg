#ifdef __HARBOUR__
#include "hbclass.ch"
#else
#include "totvs.ch"
#endif

#include "stomp.ch"

CLASS StompFrame

  DATA cCommand READONLY
  DATA aHeaders INIT {} READONLY
  DATA cBody READONLY
    
  CLASSDATA aStompFrameTypes INIT { "SEND", "SUBSCRIBE", "UNSUBSCRIBE", "BEGIN", "COMMIT", "ABORT", "ACK", "NACK", "DISCONNECT", "CONNECT", "STOMP" }

  METHOD new() CONSTRUCTOR

  // Content
  METHOD setCommand( cCommand )
  METHOD setBody( cBody )
  METHOD addHeader( oStompFrameHeader ) INLINE AADD( ::aHeaders, oStompFrameHeader )
  METHOD countHeaders() INLINE LEN( ::aHeaders )

  // Validations
  METHOD validateCommand()
  METHOD validateHeader()
  METHOD validateBody()
  METHOD isValid()
  
ENDCLASS

METHOD new() CLASS StompFrame 
  RETURN SELF

METHOD setCommand( cCommand ) CLASS StompFrame

  ::cCommand := cCommand

  RETURN ( NIL )

METHOD setBody( cBody ) CLASS StompFrame
  
  ::cBody := cBody

  RETURN ( NIL )

METHOD validateCommand() CLASS StompFrame
  RETURN .T.

METHOD validateHeader() CLASS StompFrame
  RETURN .T.

METHOD validateBody() CLASS StompFrame
  RETURN .T.

METHOD isValid() CLASS StompFrame
  RETURN .T.
