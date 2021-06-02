mini_l: mini_l.lex mini_l.y
	bison -d -v mini_l.y
	flex mini_l.lex
	g++ -g -wall -ansi -pedantic --std=c++11 lex.yy.c mini_l.tab.c -lfl -o mini_l


clean: rm -f mini_l mini_l.t.* mini_l.output *~ lex.yy.c lex.yy.cc
