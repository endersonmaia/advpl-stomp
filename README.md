# hbstomp [![Build Status](https://travis-ci.org/endersonmaia/hbstomp.svg)](https://travis-ci.org/endersonmaia/hbstomp)

Library for Harbour/ADVPL that implements STOMP messaging protocol (http://stomp.github.io).

## Goals

These are the initial goals of this library

- Build and validates a message;
- Send messages to STOMP Server;
- Parse STOMP server responses;
- Learn Harbour and ADVPL programming;
- Get rich :moneybag: ;

## How-to Use it

With this version, you can build and send basic STOMP Client Frames. Subscribing to STOMP queues isn't working at the moment.

````xbase
PROCEDURE MAIN()

  oStompClient := TStompClient():new("127.0.0.1", 61613)
  oStompClient:connect()

  IF ( oStompClient:isConnected() )

    oStompClient:publish( "/queue/hbstomp", "First message." )
    oStompClient:publish( "/queue/hbstomp", "Second message!" )

    oStompClient:disconnect()
  ELSE
    OutStd( "Failed to connect.", hb_EOL() )
    OutStd( "Message: ", oStompClient:getErrorMessage(), hb_EOL() )
    ErrorLevel(1)
  ENDIF
  
  RETURN ( NIL )
````

# License

The MIT License (MIT)

Copyright (c) 2014 Enderson Maia <endersonmaia (_at_) gmail (_dot_) com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
