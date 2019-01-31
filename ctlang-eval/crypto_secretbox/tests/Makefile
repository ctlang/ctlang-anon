all:

setup:
	cd libsodium-c-cref && ./autogen.sh
	cd libsodium-c-asm && ./autogen.sh
	cd libsodium-ctlang-cref && ./autogen.sh
	cd libsodium-ctlang-asm && ./autogen.sh
	touch setup

compile: setup
	cd libsodium-c-cref && ./make_libsodium.sh
	cd libsodium-c-asm && ./make_libsodium.sh
	cd libsodium-ctlang-cref && ./make_libsodium.sh
	cd libsodium-ctlang-asm && ./make_libsodium.sh
	touch compile

bench: compile
	cd libsodium-c-cref && ./bench.sh
	cd libsodium-c-asm && ./bench.sh
	cd libsodium-ctlang-cref && ./bench.sh
	cd libsodium-ctlang-asm && ./bench.sh
	@tail -n3 libsodium-c-cref/benchmarks.log > bench
	@tail -n3 libsodium-c-asm/benchmarks.log >> bench
	@tail -n3 libsodium-ctlang-cref/benchmarks.log >> bench
	@tail -n3 libsodium-ctlang-asm/benchmarks.log >> bench
	@echo "output written to bench"

recompile:
	rm -f compile
	make compile

rebench:
	rm -f bench
	make bench
