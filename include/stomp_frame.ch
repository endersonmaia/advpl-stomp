#ifndef _STOMP_FRAME_CH
#define _STOMP_FRAME_CH

// ASCII CHARACTERS

#DEFINE NULL      chr(0)
#DEFINE CHR_CR    chr(13)
#DEFINE CHR_LF    chr(10)
#DEFINE CHR_CRLF  CHR_CR+CHR_LF

// STOMP CLIENT COMMANDS

#DEFINE STOMP_CLI_CONNECT       "CONNECT"+CHR_CRLF
#DEFINE STOMP_CLI_SEND          "SEND"+CHR_CRLF
#define STOMP_CLI_SUBSCRIBE     "SUBSCRIBE+CHR_CRLF"
#define STOMP_CLI_UNSUBSCRIBE   "UNSUBSCRIBE"+CHR_CRLF
#define STOMP_CLI_BEGIN         "BEGIN"+CHR_CRLF
#define STOMP_CLI_COMMIT        "COMMIT"+CHR_CRLF
#define STOMP_CLI_ABORT         "ABORT"+CHR_CRLF
#define STOMP_CLI_ACK           "ACK"+CHR_CRLF
#define STOMP_CLI_NACK          "NACK"+CHR_CRLF
#define STOMP_CLI_DISCONNECT    "DISCONNECT"+CHR_CRLF
#define STOMP_CLI_CONNECT       "CONNECT"+CHR_CRLF
#define STOMP_CLI_STOMP         "STOMP"+CHR_CRLF

//STOMP SERVER COMMANDS

#define STOMP_SRV_CONNECTED     "CONNECTED"+CHR_CRLF
#define STOMP_SRV_MESSAGE       "MESSAGE"+CHR_CRLF
#define STOMP_SRV_RECEIPT       "RECEIPT"+CHR_CRLF
#define STOMP_SRV_ERROR         "ERROR"+CHR_CRLF

#endif