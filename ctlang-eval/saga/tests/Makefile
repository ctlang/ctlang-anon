all:

compile:
	cd openssl-c && ./make_openssl.sh
	cd openssl-ctlang-ugly && ./make_openssl.sh
	touch compile

test: compile
	cd openssl-c && ./apps/openssl test
	cd openssl-ctlang-ugly && ./apps/openssl test
	touch test

bench: test
	cd openssl-c/apps && ./bench.sh
	cd openssl-ctlang-ugly/apps && ./bench.sh
	@echo "openssl-c" > bench
	@tail -n7 openssl-c/apps/benchmarks.log >> bench
	@echo "openssl-ctlang-ugly" >> bench
	@tail -n7 openssl-ctlang-ugly/apps/benchmarks.log >> bench
	@echo "output written to bench"

recompile:
	rm -f compile
	make compile

retest:
	rm -f test
	make test

rebench:
	rm -f bench
	make bench
