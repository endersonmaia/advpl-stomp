#ifndef _STOMP_CH
#define _STOMP_CH

  #ifdef PROTHEUS
    #define __PROTHEUS__
    #include "totvs.ch"
    #include "stomp_totvs_compat.ch"
  #else
    #ifdef __HARBOUR__
      #include "hbclass.ch"
    #endif
  #endif

  #include "stomp_frame.ch"
  #include "stomp_frame_header.ch"

  // Limits -- http://stomp.github.io/stomp-specification-1.2.html#Size_Limits

  #define STOMP_HEADERS_COUNT_LIMIT	10
  #define STOMP_HEADER_SIZE_LIMIT		256
  //#define STOMP_BODY_SIZE_LIMIT		(64*1024)

#endif