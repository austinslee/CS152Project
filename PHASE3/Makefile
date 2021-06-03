  
CFLAGS = -g -Wall -ansi -pedantic

mll: mini_l test 

mini_l: mini_l.lex mini_l.y
	bison -d -v mini_l.y
	flex mini_l.lex
	g++ $(CFLAGS) -std=c++11 lex.yy.c mini_l.tab.c -lfl -o phase3
	rm -f lex.yy.c *.output *.tab.c *.tab.h


test: 
	cat ./minFiles/fibonnaci.min | phase3 > ./milFiles/fibonnaci.mil
	cat ./minFiles/primes.min | phase3 > ./milFiles/primes.mil
	cat ./minFiles/mytest.min | phase3 > ./milFiles/mytest.mil
	cat ./minFiles/errors.min | phase3 > ./milFiles/errors.mil
	cat ./minFiles/custom.min | phase3 > ./milFiles/custom.mil
	cat ./minFiles/testy.min | phase3 > ./milFiles/testy.mil


	


