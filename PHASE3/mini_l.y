%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <map>
	#include <string.h>
	#include <vector>
	#include <set>

	



	int tempCount = 0;
	int labelCount = 0;	

	extern char* yytext
	extern int currPos

	std::map<std::string, std::string> varTemp;
	std::map<std::string, int> arrSize;

	bool mainFunc = false;

	std::set<std::string> reserved {"NUMBER", "IDENT", "RETURN", "FUNCTION". "SEMICOLON", "BEGIN_PARAMS", "BEGIN_LOCALS", "END_LOCALS", "BEGIN_BODY", "END_BODY", "BEGINLOOP", "ENDLOOP", "COLON", "INTEGER", "COMMA", "ARRAY", "L_SQUARE_BRACKET", "R_SQUARE_BRACKET", "L_PAREN", "R_PAREN", "IF", "ELSE", "THEN", "MOD", "AND", "OR", "NOT", "Function", "Declarations", "Declaration", "Vars", "Var", "Expressions", "Expression", "Idents", "Ident", "Bool_Expr", "Relation_And_Expr", "Relation_Expr_Inv", "Relation_Expr", "Comp", "Multiplicative_Expr", "Term", "Statements", "Statement"};



	void yyerror(const char* s);
	
	int yylex();
	std::string new_temp();
	std::string new_label();

	
%}


%union {
	char* identVal;
	int numVal;
	struct S {
		char* code;
	} statement;
	struct E {
		char* place;
		char* code;
		bool arr;
	} expression;
}

%error-verbose
%start Program

%token <identVal> IDENTIFIER
%token <numVal> NUMBER

%type <expression> Function FuncIdent Declarations Declaration Vars Var Expressions Expression Idents Ident
%type <expression> Bool-Expr Relation-And-Expr Relation-Expr-Inv Relation-Expr Comp Multiplicative-Expr Term
%type <statement> Statements Statement

%token RETURN FUNCTION SEMICOLON BEGIN_PARAMS END_PARAMS BEIGIN_LOCALS END_LOCCALS BEGIN_BODY END_BODY BEGIN_LOOP END_LOOP
%token COLON INTEGER COMMA ARRAY L_SQUARE_BRACKET R_SQUARE_BRACKET L_PAREN R_PAREN
%token IF ELSE THEN CONTINUE ENDIF OF READ WRITE DO WHILE FOR


%left ASSIGN
%left OR
%left AND
%right NOT
%left LT LTE GT GTE EQ NEQ
%left ADD SUB
%left MULT DIV MOD

%%

Program:         %empty
{
	if(!mainFunc) {
		printf("No main function declared!\n");
	}
}
| Function Program
{
};

Function:	FUNCTION FuncIdent SEMICOLON BEGIN_PARAMS Declarations END_PARAMS BEGIN_LOCALS Declarations END_LOCALS BEGIN_BODY Statements END_BODY {
	std::string temp = "func ";
	temp.append($2.place);
	temp.append("\n");
	std::string s = $2.place;
	if (s == "main") {
		mainFunc = true;
	}
	temp.append($5.code);
	std::string decs = $5.code;
	int dec_num = 0;
	while(decs.find(".") != std::string::npos) {
		size_t pos = decs.find(".");
		decs.replace(pos, 1, "=");
		std::string part = ", $" + std::to_string(decNum) + "\n";
		decNum++;
		decs.replace(decs.find("\n", pos), 1, part);
	}
	temp.append(decs);
	
	temp.append($8.code);
	std::string statements = $11.code;
	if (statements.find("continue") != std::string::npos) {
		printf("ERROR: Continue outside loop in function %s\n", $2.place);
	}
	temp.append(statements);
	temp.append("endfunc\n\n");
	printf(temp.c_str());
};

Declarations: Declaration SEMICOLON Declarations {
	std::string temp;
	temp.append($1.code);
	temp.append($3.code);
	$$.code = strdup(temp.c_str());
	$$.place = strdup("");
};

Declaration: Idents COLON INTEGER 
	{
		size_t left = 0;
		size_t right = 0;
		std::string parse($1.place);
		std::string temp;
		bool ex = false;
		while(!ex) {
			right = parse.find("|", left);
			temp.append(". ");
			if(right == std::string::npos) {
				std::string ident = parse.substr(left, right);
				if (reserved.find(ident) != reserved.end()) {
					printf("Identifier %s's name is a reserved word.\n", ident.c_str());
				}
				if (funcs.find(ident) != funcs.end() || varTemp.find(ident) != varTemp.end()) {
					printf("Identifier %s is previously declared.\n", ident.c_str());
				}
				else {
					varTemp[ident] = ident;
					arrSize[ident] = 1;
				}
				temp.append(ident);
				ex = true;
			}
			else {
				std::string ident = parse.substr(left, right-left);	
				if (reserved.find(ident) != reserved.end()) {
					printf("Identifier %s's name is a resreved word.\n", ident.c_str());
				}
				if (funcs.find(ident) != funcs.end() || varTemp.find(ident) != varTemp.end()) {
					printf("Identifier %s is previously declared.\n", ident.c_str());
				}
				else {
					varTemp[ident] = ident;
					arrSize[ident] = 1;
				}
				temp.append(ident);
				left = right + 1;
			}
			temp.append("\n");
		}
		$$.code = strdup(temp.c_str());
		$$.place = strdup("");
	}
	| Idents COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER 
	{
		if($5 <= 0) {
			printf("Array size can't be less than one\n");
		}

		size_t left = 0;
		size_t right = 0;
		std::string parse($1.place);
		std::string temp;
		bool ex = false;
		while(!ex) {
			right = parse.find("|", left);
			temp.append(".[] ");
			if (right == std::string::npos) {
				std::string ident = parse.substr(left, right);
				if (rserved.find(ident) != reserved.end()) {
					printf("Identifier %s's name is a reserved word.\n", ident.c_str());
				}
        	                if (funcs.find(ident) != funcs.end() || varTemp.find(ident) != varTemp.end()) {
                	                printf("Identifier %s is previously declared.\n", ident.c_str());
                        	}
				else { 
					varTemp[ident] = ident;
					arrSize[ident] = $5;
				}
				temp.append(ident);
				ex = true;
			}
			else {
				std::string ident = parse.substr(left, right-left);
				if (reserved.find(ident) != reserved.end()) {
					printf("Identifier %s's name is a reserved word.\n", ident.c_str());
				}
        	                if (funcs.find(ident) != funcs.end() || varTemp.find(ident) != varTemp.end()) {
                	                printf("Identifier %s is previously declared.\n", ident.c_str());
                        	}
	                        else {
        	                        varTemp[ident] = ident;
                	                arrSize[ident] = $5;
                        	}
				temp.append(ident);
				left = right + 1;
			}
			temp.append(", ");
			temp.append(std::to_string($5));
			temp.append("\n");
		}
		$$.code = strdup(temp.c_str());
		$$.place = strdup("");
	}
	/*Enum is extra credit maybe I implement*/
;

FuncIdent: IDENT
	{
		if (funcs.find($1) != funcs.end()) {
			printf("function name %s already declared.\n", $1);
		}
		else {
			funcs.insert($1);
		}
		$$.place = strdup($1);
		$$.code = strdup("");
	}
;
		

Ident: IDENT
	{
		$$.place = strdup($1.place);
		$$.code = strdup("");
	}
;		

Idents: Ident
	{
		$$.place = strdup($1.place);
		$$.code = strdup("");
	}
	| Ident COMMA Idents
	{
		std::string temp;
		temp.append($1.place);
		temp.append("|");
		temp.append($3.place);
		
		$$.place = strdup(temp.c_str());
		$$.code = strdup("");
	}
;

Statements: Statement SEMICOLON Statements
	{
		std::string temp;
		temp.append($1.code);
		temp.append($3.code);
		$$.code = strdup(temp.c_str());
	}
	| Statement SEMICOLON
	{
		$$.code = strdup($1.code);
	}
;

Statement: Var ASSIGN Expression
	{
		std::string temp;
		temp.append($1.code);
		temp.append($3.code);
		std::string middle = $3.place;
		if ($1.arr && $3.arr) {
			temp += "[]= ";
		} else if ($1.arr) {
			temp += "[]= ";
		} else if ($3.arr) {
			temp += "= ";
		} else { 
			temp += "= ";
		}
		temp.append($1.place);
		temp.append(", ");
		temp.append(middle);
		temp += "\n";
		$$.code = strdup(temp.c_str());
	}
	| IF Bool-Expr THEN Statements ENDIF
	{
		std::string ifS = new_label();
		std::string after = new_label();
		std::string temp; 
		temp.append($2.code);
		temp = temp + "?:= " + ifS + ", " + $2.place + "\n";
		temp = temp + ":= " + after + "\n";
		temp = temp + ": " + ifS + "\n";
		temp.append($4.code);
		temp = temp + ": " + after + "\n";
		$$.code = strdup(temp.c_str());
	}
	| IF Bool-Expr THEN Statements ELSE Statements ENDIF
	{
		std::string ifS = new_label();
		std::string after = new_label();
		std::string temp;
		temp.append($2.code);
                temp = temp + "?:= " + ifS + ", " + $2.place + "\n";
		temp.append($5.code);
                temp = temp + ":= " + after + "\n";
                temp = temp + ": " + ifS + "\n";
		temp.append($4.code);
		temp = temp + ": " + after + "\n";
		$$.code = strdup(temp.c_str());
	}
	| WHILE Bool-Expr BEGINLOOP Statements ENDLOOP	
	{
		std::string temp;
		std::string BW = new_label();
		std::string BL = new_label();
		std::string EL = new_label();
		std::string statement = $4.code;

		size_t con = statement.find("continue");
		while(con != std::string::npos) {
			statement.replace(con, 8, ":= " + begin);
			con = statement.find("continue");
		}
		temp.append(": ");
		temp.append(BW);
		temp.append("\n");
		temp.append($2.code);
		temp.append("?:= ");
		temp.append(BL);
		temp.append(", ");
		temp.append($2.place);
		temp.append("\n");
		temp.append(":= ");
		temp.append(EL);
		temp.append("\n");
		temp.append(": ");
		temp.append(BL);
		temp.append("\n");
		temp.append(statement);
		temp.append(":= ");
		temp.append(BW);
		temp.append("\n");
		temp.append(": ");
		temp.append(EL);
		temp.append("\n");
		
		$$.code = strdup(temp.c_str());
	}
	| DO BEGINLOOP Statements ENDLOOP WHILE Bool-Expr
	{
		std::string temp;
		std::string BL = new_label();
		std::string con = new_label();
		std::string statement = $3.code;
		size_t cur = statement.find("continue");
		while(cur != std::string::npos) {
			statement.replace(cur, 8, ":= " + con);
			cur = statement.find("continue");
		}
		temp.append(": ");
		temp.append(BL);
		temp.append("\n");
		temp.append(statement);
		temp.append(": ");
		temp.append(con);
		temp.append("\n");
		temp.append($6.code);
		temp.append("?:= ");
		temp.append(BL);
		temp.append(", ");
		temp.append($6.place);
		temp.append("\n");
  
		$$.code = strdup(temp.c_str());
	}
	| FOR Var ASSIGN NUMBER SEMICOLON Bool-Expr Var ASSIGN Expression BEGINLOOP Statements ENDLOOP
	{
		std::string temp;
		std::string count = new_temp();
		std::string check = new_label();
		std::string inner = new_label();
		std::string increment = new_label();
		std::string after = new_label();
		std::string statement = $12.code;
		size_t pos = statement.find("continue");
		while (pos != std::string::npos) {
			statement.replace(pos, 8, ":= " + increment);
			pos = code.find("continue");
		}
		temp.append($2.code);
		std::string middle = std::to_string($4);
		if ($2.arr) {
			temp += "[]= ";
		}
		else {
			temp += "= ";
		}
		temp.append($2.place);
		temp.append(", ");
		temp.append(middle);
		temp += "\n";
		temp += ": " + check + "\n";
		temp.append($6.code);
		temp += "?:= " + inner + ", ";
		temp.append($6.place);
		temp.append("\n");
		temp += ":= " + after + "\n";
		temp += ": " + inner + "\n";
		temp.append(statement);
		temp += ": " + increment + "\n";
		temp.append($8.code);
		temp.append($10.code);
		if ($8.arr) {
			temp += "[]= ";
		} 
		else {
			temp += "= ";
		}
		temp.append($8.place);
		temp.append(", ");
		temp.append($10.place);
		temp += "\n";
		temp += ":= " + check + "\n";
		temp += ": " + after + "\n";
		$$.code = strdup(temp.c_str());
	}
	| READ Vars
	{
		std::string temp = $2.code;
		size_t pos = 0;
		do {
	  		pos = temp.find("|", pos);
			if (pos == std::string::npos)
				break;
			temp.replace(pos, 1, "<");
		} while (true);
		$$.code = strdup(temp.c_str());
	}
	| WRITE Vars
	{
		std::string temp = $2.code;
		size_t pos = 0;
		do {
			pos = temp.find("|", pos);
			if (pos == std::string::npos)
				break;
			temp.replace(pos, 1, ">");
		} while (true);
		$$.code = strdup(temp.c_str());
	}
	| CONTINUE
	{
		std::string temp = "continue\n";
		$$.code = strdup(temp.c_str());
	}
	| RETURN Expression
	{
		std::string temp;
		temp.append($2.code);
		temp.append("ret ");
		temp.append($2.place);
		temp.append("\n");
		$$.code = strdup(temp.c_str());
	}
;



Bool_Expr: Relation_And_Expr
	{
		$$.place = strdup($1.place);
		$$.code = strdup($1.code);
	}
	| Relation_And_Expr OR Bool_Expr
	{
		std::string dest = new_temp()

Term: Var
	{
		if ($$.array == true) {
			std::string temp;
			std::string intermediate = newTemp();
			temp.append($1.code);
			temp.append(". ");
			temp.append(intermediate);
			temp.append("\n");
			temp.append("=[] ");
			temp.append(intermediate);
			temp.append(", ");
			temp.append($1.place);
			temp.append("\n");
		$$.code = strdup(temp.c_str());
		$$.place = strdup(intermediate.c_str());
		$$.array = false;
		}
		else {
			$$.code = strdup($1.code);
			$$.place = strdup($1.place);
		}
	}
	| SUB Var
	{
		$$.place = strdup(newTemp().c_str());
		std::string temp;
		temp.append($2.code);
		temp.append(". ");
		temp.append($$.place);
		temp.append("\n");
		if ($2.array) {
			temp.append("=[] ");
			temp.append($$.place);
			temp.append(", ");
			temp.append($2.place);
			temp.append("\n");
		}
		else {
			temp.append("= ");
			temp.append($$.place);
			temp.append(", ");
			temp.append($2.place);
			temp.append("\n");
		}
		temp.append("* ");
		temp.append($$.place);
		temp.append(", ");
		temp.append($$.place);
		temp.append(", -1\n");
  
		$$.code = strdup(temp.c_str());
		$$.array = false;
	}
	| NUMBER
	{
		$$.code = strdup(empty);
		$$.place = strdup(std::to_string($1).c_str());
	}
	| SUB NUMBER
	{	
		std::string temp;
		temp.append("-");
		temp.append(std::to_string($2));
		$$.code = strdup(empty);
	$$.place = strdup(temp.c_str());
	}
	| L_PAREN Expression R_PAREN
	{
		  $$.code = strdup($2.code);
		  $$.place = strdup($2.place);
	}
	| SUB L_PAREN Expression R_PAREN
	{
		  $$.place = strdup($3.place);
		  std::string temp;
		  temp.append($3.code);
		  temp.append("* ");
		  temp.append($3.place);
		  temp.append(", ");
		  temp.append($3.place);
		  temp.append(", -1\n");
		  $$.code = strdup(temp.c_str());
	}
	| Ident L_PAREN Expressions R_PAREN
	{
		  if (functions.find(std::string($1.place)) == functions.end()) {
			    char temp[128];
			    snprintf(temp, 128, "Use of undeclared function %s", $1.place);
			    yyerror(temp);
		  }

		  $$.place = strdup(newTemp().c_str());

		  std::string temp;
		  temp.append($3.code);
		  temp.append(". ");
		  temp.append($$.place);
		  temp.append("\n");
		  temp.append("call ");
		  temp.append($1.place);
		  temp.append(", ");
		  temp.append($$.place);
		  temp.append("\n");
  
		  $$.code = strdup(temp.c_str());
	}
;


Var: Ident L_SQUARE_BRACKET Expression R_SQUARE_BRACKET
	{
		std::string temp;
		std::string id = $1.place
		if(funcs.find(id) == funcs.end() && varTemp.find(id) == varTemp.end()) {
			printf("Identifier %s is not declared.\n", id.c_str());
		}
		else if (arrSize[id] == 1 ) {
			printf("Provided index for non-array Identifier %s.\n", id.c_str());
		}
		temp.append($1.place);
		temp.append(", ");
		temp.append($3.place);
		$$.code = strdup($3.code);
		$$.place = strdup(temp.c_str());
		$$.arr = true;
	}
	| Ident
	{
		std::string temp;
		$$.code = strdup("");
		std::string id = $1.place;
		if (funcs.find(id) == funcs.end() && varTemp.find(id) == varTemp.end()) {
			printf("Identifier %s is not declared.\n", id.c_str());
		}
		else if (arrSize[id] > 1) {
			printf("Did not provide index for array Identifier %s.\n", id.c_str());
		}
		$$.place = strdup(id.c_str());
		$$.arr = false;
	}
;
	




		

			
		
		


	






%%

void yyerror(const char* s) {
	extern int yylineno;
	extern char **yytext;
	
	prtinf("%s on line %d at char %d at symbol \"%s\"\n", $, yylineno, currPos, yytext);
	exit(1);
}

std::string new_temp() {
	std::string t = "t" + std::to_string(tempCount);
	tempCount++;
	return t;
}

std::string new_label() {
	std::string l = "L" + std::to_string(labelCount);
	labelCount++;
	return l;
}


/*int main(int argc, char ** argv) {
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
}*/


/*void yerror(const char* sym) {
	extern int currLine;
	extern int currPos;
	extern char*yytext;
	printf("Error at line %d, column %d: \"%s\" expected", currLine, currPos, yytext);

}*/
