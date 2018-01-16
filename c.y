%{
/*
* A lexer for the basic gramar to use for recognizing mlish sentences.
*/
#include <stdio.h>	
extern int lineno;
%}

%token MAIN DESCONOCIDO NOMBRE NUMERO PCOMA PRINTF VAL RETURN
%token CONDITIONAL DELIMITADORES COMPARISION COMILLA COMA MAIN
%token DECLARACION OPERACIONES INCREMENTO DECREMENTO SUMA RESTA MULTIPLICACION DIVISION

%%

sentence : input
	| input principal {printf("No hay errores de sintaxis");}
	;
	
input: /* vacío */
| input line
;

line:     '\n'
        | sencondicion
	| declaraciones
	| sencondicion '\n'  
	| declaraciones '\n'
	| operaciones
	| operaciones '\n'
	| imprimir
	| imprimir '\n'
	| retornar
	| retornar '\n'	
	;

	



sencondicion:	condicion delimitador variable comparacion variable delimitador delimitador input delimitador	{if($4=='=')
														{ yyerror("no se permite asignacion"); exit(1);}
														else{if(($2!='(') || ($6!=')')) yyerror("falta parentecis"); exit(1);}}
			|	condicion delimitador variable comparacion numero delimitador delimitador input delimitador
			|	condicion delimitador variable comparacion numero delimitador input											
			|	condicion delimitador variable comparacion variable delimitador input													
			;


declaraciones :	tipo variable comparacion numero pcoma {/*if($5==';')   {yyerror("falta ;");exit(1);}*/}
		   |	tipo variable comparacion variable pcoma {/*if($5==';')  {yyerror("falta ;");exit(1);}*/}
		   |	tipo variable pcoma {if($3!=';') yyerror("falta ;");exit(1);}
		   |	tipo variable delimitador numero delimitador comparacion numero pcoma { if(($3!='[') && ($5!=']')) yyerror("falta '[' o '] '");exit(1);}
		   |	tipo variable delimitador numero delimitador pcoma { if(($3!='[') && ($5!=']')) yyerror("falta '[' o '] '");exit(1);}
		   |	tipo variable comparacion {if($3!='=') yyerror("Solo se permite asignacion");exit(1);}
		   ;	

operaciones :	variable comparacion numero division numero pcoma {/*if($5 == 0){yyerror("no es posible division entre 0"); exit(1);}*/}
		|	variable comparacion variable division variable pcoma
		|	variable comparacion variable division numero pcoma
		|	variable comparacion numero division variable pcoma
		|	variable comparacion numero suma numero pcoma 
		|	variable comparacion variable suma variable pcoma
		|	variable comparacion variable suma numero pcoma 
		|	variable comparacion numero suma variable pcoma 
		|	decremento variable pcoma
		|	variable decremento pcoma
		|	variable incremento pcoma 
		|	incremento variable pcoma
		|	variable comparacion numero multiplicacion numero pcoma
		|	variable comparacion variable multiplicacion variable pcoma
		|	variable comparacion variable multiplicacion numero pcoma
		|	variable comparacion numero multiplicacion variable pcoma
		|	variable comparacion numero resta numero pcoma
		|	variable comparacion variable resta variable pcoma 
		|	variable comparacion variable resta numero pcoma
		|	variable comparacion numero resta variable pcoma
		;
imprimir : printf delimitador comilla variable comilla delimitador pcoma
	   | printf delimitador comilla val variable comilla coma variable delimitador pcoma	
	   | printf delimitador comilla variable val comilla coma variable delimitador pcoma
	   ;
retornar : return variable pcoma
	   | return numero pcoma
	   ;

principal : main delimitador delimitador delimitador input delimitador
	    | main delimitador tipo variable delimitador delimitador input delimitador
	    | tipo main delimitador delimitador delimitador input delimitador
	    | tipo main delimitador tipo variable delimitador delimitador input delimitador
	    | 	tipo main delimitador tipo variable coma tipo variable delimitador delimitador input delimitador
	    ;
main : MAIN
;
		   
tipo	:	DECLARACION
	;
pcoma :	PCOMA
	  ;
suma :    SUMA
	;	   
resta :	 RESTA
		   ;
multiplicacion:  MULTIPLICACION
		   ;
		   
division :		 DIVISION
		   ;
incremento :	 INCREMENTO
		   ;
decremento :  DECREMENTO
;
	;
variable :	NOMBRE
	   ;
numero	:	NUMERO
		;		   
condicion	:	CONDITIONAL
		;
delimitador :	DELIMITADORES		

comparacion :	COMPARISION
			;		   
printf : PRINTF
	;
comilla : COMILLA
	;
coma : COMA
	;
val : VAL
;
return : RETURN
	;	
%%
extern FILE *yyin;

int main(argc,argv)
int argc;
char **argv;
{
char filename[40];
++argv, --argc; /* se salta el nombre del programa */
if (argc>0)
yyin = fopen(argv[0], "r");

else
{
printf("Introduzca el nombre del fichero de entrada: ");
scanf("%s", &filename);
yyin = fopen(filename, "r");
}
yyparse();
	
}

