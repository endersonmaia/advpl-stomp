#include 'totvs.ch'
#include 'testsuite.ch'
#include 'stomp.ch'

TestSuite StompTest Description 'Testing STOMP protocol implementation' Verbose
    Feature CheckInvalidFrame Description 'We are able to validate a frame'
EndTestSuite

Feature CheckInvalidFrame TestSuite StompTest
    LOCAL oBuilder, oStompFrame

    oBuilder := TStompFrameBuilder():New()
    oStompFrame := oBuilder:buildConnectFrame( '127.0.0.1', 'user', 'passcode' )

    ::Expect( oStompFrame::cCommand ):ToBe( STOMP_CLIENT_COMMAND_CONNECT )
    ::Expect( oStompFrame::getHeaderValue( STOMP_ACCEPT_VERSION_HEADER ) ):Not():ToBe( NIL )
    ::Expect( oStompFrame::getHeaderValue( STOMP_ACCEPT_VERSION_HEADER ) ):ToBe( STOMP_ACCEPTED_VERSIONS )
 
    Return

CompileTestSuite StompTest