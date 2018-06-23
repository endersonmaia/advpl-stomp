#ifndef _STOMP_CH
#define _STOMP_CH
#define DEBUG

  #ifdef PROTHEUS
    #define __PROTHEUS__
    #include "totvs.ch"
    #include "stomp_totvs_compat.ch"
  #else
    #ifdef __HARBOUR__
      #include "hbclass.ch"
      #include "hbsocket.ch"
    #endif
  #endif

  #include "stomp_frame.ch"
  #include "stomp_frame_header.ch"
  #include "stomp_socket.ch"

  #define STOMP_DEFAULT_PORT 61613

  // Limits -- http://stomp.github.io/stomp-specification-1.2.html#Size_Limits

  #define STOMP_HEADERS_COUNT_LIMIT 10
  #define STOMP_HEADER_SIZE_LIMIT   256
  #define STOMP_BODY_SIZE_LIMIT     (64*1024)

  #define HBSTOMP_IDS_PREFIX "hbstomp-"
  #define HBSTOMP_IDS_LENGHT 16

#endif