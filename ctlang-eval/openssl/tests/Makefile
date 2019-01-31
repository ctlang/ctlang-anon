all:

compile:
	cd openssl-c && ./make_openssl.sh
	cd openssl-ctlang && ./make_openssl.sh
	touch compile

bench: compile
	cd openssl-c/apps && ./bench.sh
	cd openssl-ctlang/apps && ./bench.sh
	@echo "results are in the distributions in openssl-{c,ctlang}/apps/{client,server}.time" | tee bench

recompile:
	rm -f compile
	make compile

rebench:
	rm -f bench
	make bench
