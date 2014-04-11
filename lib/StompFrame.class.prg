#ifdef __HARBOUR__
#include "hbclass.ch"
#else
#include "totvs.ch"
#endif

#include "stomp.ch"

CLASS StompFrame

  DATA cCommand READONLY
  DATA aHeaders INIT ARRAY(1) READONLY
  DATA cBody READONLY
  
  CLASSDATA aStompFrameTypes INIT { "SEND", "SUBSCRIBE", "UNSUBSCRIBE", "BEGIN", "COMMIT", "ABORT", "ACK", "NACK", "DISCONNECT", "CONNECT", "STOMP" }
  CLASSDATA nHeaderCount INIT 1

  METHOD new() CONSTRUCTOR

  // Content
  METHOD setCommand( cCommand )
  METHOD addHeader( cName, cValue )
  METHOD setBody( cBody )

  // Validations
  METHOD validateType()
  METHOD validateHeader()
  METHOD validateBody()
  METHOD isValid()
  
ENDCLASS

METHOD new() CLASS StompFrame 
  RETURN SELF

METHOD setCommand( cCommand ) CLASS StompFrame

  ::cCommand := cCommand

  RETURN ( NIL )

METHOD addHeader( cName, cValue ) CLASS StompFrame

  LOCAL oHeader := StompFrameHeader():new( cName, cValue )
  
  ASIZE(::aHeaders, ::nHeaderCount)
  ::aHeaders[::nHeaderCount] := oHeader
  ::nHeaderCount++
 
  RETURN ( NIL )

METHOD setBody( cBody ) CLASS StompFrame
  
  ::cBody := cBody

  RETURN ( NIL )

METHOD validateType() CLASS StompFrame
  RETURN .T.

METHOD validateHeader() CLASS StompFrame
  RETURN .T.

METHOD validateBody() CLASS StompFrame
  RETURN .T.

METHOD isValid() CLASS StompFrame
  RETURN .T.
