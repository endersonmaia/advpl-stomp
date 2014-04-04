HC=hbmk2

HFLAGS=-lhbct -i./include
LIBSTOMP_SRC=lib/*.prg
STOMPTEST_SRC=test/*.prg

all: src libstomp.a

libstomp.a:
	$(HC) $(HFLAGS) $(LIBSTOMP_SRC) -hblib

src:
	$(HC) $(HFLAGS) $(LIBSTOMP_SRC) $(STOMPTEST_SRC)

clean:
	rm -rf libstomp.a stomp
