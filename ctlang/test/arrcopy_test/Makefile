all: salsa.bin

.PRECIOUS: ctlang_%.h

ctlang_%.o: ctlang_%.ctlang
	../../ctlang.byte -ast-out -pseudocode -generate-header -llvm-out -debug $^

ctlang_%.h: ctlang_%.o
	touch $@

main_%.o: %.c ctlang_%.h
	clang -g -c $< -o $@

%.bin: ctlang_%.o main_%.o
	clang -g $^ -o $@

clean:
	rm -f *.s *.o *.bc ctlang_*.h *.pseudo.ctlang *.ll *.bin *.res *.ast.ml *.tast.ml
