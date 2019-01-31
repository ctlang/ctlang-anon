all:

compile:
	cd donna-c && ./make_donna.sh
	cd donna-ctlang && ./make_donna.sh
	touch compile

bench: compile
	cd donna-c && ./bench.sh
	cd donna-ctlang && ./bench.sh
	@echo "donna-c,$$(tail -n1 donna-c/benchmarks.log)" > bench
	@echo "donna-ctlang,$$(tail -n1 donna-ctlang/benchmarks.log)" >> bench
	@echo "output written to bench"

rebench:
	rm -f bench
	make bench
