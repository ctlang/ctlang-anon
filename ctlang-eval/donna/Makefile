all:

generate:
	$(CTLANGC) -llvm-out -generate-header curve25519-c64.ctlang
	$(CTLANGC) -llvm-out -opt O2 curve25519-c64.ctlang -o curve25519-c64.O2.o
	mv *.o *.s *.h obj/
	mv *.bc *.ll ll/

ctverify:
	./curve25519_ctverify.sh > verifs/ctverif.results
