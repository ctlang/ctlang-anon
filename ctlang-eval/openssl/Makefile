FFLAGS = -addl -m64

all:

generate:
	$(CTLANGC) -llvm-out -generate-header $(FFLAGS) s3_cbc.ctlang
	$(CTLANGC) -llvm-out -generate-header $(FFLAGS) -opt O3 s3_cbc.ctlang -o s3_cbc.O3.o
	mv *.o *.s *.h obj/
	mv *.bc *.ll ll/

ctverify:
	./s3_cbc_ctverify.sh > verifs/ctverif.results
