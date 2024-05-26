%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdbool.h>
extern int yylex(void);
extern FILE *yyin;
extern int yylineno;
extern char* yytext;
void yyerror(const char *s);
extern int colum;
extern char *lineptr;
%}

%union {
 char *idval;
}

%token<idval> VINT DEC VCHA STR LTI VOI IFF ELS LON RET SHO FOR DOU INT CHA INC SCA COU CIN  ASS PLS AST MIN SLS MTQ MET GTQ GEQ EQL NQL OPP CPP OCB CCB OBK CBK SMC COM IDE WHI MMN MMQ PPP MMM

%define parse.error verbose

%%

sentencias 	:
		| sentencias sentencia {printf("Compilación exitosa!!!!\n");}


sentencia 	: decvar
		| cond
		| initvar
		| asigvar 
		| ifsim
		| ifelse
		| libraries
		| while
		| scanf
		| cout
		| cin
		| for

ifsim 		: IFF OPP cond CPP OCB CCB

ifelse		: IFF OPP cond CPP OCB CCB ELS OCB CCB 

libraries	: INC LTI

while		: WHI OPP cond CPP OCB CCB

scanf		: SCA OPP STR COM IDE CPP SMC

cout		: COU MMN STR SMC
      		| COU MMN IDE SMC


for 		: FOR OPP INT IDE ASS VINT SMC IDE MTQ IDE SMC IDE PPP CPP OCB CCB
 		| FOR OPP INT IDE ASS VINT SMC IDE GTQ IDE SMC IDE PPP CPP OCB CCB
 		| FOR OPP INT IDE ASS VINT SMC IDE MET IDE SMC IDE PPP CPP OCB CCB
 		| FOR OPP INT IDE ASS VINT SMC IDE GEQ IDE SMC IDE PPP CPP OCB CCB
		| FOR OPP INT IDE ASS VINT SMC IDE MTQ IDE SMC IDE MMM CPP OCB CCB
                | FOR OPP INT IDE ASS VINT SMC IDE GTQ IDE SMC IDE MMM CPP OCB CCB
                | FOR OPP INT IDE ASS VINT SMC IDE MET IDE SMC IDE MMM CPP OCB CCB
                | FOR OPP INT IDE ASS VINT SMC IDE GEQ IDE SMC IDE MMM CPP OCB CCB


cin		: CIN MMQ IDE SMC

cond 		: IDE ASS IDE 
       		| IDE MTQ IDE 
       		| IDE MET IDE 
       		| IDE GTQ IDE 
       		| IDE GEQ IDE 
       		| IDE EQL IDE 
       		| IDE NQL IDE 
		| VINT EQL VINT
		| VINT GTQ VINT
		| VINT GEQ VINT
		| DEC EQL DEC
		| DEC GTQ DEC
		| DEC GEQ DEC


decvar 		: INT IDE SMC
	 	| CHA IDE SMC
	 	| DOU IDE SMC    
	 	| LON IDE SMC
		| SHO IDE SMC
	 	| CHA IDE OBK CBK SMC
	 	| CHA IDE OBK VINT CBK SMC

initvar		: INT IDE ASS VINT SMC
	 	| CHA IDE ASS VCHA SMC
		| DOU IDE ASS DEC SMC 
		| CHA IDE OBK CBK ASS STR SMC
		| CHA IDE OBK VINT CBK ASS STR SMC
		| LON IDE ASS VINT SMC
		| SHO IDE ASS DEC SMC
		| INT IDE ASS IDE SMC
		| CHA IDE ASS IDE SMC
		| DOU IDE ASS IDE SMC
		| CHA IDE OBK CBK ASS IDE SMC
		| CHA IDE OBK VINT CBK IDE SMC		
		| LON IDE ASS IDE SMC
		| SHO IDE ASS IDE SMC


asigvar 	: IDE ASS VINT SMC
	 	| IDE ASS VCHA SMC
		| IDE ASS DEC SMC
		| IDE ASS STR SMC

%%

int contarPalabras(const char* cadena) {
    int contador = 0;
    int esPalabra = 0;
    while (*cadena) {
        if (*cadena == ' ' || *cadena == '\n') {
            esPalabra = 0; 
        }
        else if (!esPalabra) {
            esPalabra = 1;
            contador++;
        }
        cadena++;
    }

    return contador;
}


bool isNumber(const char* string) {
	int length = strlen(string);
    	for (int i = 0; i < length; i++) {
        	if (!isdigit(string[i])) {
            		return false;
        	}
	    }
    	return true;
}

bool isCharacter(const char* string) {
	int length = strlen(string);
    	if (length == 3 && string[0] == '\'' && string[2] == '\'') {
        	return true;
    	}
    	return false;
}

bool isString(const char* string) {
	int length = strlen(string);
   	 if (length >= 2 && string[0] == '"' && string[length - 1] == '"') {
        	return true;
    	}
    	return false;
}

bool isDecimal(const char* string) {
	int length = strlen(string);
  	bool puntoEncontrado = false;
    	for (int i = 0; i < length; i++) {
       		if (!isdigit(string[i])) {
           		if (string[i] == '.' && !puntoEncontrado) {
                		puntoEncontrado = true;
            		} else {
                		return false;
            		}
        	}
    	}
    	return puntoEncontrado;
}

void getElements(char string[], char* elementList[], int* counter){
	char* delimiter = " ";
	char* token = strtok(string, delimiter);
	while(token != NULL && *counter < 15){
		elementList[*counter] = token;
		(*counter)++;
		token = strtok(NULL, delimiter);
	}

	if (*counter ==30 && token != NULL) {
		printf("Error: Se superó el número de elementos en una línea\n");
	}
	
}

int validarExpresion(const char *cadena) {
    int i = 0;
    char c;

    while ((c = cadena[i]) != '\0') {
        if (!isalnum(c)) {
            return 0;  
        }
        i++;
    }

    return 1;  
}

void structureIf(char* ifSentence[]){
	if (strcmp(ifSentence[1], "(")!=0) {
		printf ("La cadena %s no pertenece a la estructura del if", ifSentence[1]);
		printf ("\nHace falta el paréntesis de apertura para identificar donde empieza la condición.\n");
	} else if(!validarExpresion(ifSentence[2])){
                printf("No se está escribiendo correctamente el identificador de la variable, o no es del mismo tipo.\n");
                printf("Recuerde que los identificadores de variables pueden contener únicamente letras mayúsculas, minúsculas o números\n");
        } else if((strcmp(ifSentence[3], "<") != 0) && (strcmp(ifSentence[3], ">") != 0) && (strcmp(ifSentence[3], "<=") != 0) && (strcmp(ifSentence[3], ">=") != 0) && (strcmp(ifSentence[3], "==")!=0) && (strcmp(ifSentence[3], "!=")!=0) ){
                printf("Hace falta un operador que indica la condición.\n");
                printf("Recuerda que los operadores más utilizados para las condiciones son '<','>','<=','>=','==','!='.\n");
        } else if(!validarExpresion(ifSentence[4])){
                printf("No se está escribiendo correctamente el identificador de la variable, o no es del mismo tipo.\n");
                printf("Recuerde que los identificadores de variables pueden contener únicamente letras mayúsculas, minúsculas o números\n");
	} else if (strcmp (ifSentence[5], ")")!=0) {
		printf ("La cadena %s no pertenece a la estructura del if", ifSentence[5]);
		printf ("\nHace falta el paréntesis de cierre para identificar donde finaliza la condición.\n");
	} else if (strcmp (ifSentence[6], "{")!=0) {
                printf ("La cadena %s no pertenece a la estructura del if", ifSentence[6]);
                printf ("\nHace falta el corcherte de apertura para identificar las sentencias. \n");
      	}
	printf("La estructura del if es:if ( condición ) {\n}\n"); 
}

void structureWhile(char* whileSentence[]){
        if (strcmp(whileSentence[1], "(")!=0) {
                printf ("La cadena %s no pertenece a la estructura del while", whileSentence[1]);
                printf ("\nHace falta el paréntesis de apertura para identificar donde empieza la condición.\n");
        } else if (!validarExpresion(whileSentence[2])) {
                printf("No se está escribiendo correctamente el identificador de la variable, o no es del mismo tipo.\n");
                printf("Recuerde que los identificadores de variables pueden contener únicamente letras mayúsculas, minúsculas o números\n");
        } else if((strcmp(whileSentence[3], "<") != 0) && (strcmp(whileSentence[3], ">") != 0) && (strcmp(whileSentence[3], "<=") != 0) && (strcmp(whileSentence[3], ">=") != 0) && (strcmp(whileSentence[3], "==")!=0) && (strcmp(whileSentence[3], "!=")!=0) ){
                printf("Hace falta un operador que indica la condición.\n");
                printf("Recuerda que los operadores más utilizados para las condiciones son '<','>','<=','>=','==','!='.\n");
        } else if (!validarExpresion(whileSentence[4])){
                printf("No se está escribiendo correctamente el identificador de la variable, o no es del mismo tipo.\n");
                printf("Recuerde que los identificadores de variables pueden contener únicamente letras mayúsculas, minúsculas o números\n");
	} else if (strcmp (whileSentence[5], ")")!=0) {
                printf ("La cadena %s no pertenece a la estructura del while", whileSentence[5]);
                printf ("\nHace falta el paréntesis de cierre para identificar donde finaliza la condición.\n");
        } else if (strcmp (whileSentence[6], "{")!=0) {
                printf ("La cadena %s no pertenece a la estructura del while", whileSentence[6]);
                printf ("\nHace falta el corcherte de apertura para identificar las sentencias. \n");
        }
        printf("Recuerde que la condición debe tener el mismo tipo de dato. La estructura del while es: while ( condición ) {\n}\n");
}


void structureIfElse(char* ifSentence[]){
        if (strcmp(ifSentence[1], "(")!=0) {
                printf ("La cadena %s no pertenece a la estructura del if", ifSentence[1]);
                printf ("\nHace falta el paréntesis de apertura para identificar donde empieza la condición.\n");
        } else if(!validarExpresion(ifSentence[2])){
                printf("No se está escribiendo correctamente el identificador de la variable, o no es del mismo tipo.\n");
                printf("Recuerde que los identificadores de variables pueden contener únicamente letras mayúsculas, minúsculas o números\n");
        } else if((strcmp(ifSentence[3], "<") != 0) && (strcmp(ifSentence[3], ">") != 0) && (strcmp(ifSentence[3], "<=") != 0) && (strcmp(ifSentence[3], ">=") != 0) && (strcmp(ifSentence[3], "==")!=0) && (strcmp(ifSentence[3], "!=")!=0) ){
                printf("Hace falta un operador que indica la condición.\n");
                printf("Recuerda que los operadores más utilizados para las condiciones son '<','>','<=','>=','==','!='.\n");
        } else if(!validarExpresion(ifSentence[4])){
                printf("No se está escribiendo correctamente el identificador de la variable, o no es del mismo tipo.\n");
                printf("Recuerde que los identificadores de variables pueden contener únicamente letras mayúsculas, minúsculas o números\n");
 
	} else if (strcmp (ifSentence[5], ")")!=0) {
                printf ("La cadena %s no pertenece a la estructura del if", ifSentence[5]);
                printf ("\nHace falta el paréntesis de cierre para identificar donde finaliza la condición.\n");
        } else if (strcmp (ifSentence[6], "{")!=0) {
                printf ("La cadena %s no pertenece a la estructura del if", ifSentence[6]);
                printf ("\nHace falta el corchete de apertura para identificar las sentencias del if. \n");
        } else if (strcmp (ifSentence[7], "}")!=0) {
		printf ("La cadena %s no pertenece a la estructura del if", ifSentence[7]);
                printf ("\nHace falta el corchete de cierre para identificar las sentencias del if. \n");
	} else if (strcmp (ifSentence[8], "else")!=0) {
                printf ("La cadena %s no pertenece a la estructura del if", ifSentence[8]);
                printf ("\nHace falta la palabra else o está mal escrita. \n");
        } else if (strcmp (ifSentence[9], "{")!=0) {
                printf ("La cadena %s no pertenece a la estructura del if", ifSentence[9]);
                printf ("\nHace falta el corchete de apertura para identificar las sentencias del else. \n");
        } else if (strcmp (ifSentence[10], "}")!=0) {
                printf ("La cadena %s no pertenece a la estructura del if", ifSentence[10]);
                printf ("\nHace falta el corchete de cierre para identificar las sentencias del else. \n");
	}
}

void structureScanf(char* scanfSentence[]) {
	if (strcmp(scanfSentence[1], "(")!=0) {
		printf ("Hace falta el símbolo '(' de apertura.\n");
	} else if (!isString(scanfSentence[2])) {
		printf ("No está escribiendo el valor string, o no se está escribiendo correctamente.\n");
	} else if (strcmp(scanfSentence[3], ",")!=0) {
		printf ("No se encuentra el símbolo ','.\n");
	} else if (!validarExpresion(scanfSentence[4])) {
		printf ("No se está escribiendo o se está escribiendo incorrectamente el identificador.\n");
	} else if (strcmp(scanfSentence[5], ")")!=0) {
		printf ("Hace falta el símbolo ')' de cierre.\n");
	}
}

void structureCout(char* coutSentence[]) {
	if (strcmp(coutSentence[1], "<<")!=0) {
		printf ("Hace falta el símbolo '<<' el cuál da paso al mensaje que se desea mostrar por pantalla.\n");
	} else if(!isString(coutSentence[2])) {
		if (!validarExpresion(coutSentence[2])) {
			printf ("No se está escribiendo o no se encuentra un identificador de variable, recuerde que puede contener mayúsculas, minúsculas y números.\n");
		} else {
			printf ("No se está escribiendo o no se encuentra el mensaje, recuerde que debe ir dentro de comillas.\n");
		}
	} else if (strcmp(coutSentence[3], ";")!=0) {
                printf ("Hace falta el símbolo ';' que indica el final de la línea de cout.\n");
        }
}

void structureCin(char* cinSentence[]) {
        if (strcmp(cinSentence[1], ">>")!=0) {
                printf ("Hace falta el símbolo '>>' el cuál da paso a la variable que se desea leer.\n");
        } else if(!validarExpresion(cinSentence[2])) {
        	printf ("No se está escribiendo o no se encuentra un identificador de variable, recuerde que puede contener mayúsculas, minúsculas y números, sin espacios.\n");
        } else if (strcmp(cinSentence[3], ";")!=0) {
		printf ("Hace falta el símbolo ';' que indica el final de la línea de cin.\n");
	}
}


void structureAss(char* assSentence[]){
        if (strcmp(assSentence[1], "=")!=0) {
                printf ("La cadena %s no pertenece a la estructura de asignación o no se encuentra en el orden correcto.", assSentence[1]);
                printf ("\nHace falta el símbolo '=' que hace referencia a lo que se va asignar.\n");
        } else if (!isNumber(assSentence[2]) || !isCharacter(assSentence[2]) || !isString(assSentence[2]) || !isDecimal(assSentence[2])){
                printf ("La cadena %s no pertenece a la estructura de asignación o no se encuentra en el orden correcto.", assSentence[2]);
                printf ("\nNo se está escribiendo correctamente el parámetro a asignar.\n");
        } else if (strcmp (assSentence[3], ";")!=0) {
                printf ("La cadena %s no pertenece a la estructura de asignación o no se encuentra en el orden correcto.", assSentence[3]);
                printf ("\nHace falta el punto y coma ';'.\n");
	}
}

void structureDecVar(char* decSentence[]){
        if (!validarExpresion(decSentence[1])) {
                printf ("La cadena %s no pertenece a la estructura de declaración de variable o no se encuentra en el orden correcto.", decSentence[1]);
                printf ("\nNo se está escribiendo correctamente el identificador de la variable.\n");
	} else if (strcmp (decSentence[2], ";")!=0) {
                printf ("La cadena %s no pertenece a la estructura de declaración o no se encuentra en el orden correcto.", decSentence[2]);
                printf ("\nHace falta el punto y coma ';'.\n");
        }
}

void structureFor(char* forSentence[]){
	if(strcmp(forSentence[1], "(") != 0){
		printf("Hace falta el símbolo '(' de apertura.\n");
	} else if(strcmp(forSentence[2], "int") != 0){
		printf("Hace falta inicializar la variable para recorrer el ciclo.\n");
	} else if(!validarExpresion(forSentence[3])){
		printf("No se está escribiendo correctamente el identificador de la variable.\n");
		printf("Recuerde que los identificadores de variables pueden contener únicamente letras mayúsculas, minúsculas o números\n");
	} else if(strcmp(forSentence[4], "=") != 0){
		printf("Hace falta el símbolo '=' que hace referencia a lo que se va asignar.\n");
	} else if(!isNumber(forSentence[5])){
		printf("El valor a asignar no es un número entero.\n");
	} else if(strcmp(forSentence[6], ";") != 0){
		printf("Hace falta el símbolo ';' para terminar la primera parte de la estructura de la expresión 'for'.\n");
	} else if(!validarExpresion(forSentence[7])){
		printf("No se está escribiendo correctamente el identificador de la variable.\n");
		printf("Recuerde que los identificadores de variables pueden contener únicamente letras mayúsculas, minúsculas o números\n");
	} else if((strcmp(forSentence[8], "<") != 0) && (strcmp(forSentence[8], ">") != 0) && (strcmp(forSentence[8], "<=") != 0) && (strcmp(forSentence[8], ">=") != 0)){
		printf("Hace falta un operador que permita que el ciclo se siga ejecutando.\n");
		printf("Recuerda que los operadores más utilizados para las estructuras de control son '<','>','<=','>='.\n");
	} else if(!validarExpresion(forSentence[9])){
		printf("No se está escribiendo correctamente el identificador de la variable.\n");
		printf("Recuerde que los identificadores de variables pueden contener únicamente letras mayúsculas, minúsculas o números\n");
	} else if(strcmp(forSentence[10], ";") != 0){
		printf("Hace falta el símbolo ';' para terminar la segunda parte de la estructura de la expresión 'for'.\n");
	} else if(!validarExpresion(forSentence[11])){
		printf("No se está escribiendo correctamente el identificador de la variable.\n");
		printf("Recuerde que los identificadores de variables pueden contener únicamente letras mayúsculas, minúsculas o números\n");
	} else if((strcmp(forSentence[12], "++") != 0) && (strcmp(forSentence[12], "--") != 0)){
		printf("Hace falta un operador que permita actualizar el valor de la variable.\n");
		printf("Recuerda que los operadores más utilizados para alterar el valor de una variable son '++', '--'.\n");
	} else if(strcmp(forSentence[13], ")") != 0){
		printf("Hace falta el símbolo ')' para cerrar la estructura del 'for'.\n");
	} else if (strcmp (forSentence[14], "{")!=0) {
                printf ("La cadena %s no pertenece a la estructura del for", forSentence[14]);
                printf ("\nHace falta el corchete de apertura para identificar las sentencias del for. \n");
        } else if (strcmp (forSentence[15], "}")!=0) {
                printf ("La cadena %s no pertenece a la estructura del for", forSentence[15]);
                printf ("\nHace falta el corchete de cierre para identificar las sentencias del for. \n");
        }
	printf ("Recuerde que la estructura del for es la siguiente: \n");
	printf ("for ( int a = 0 ; a < var ; i ++ ) { } \n"); 
}

void structureInitVar(char* decSentence[]) {
if (validarExpresion(decSentence[1])) {
        if (contarPalabras(lineptr)<=5) {
            if (strcmp(decSentence[2], "=")!=0) {
                printf ("La cadena %s no pertenece a la estructura de inicialización o no se encuentra en el orden correcto.", decSentence[2]);
                printf ("\nHace falta el símbolo '=' que hace referencia a lo que se va asignar.\n");
            } else if (!isString(decSentence[3])) {
                printf ("La cadena %s no pertenece a la estructura de inicialización o no se encuentra en el orden correcto.", decSentence[3]);
                printf ("\nNo se está escribiendo correctamente el parámetro a asignar.\n");
            } else if (strcmp(decSentence[4], ";")!=0) {
                printf ("La cadena %s no pertenece a la estructura de inicialización o no se encuentra en el orden correcto.", decSentence[4]);
                printf ("\nHace falta el punto y coma ';'.\n");
            }
        } else if ((contarPalabras(lineptr)>5) && (contarPalabras(lineptr)<=7)) {
		if (strcmp(decSentence[2], "[")!=0) {
                	printf ("La cadena %s no pertenece a la estructura de inicialización o no se encuentra en el orden correcto.", decSentence[2]);
                	printf ("\nHace falta el símbolo '[' que referencia la llave de inicio del arreglo de strings.\n");
            	} else if (strcmp(decSentence[3], "]")!=0) {
                	printf ("La cadena %s no pertenece a la estructura de inicialización o no se encuentra en el orden correcto.", decSentence[3]);
                	printf ("\nHace falta el símbolo ']' que referencia la llave de cierre del arreglo de strings.\n");
            	} else if (strcmp(decSentence[4], "=")!=0) {
                	printf ("La cadena %s no pertenece a la estructura de inicialización o no se encuentra en el orden correcto.", decSentence[4]);
                	printf ("\nHace falta el símbolo '=' que hace referencia a lo que se va asignar.\n");
            	} else if (!isString(decSentence[5])) {
               		printf ("La cadena %s no pertenece a la estructura de inicialización o no se encuentra en el orden correcto.", decSentence[5]);
                	printf ("\nNo se está escribiendo correctamente el parámetro a asignar.\n");
            	} else if (strcmp(decSentence[6], ";")!=0) {
                	printf ("La cadena %s no pertenece a la estructura de inicialización o no se encuentra en el orden correcto.", decSentence[6]);
                	printf ("\nHace falta el punto y coma ';'.\n");
	}
} else {
       printf ("La cadena %s no pertenece a la estructura de declaración de variable o no se encuentra en el orden correcto.", decSentence[1]);
       printf ("\nNo se está escribiendo correctamente el identificador de la variable.\n");
    }
}
}

void structureLibrarie (char* decSentence[]) {
	printf("Se está escribiendo incorrectamente el valor de la líbreria, deber ser <nombre.h>.\n");
}


void identifyStructure(char* elementList[]) {
	if (strcmp(elementList[0], "if")==0) {
		if (contarPalabras(lineptr)<=8) {
			structureIf(elementList);
		} else {
			structureIfElse(elementList);
		}
	} else if ((strcmp(elementList[0], "int")==0) || (strcmp(elementList[0], "char")==0) || (strcmp(elementList[0], "double")==0) || (strcmp(elementList[0], "long")==0) || (strcmp(elementList[0], "short")==0)){
		if (contarPalabras(lineptr) <= 3) {
			structureDecVar(elementList);
		} else {
			structureInitVar(elementList);
		}
	} else if (strcmp(elementList[0], "#include")==0) {
		structureLibrarie(elementList);
	} else if (strcmp(elementList[0], "while")==0) {
		structureWhile(elementList);
	} else if (strcmp(elementList[0], "scanf")==0) {
		structureScanf(elementList);
	} else if (strcmp (elementList[0], "cout")==0) {
		structureCout(elementList);
	} else if (strcmp (elementList[0], "cin")==0) {
                structureCin(elementList); 
	} else if (strcmp (elementList[0], "for")==0) { 
		structureFor(elementList);
	} else if (validarExpresion(elementList[0])) {   
		structureAss(elementList);	
	}
}		


void yyerror(const char *s) {
	char s2[contarPalabras(lineptr)];
	strcpy(s2, lineptr); 
	char* elementList[30];
	int counter = 0;
	getElements(s2, elementList, &counter);
	printf("Error sintáctico en la línea %d columna %d: el carácter: %s no se esperaba en esta posición.\n", yylineno,colum, yytext); 
	fprintf(stderr,"%s", lineptr);
	for(int i = 0; i < colum - 1; i++)
        	fprintf(stderr,"_");
	fprintf(stderr,"^\n");       
	identifyStructure(elementList);
}




int main(int argc, char **argv){
        if(argc > 1)
                yyin=fopen(argv[1], "rt");
        else
                yyin=stdin;

        yyparse();
	free(lineptr);
        return 0;
}