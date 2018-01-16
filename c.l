%{
	
#include "c.tab.h" 
int lineno=1;
int num_caracteres=1;	
void yyerror(char *s);
%}



%%
"main" {return MAIN;}
"return" {return RETURN;}
"printf" {return PRINTF;}
"if" |
"while" |
"do" |
"for" {return CONDITIONAL;}
";" {return PCOMA;}
"=" |
"<=" |
">=" |
"<" |
">" |
"==" |
"!=" {return COMPARISION;}
"int" |
"double" |
"float" |
"long" |
"void" |
"char" {return DECLARACION;}  
"{" |
"}" |
"(" |
")" |
"[" |
"]" {return DELIMITADORES;}
"+" {return SUMA;}
"-" {return RESTA;}
"*" {return MULTIPLICACION;}
"/" {return DIVISION;} 
"++" {return INCREMENTO;}
"--" {return DECREMENTO;}
\x22 {return COMILLA;}
"," {return COMA;}
"%s" |
"%c" |
"%d" |
"%f" {return VAL;}
[0-9]+ |
[0-9]+". "[0-9]* |
"."[0-9]* { return NUMERO; }
[ \t] ; /* ignore whitespace */
[a-zA-Z_][a-zA-Z_0-9-]* {return NOMBRE;}
\n	lineno++;
. ;
%%

int yywrap() { return 1; }
	
void yyerror(char *s) {
printf ("%d: %s at %s\n", lineno, s, yytext) ;
}
