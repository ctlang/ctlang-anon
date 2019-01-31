CTLANGC ?= $(shell readlink -f $(shell git rev-parse --show-toplevel)/../ctlang/ctlang.byte)
FFLAGS = -addl -m64

all:

generate:
	$(CTLANGC) -llvm-out -generate-header $(FFLAGS) 20170717_latest_raw.ctlang
	$(CTLANGC) -llvm-out -generate-header $(FFLAGS) -opt O3 20170717_latest_raw.ctlang -o 20170717_latest_raw.O3.o
	$(CTLANGC) -llvm-out -generate-header $(FFLAGS) 20170717_latest.ctlang
	$(CTLANGC) -llvm-out -generate-header $(FFLAGS) -opt O3 20170717_latest.ctlang -o 20170717_latest.O3.o
	$(CTLANGC) -llvm-out -generate-header $(FFLAGS) 20110823_fast.ctlang
	$(CTLANGC) -llvm-out -generate-header $(FFLAGS) -opt O3 20110823_fast.ctlang -o 20110823_fast.O3.o
	mv *.o *.s *.h obj/
	mv *.bc *.ll ll/

ctverify:
	./saga_ctverify.sh > verifs/ctverif.results
