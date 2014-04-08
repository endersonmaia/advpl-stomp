HC=hbmk2

HFLAGS=-lhbct -i./include
LIBSTOMP_SRC=lib/*.prg
STOMPTEST_SRC=test/*.prg

all: libstomp.a src

lib: libstomp.a

test: src
	./stomp_test

libstomp.a:
	$(HC) $(HFLAGS) $(LIBSTOMP_SRC) -hblib -ostomp

src:
	$(HC) $(HFLAGS) $(LIBSTOMP_SRC) $(STOMPTEST_SRC) -ostomp_test

clean:
	rm -rf libstomp.a stomp_test