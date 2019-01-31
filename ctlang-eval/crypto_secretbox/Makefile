CTLANGC ?= $(shell readlink -f $(shell git rev-parse --show-toplevel)/../ctlang/ctlang.byte)

BASE := stdlib.ctlang crypto_poly1305.ctlang
SALSA20 := salsa20.ctlang
AVX := u0.ctlang salsa20-avx2.ctlang
FINAL := crypto_secretbox.ctlang

CREF_SRC := $(BASE) $(SALSA20) $(FINAL)
ASM_SRC := $(BASE) $(AVX) $(FINAL)

FFLAGS = -addl "-mretpoline -fvisibility=hidden -fPIC -fPIE -fno-strict-aliasing -fno-strict-overflow -fstack-protector"

all:

generate:
	$(CTLANGC) -llvm-out -generate-header $(FFLAGS) $(CREF_SRC) -o crypto_secretbox.cref.o
	$(CTLANGC) -llvm-out -generate-header $(FFLAGS) -opt O2 $(CREF_SRC) -o crypto_secretbox.cref.O2.o
	$(CTLANGC) -llvm-out -generate-header $(FFLAGS) $(ASM_SRC) -o crypto_secretbox.asm.o
	$(CTLANGC) -llvm-out -generate-header $(FFLAGS) -opt O2 $(ASM_SRC) -o crypto_secretbox.asm.O2.o
	mv *.o *.s *.h obj/
	mv *.bc *.ll ll/

ctverify:
	./crypto_secretbox_ctverify.sh > verifs/ctverif.results

