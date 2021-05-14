%{
	#include <stdio.h>
	extern FILE * yyin;
	extern int currLine;
	extern int currPos;
	extern int currLine;
	void yyerror(const char *sym) {
	        extern char* yytext;
	        printf("Error %s at %d, column %d: \"%s\" expected",sym, currLine, currPos, yytext);
	}

	
%}


%union {
	char* identVal;
	int numVal;
}



%start Program

%token <identVal> IDENTIFIER
%token <numVal> NUMBER

%token FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR NOT TRUE FALSE RETURN SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET ASSIGN END

%left LT LTE GT GTE EQ NEQ MULT DIV MOD ADD SUB AND OR
%right NOT ASSIGN

%%

Program:	Functions {printf("Program -> Functions\n"); }
;


Functions:	Function Functions { printf("Function -> Function Functions\n"); }
		| { printf("Functions -> (epsilon)\n"); }
;


Function:	FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS Declarations END_PARAMS BEGIN_LOCALS Declarations END_LOCALS BEGIN_BODY Statements END_BODY 
		{ printf("FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY Statements END_BODY\n"); }
;

Declaration:	Identifiers COLON INTEGER
		{ printf("Declaration -> identifiers COLON INTEGER\n"); }
		| Identifiers COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER
		{ printf("Declaration -> identifiers COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER\n"); }
;

Declarations:	Declaration SEMICOLON Declarations 
		{ printf("declarations -> declaration SEMICOLON declarations\n"); }
		| { printf("declarations -> EMPTY\n"); }
;

Identifiers:	IDENTIFIER { printf("Identifiers -> IDENTIFIER %s \n", $1); }
		| IDENTIFIER COMMA Identifiers
		{ printf("Identifiers -> IDENTIFIER COMMA Identifiers\n"); }
;

Statements:	Statement SEMICOLON Statements
		{ printf("Statements -> Statement SEMICOLON Statements\n"); }
		| Statement SEMICOLON
		{ printf("Statements -> Statement SEMICOLON\n"); }
;

Statement:	vars { printf("Statement -> vars\n"); }
		| ifs { printf("Statement -> ifs\n"); }
		| whiles { printf("Statement -> whiles\n"); }
		| reads { printf("Statement -> reads\n"); }
		| writes { printf("Statement -> writes\n"); }
		| dos { printf("Statement -> dos\n"); }
		| continues { printf("Statement -> continues\n"); }
		| returns { printf("Statement -> returns\n"); }
;

vars:		Var ASSIGN expression { printf("vars -> Var ASSIGN expression\n"); }
;

ifs:			IF Bool_Expression THEN Statements ENDIF { printf("ifs -> IF Bool_Expresssion THEN Statements ENDIF\n"); }
			| IF Bool_Expression THEN Statements ELSE Statements ENDIF { printf("ifs -> IF Bool_Expression THEN Statements ELSE Statements ENDIF\n"); }
;

whiles:			WHILE Bool_Expression BEGINLOOP Statements ENDLOOP { printf("whiles -> WHILE Bool_Expression BEGINLOOP Statements ENDLOOP\n"); }
;
		
dos:			DO BEGINLOOP Statements ENDLOOP WHILE Bool_Expression { printf("dos -> DO BEGINLOOPS Statements ENDLOOP WHILE Bool_Expresssion\n"); }
;

reads:			READ Var VLoop { printf("reads -> READ Var VLoop\n"); }
;

writes:			WRITE Var VLoop { printf("writes -> WRITE Var VLoop\n"); }
;

VLoop:			COMMA Var VLoop { printf("VLoop -> COMMA Var VLoop\n"); }
			| { printf("(epsilon)"); }
;


continues:		CONTINUE { printf("continues -> CONTINUE\n"); }
;

returns:			RETURN expression { printf("returns -> RETURN expresssion\n"); }

Bool_Expression:	Relation_and_Expression { printf("Bool_Expresssion -> Relation_and_Expression\n"); }
			| Bool_Expression OR Relation_and_Expression { printf("Bool_Expression -> Bool_Expression OR Relation_and_Expresssion\n"); }
;

Relation_and_Expression:Relation_Expression {printf("Relation_and_Expression -> Relation_Expression"); }
			| Relation_and_Expression AND Relation_Expression {printf("Relation_and_Expression -> Relation_andExpression AND Relation_Expression\n"); }
;

Relation_Expression:	rexp { printf("Relation_Expression -> rexp\n"); }
			| NOT rexp {printf("Relation_Expression -> NOT rexp\n"); }
;

rexp:			expression comp expression { printf("rexp -> expression comp expression\n"); }
			| TRUE { printf("rexp -> TRUE\n"); }
			| FALSE { printf("rexp -> FALSE\n"); }
			| L_PAREN Bool_Expression R_PAREN { printf("rexp -> L_PAREN Bool_Expression R_PAREN\n"); }
;

comp:			EQ {printf("comp -> EQ\n");}
			|NEQ { printf("comp -> NEQ\n"); }
			| LT { printf("comp -> LT\n"); }
			| GT { printf("comp -> GT\n"); }
			| LTE { printf("comp -> LTE\n"); }
			| GTE { printf("comp -> GTE\n"); }
;

expression:		Mult_Expression { printf("expression -> Mult_Expression"); }
			| Mult_Expression ADD expression {printf("expression -> Mult_Expression ADD expression"); }
			| Mult_Expression SUB expression { printf("expression -> Mult_Expression SUB expression"); }
;

Mult_Expression:	Term {printf("Mult_Expression -> Term\n"); }
			| Term MULT Mult_Expression { printf("Mult_Expression -> Term MULT Mult_Expression"); }
			| Term DIV Mult_Expression { printf("Mult_Expression -> Term DIV Mult_Expression"); }
			| Term MOD Mult_Expression { printf("Mult_Expression -> Term MOD Mult_Expression"); }
;

Term:			Positive_Term { printf("Term -> Positive_Term\n"); }
			| SUB Positive_Term { printf("Term -> SUB Positive_Term\n"); }
			| IDENTIFIER Term_Identifier{ printf("Term -> IDENT Term_Identifier\n"); }
;

Positive_Term:		Var { printf("Positive_Term -> Var\n"); }
			| NUMBER { printf("Positive_Term -> NUMBER \n"); }
			| L_PAREN expression R_PAREN { printf("Positive_Term -> L_PAREN expression R_PAREN\n"); }
;

Term_Identifier:	L_PAREN Term_Expression R_PAREN { printf("Term_Identifier -> L_PAREN Term_Expression R_PAREN\n"); }
			| L_PAREN R_PAREN { printf("Term+Identifier -> L_PAREN R_PAREN\n"); }
;

Term_Expression:	expression { printf("Term_Expression -> expression\n"); }
			| expression COMMA Term_Expression { printf("Term_Expression -> expression COMMA Term_Expression\n"); }
;

Var:			IDENTIFIER { printf("Var -> IDENTIFIER %s \n",$1);}
			| IDENTIFIER L_SQUARE_BRACKET expression R_SQUARE_BRACKET { printf("Var -> IDENTIFIER L_SQUARE_BRACKET expression R_SQUARE_BRACKET\n"); }
;

%%


int main(int argc, char ** argv) {
	if (argc >= 2) {
		yyin = fopen(argv[1], "r");
		if (yyin == NULL) {
			yyin = stdin;
		}
	}
	else {
		yyin = stdin;
	}
	yyparse();
	return 1;
}


/*void yerror(const char* sym) {
	extern int currLine;
	extern int currPos;
	extern char*yytext;
	printf("Error at line %d, column %d: \"%s\" expected", currLine, currPos, yytext);

}*/
