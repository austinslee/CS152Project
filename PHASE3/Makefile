  
CFLAGS = -g -Wall -ansi -pedantic

mini_l: mini_l.lex mini_l.y
	bison -d -v mini_l.y
	flex mini_l.lex
	g++ $(CFLAGS) -std=c++11 lex.yy.c mini_l.tab.c -lfl -o phase3
	cat fibonnaci.min | phase3 > fibonnaci.mil
	rm -f lex.yy.c *.output *.tab.c *.tab.h

test: phase3
	cat fibonnaci.min | phase3 > fibonnaci.mil
