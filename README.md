# advpl-stomp

Library for ADVPL that implements STOMP messaging protocol (http://stomp.github.io).

## Goals

These are the initial goals of this library

- Build and validates a message;
- Send messages to STOMP Server;
- Parse STOMP server responses;
- Learn ADVPL programming;
- Get rich :moneybag: ;

## How-to Use it

With this version, you can build and send basic STOMP Client Frames. Subscribing to STOMP queues isn't working at the moment.

````xbase
#include 'totvs.ch'
#include 'stomp.ch'

USER FUNCTION STOMP

  LOCAL oStompClient, oLogger

  oLogger := Logger():New( 'ADVPL-STOMP' )
  oStompClient := TStompClient():new("127.0.0.1", 61613, "user", "password", "vhost")
  oStompClient:connect()

  IF ( oStompClient:isConnected() )
    oLogger:Info( "Connected to 127.0.0.1" )

    oStompClient:publish( "/queue/advpl", "First message from ADVPL!" )

    oStompClient:subscribe( "/queue/hbstomp", "auto", , {|msg, oFrame| oLogger:Info("Mensagem : {1} {2}", { msg, oFrame:getHeaderValue("message-id") } ) } )

    oStompClient:disconnect()
  ELSE
    oLogger:Error( "Failed to connect" )
  ENDIF
  
RETURN
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
