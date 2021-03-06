#ifndef _STOMP_CH
#define _STOMP_CH
#include "totvs.ch"

// ASCII CHARACTERS

#define CHR_NULL  chr(0)
#define CHR_CR    chr(13)
#define CHR_LF    chr(10)
#define CHR_CRLF  CHR_CR+CHR_LF

// GENERAL

#define STOMP_ACCEPTED_VERSIONS       	"1.0,1.1,1.2"

// DEFAULT HEADERS

#define STOMP_ACCEPT_VERSION_HEADER "accept-version"
#define STOMP_HOST_HEADER           "host"
#define STOMP_DESTINATION_HEADER    "destination"
#define STOMP_ID_HEADER             "id"
#define STOMP_TRANSACTION_HEADER    "transaction"
#define STOMP_CONTENT_LENGTH_HEADER "content-length"
#define STOMP_CONTENT_TYPE_HEADER   "content-type"
#define STOMP_RECEIPT_HEADER        "receipt"
#define STOMP_LOGIN_HEADER          "login"
#define STOMP_PASSCODE_HEADER       "passcode"
#define STOMP_HEART_BEAT_HEADER     "heart-beat"
#define STOMP_SESSION_HEADER        "session"
#define STOMP_SERVER_HEADER         "server"
#define STOMP_ACK_HEADER            "ack"
#define STOMP_MESSAGE_ID_HEADER     "message-id"
#define STOMP_SUBSCRIPTION_HEADER   "subscription"
#define STOMP_RECEIPT_ID_HEADER     "receipt-id"
#define STOMP_MESSAGE_HEADER        "message"
#define STOMP_VERSION_HEADER        "version"

// STOMP FRAME CLIENT COMMANDS

#define STOMP_CLIENT_COMMAND_SEND          "SEND"
#define STOMP_CLIENT_COMMAND_SUBSCRIBE     "SUBSCRIBE"
#define STOMP_CLIENT_COMMAND_UNSUBSCRIBE   "UNSUBSCRIBE"
#define STOMP_CLIENT_COMMAND_BEGIN         "BEGIN"
#define STOMP_CLIENT_COMMAND_COMMIT        "COMMIT"
#define STOMP_CLIENT_COMMAND_ABORT         "ABORT"
#define STOMP_CLIENT_COMMAND_ACK           "ACK"
#define STOMP_CLIENT_COMMAND_NACK          "NACK"
#define STOMP_CLIENT_COMMAND_DISCONNECT    "DISCONNECT"
#define STOMP_CLIENT_COMMAND_CONNECT       "CONNECT"
#define STOMP_CLIENT_COMMAND_STOMP         "STOMP"

#define STOMP_CLIENT_COMMANDS {STOMP_CLIENT_COMMAND_SEND, STOMP_CLIENT_COMMAND_SUBSCRIBE, STOMP_CLIENT_COMMAND_UNSUBSCRIBE, STOMP_CLIENT_COMMAND_BEGIN, STOMP_CLIENT_COMMAND_COMMIT, STOMP_CLIENT_COMMAND_ABORT, STOMP_CLIENT_COMMAND_ACK, STOMP_CLIENT_COMMAND_NACK, STOMP_CLIENT_COMMAND_DISCONNECT, STOMP_CLIENT_COMMAND_CONNECT, STOMP_CLIENT_COMMAND_STOMP}

//STOMP FRAME SERVER COMMANDS

#define STOMP_SERVER_COMMAND_CONNECTED     "CONNECTED"
#define STOMP_SERVER_COMMAND_MESSAGE       "MESSAGE"
#define STOMP_SERVER_COMMAND_RECEIPT       "RECEIPT"
#define STOMP_SERVER_COMMAND_ERROR         "ERROR"
#define STOMP_SERVER_COMMANDS {STOMP_SERVER_COMMAND_CONNECTED, STOMP_SERVER_COMMAND_MESSAGE, STOMP_SERVER_COMMAND_RECEIPT, STOMP_SERVER_COMMAND_ERROR}

#define STOMP_COMMANDS {STOMP_CLIENT_COMMAND_SEND, STOMP_CLIENT_COMMAND_SUBSCRIBE, STOMP_CLIENT_COMMAND_UNSUBSCRIBE, STOMP_CLIENT_COMMAND_BEGIN, STOMP_CLIENT_COMMAND_COMMIT, STOMP_CLIENT_COMMAND_ABORT, STOMP_CLIENT_COMMAND_ACK, STOMP_CLIENT_COMMAND_NACK, STOMP_CLIENT_COMMAND_DISCONNECT, STOMP_CLIENT_COMMAND_CONNECT, STOMP_CLIENT_COMMAND_STOMP, STOMP_SERVER_COMMAND_CONNECTED, STOMP_SERVER_COMMAND_MESSAGE, STOMP_SERVER_COMMAND_RECEIPT, STOMP_SERVER_COMMAND_ERROR}

//STOMP SUBSCRIBE SUPPORTED ACK MODES

#define STOMP_SUBSCRIBE_AUTO_ACK_MODE               "auto"
#define STOMP_SUBSCRIBE_CLIENT_ACK_MODE             "client"
#define STOMP_SUBSCRIBE_CLIENT_INDIVIDUAL_ACK_MODE  "client-individual"
#define STOMP_ACK_MODES { STOMP_SUBSCRIBE_AUTO_ACK_MODE, STOMP_SUBSCRIBE_CLIENT_ACK_MODE, STOMP_SUBSCRIBE_CLIENT_INDIVIDUAL_ACK_MODE }

#define STOMP_DEFAULT_PORT 61613

// Limits -- http://stomp.github.io/stomp-specification-1.2.html#Size_Limits

#define STOMP_HEADERS_COUNT_LIMIT 10
#define STOMP_HEADER_SIZE_LIMIT   256
#define STOMP_BODY_SIZE_LIMIT     (64*1024)

#define STOMP_SOCKET_BUFFER_SIZE 4098
#define STOMP_SOCKET_CONNECTION_TIMEOUT 5000 // in miliseconds

// CONNECTION STATUS
#define STOMP_SOCKET_STATUS_CONNECTED         0
#define STOMP_SOCKET_STATUS_MESSAGE_SENT      1
#define STOMP_SOCKET_STATUS_DATA_RECEIVED     2

// CONNECTION ERRORS

#define STOMP_SOCKET_ERROR_CONNECTING         101
#define STOMP_SOCKET_ERROR_RECEIVING_DATA     102


// TSTOMP GLOBALS

#define TSTOMP_IDS_PREFIX "tstomp-"
#define TSTOMP_IDS_LENGHT 16

STATIC FUNCTION _randomAlphabet(nLen)

  LOCAL i := 0, cReturn := "",seconds := Seconds()

  DO WHILE (i < nLen)
    rand := seconds%57 + 65
    seconds -= Seconds()%25

    IF ( INT(rand) >= 91 .AND. INT(rand) <= 96 )
      LOOP
    ELSE
      i++
      cReturn += CHR(INT(rand))
    ENDIF

  ENDDO

  RETURN ( cReturn )

#endif // _STOMP_CH