/*
    Flex specification that recognizes tokens in the MINI-L language.
    Prints out an error message and exits if any unrecognized character is
    encountered in the input.
    Prints the identified tokens to the screen, one token per line.
*/

%{
#include "y.tab.h"
int currLine = 1, currPos = 1;
%}

LETTER      [a-zA-Z]
DIGIT       [0-9]
IDENTIFIER  ({LETTER}({LETTER}|{DIGIT}|"_")*({LETTER}|{DIGIT}))|{LETTER}
INVALIDID_START               ({DIGIT}|"_")+{IDENTIFIER}
INVALIDID_ENDSINUNDERSCORE    {IDENTIFIER}"_"+
INVALIDID_BOTH                {DIGIT}+{IDENTIFIER}+"_"+
COMMENT     ##.*\n

%%

function	{ currPos += yyleng; return FUNCTION; }
beginparams	{ currPos += yyleng; return BEGIN_PARAMS; }
endparams	{ currPos += yyleng; return END_PARAMS; }
beginlocals	{ currPos += yyleng; return BEGIN_LOCALS; }
endlocals	{ currPos += yyleng; return END_LOCALS; }
beginbody	{ currPos += yyleng; return BEGIN_BODY; }
endbody		{ currPos += yyleng; return END_BODY; }
integer		{ currPos += yyleng; return INTEGER; }
array		{ currPos += yyleng; return ARRAY; }
of		{ currPos += yyleng; return OF; }
if		{ currPos += yyleng; return IF; }
then		{ currPos += yyleng; return THEN; }
endif		{ currPos += yyleng; return ENDIF; }
else		{ currPos += yyleng; return ELSE; }
while		{ currPos += yyleng; return WHILE; }
do		{ currPos += yyleng; return DO; }
beginloop	{ currPos += yyleng; return BEGINLOOP; }
endloop		{ currPos += yyleng; return ENDLOOP; }
continue	{ currPos += yyleng; return CONTINUE; }
read		{ currPos += yyleng; return READ; }
write		{ currPos += yyleng; return WRITE; }
true		{ currPos += yyleng; return TRUE; }
false		{ currPos += yyleng; return FALSE; }
return		{ currPos += yyleng; return RETURN; }
enum		{ currPos += yyleng; return ENUM; }



"("		{ currPos += yyleng; return L_PAREN; }
")"		{ currPos += yyleng; return R_PAREN; }
"["		{ currPos += yyleng; return L_SQUARE_BRACKET; }
"]"		{ currPos += yyleng; return R_SQUARE_BRACKET; }

";"             { currPos += yyleng; return SEMICOLON; }
":"             { currPos += yyleng; return COLON; }
","             { currPos += yyleng; return COMMA; }

"*"             { currPos += yyleng; return MULT; }
"/"             { currPos += yyleng; return DIV; }
"%"             { currPos += yyleng; return MOD; }
"-"             { currPos += yyleng; return SUB; }
"+"             { currPos += yyleng; return ADD; }

"<"             { currPos += yyleng; return LT; }
"<="            { currPos += yyleng; return LTE; }
">"             { currPos += yyleng; return GT; }
">="            { currPos += yyleng; return GTE; }
"=="            { currPos += yyleng; return EQ; }
"<>"            { currPos += yyleng; return NEQ; }

not             { currPos += yyleng; return NOT; }
and             { currPos += yyleng; return AND; }
or              { currPos += yyleng; return OR; }




":="		{ currPos += yyleng; return ASSIGN; }

{IDENTIFIER}	{ currPos += yyleng; yylval.identVal = strdup(yytext); return IDENTIFIER; }
{DIGIT}+	{ currPos += yyleng; yylval.numVal = atoi(yytext); return NUMBER; }
{INVALIDID_START}    { printf("Error at line %d, column %d: invalid identifier \"%s\" must begin with a letter\n", currLine, currPos, yytext); exit(0);  }
{INVALIDID_ENDSINUNDERSCORE} { printf("Error at line %d, column %d: invalid identifier \"%s\" cannot end with an underscore\n", currLine, currPos, yytext); exit(0); }
{INVALIDID_BOTH}             { printf("Error at line %d, column %d: invalid identifier \"%s\" must begin with a letter and cannot end with an underscore\n", currLine, currPos, yytext); exit(0); }

{COMMENT}   {/*ignore comment*/ currLine++; currPos = 1; }
[ \t]+		{/*ignore whitespace*/ currPos += yyleng;}
"\n"		{currLine++; currPos = 0;}
.		{printf("Error at ... line %d, column %d: unrecognized symbol %d \"%s\"\n", currLine, currPos, atoi(yytext), yytext); exit(0);}

%%

int yyparse();
int yylex();

int main(int argc, char** argv) {
	yyparse();
	return 0;
}

/*int main(int argc, char ** argv) {
    // The input text can be optionally read from an input file
    // (if one was specified on the command line)
    if (argc >= 2) {
        yyin = fopen(argv[1], "r"); // read file
        if (yyin == NULL) yyin = stdin; // if an error occurred, use standard input instead
    } else {
        yyin = stdin;
    }
    yylex(); // this is where the magic happens
    return 0;
}*/
