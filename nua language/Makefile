cs315f19_group17: y.tab.c lex.yy.c
	gcc -o cs315f19_group17 y.tab.c
	rm -f lex.yy.c y.tab.c y.output *~
	./cs315f19_group17 <CS315f19_group17.test
y.tab.c: CS315f19_group17.yacc lex.yy.c
	yacc CS315f19_group17.yacc
lex.yy.c: CS315f19_group17.lex
	lex CS315f19_group17.lex