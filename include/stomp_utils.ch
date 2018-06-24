#ifndef _STOMP_UTILS_CH
#define _STOMP_UTILS_CH

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

#endif
