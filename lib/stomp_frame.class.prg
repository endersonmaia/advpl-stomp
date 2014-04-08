#ifdef __HARBOUR__
  #include "hbclass.ch"
#else
  #include "totvs.ch"
#endif

#include "stomp.ch"

CLASS StompFrame

  DATA aHeaders INIT ARRAY(STOMP_HEADERS_COUNT_LIMIT)
  DATA cBody READONLY
  DATA cType READONLY

  CLASSDATA aStompFrameTypes INIT {"CONNECT","SEND","SUBSCRIBE","UNSUBSCRIBE","BEGIN","COMMIT","ABORT","ACK","NACK","DISCONNECT","CONNECT","STOMP"}

  METHOD new() CONSTRUCTOR
  METHOD setType(cStompFrameType)
  METHOD addHeader(oStompFrameHeader)
  METHOD setBody(cStompFrameBody)
  METHOD validatesType()
  METHOD isValid()

ENDCLASS

METHOD new() CLASS StompFrame
RETURN SELF

METHOD setType(cStompFrameType) CLASS StompFrame
  ::cType := cStompFrameType
RETURN SELF

METHOD addHeader(cHeader, cName) CLASS StompFrame
RETURN SELF

METHOD setBody(cStompFrameBody) CLASS StompFrame
RETURN SELF

METHOD validatesType() CLASS StompFrame
RETURN .F.

METHOD isValid() CLASS StompFrame
RETURN .T.
  
RETURN SELF