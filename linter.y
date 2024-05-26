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
		| sentencias sentencia {printf("El código cumple con las reglas gramaticales: ha compilado!\n");}


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
		printf("Error: Se superó el número máximo de elementos permitidos en una línea.\n");
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
		printf ("El símbolo %s no pertenece a la estructura del if.\n", ifSentence[1]);
		printf ("Se esperaba un paréntesis de apertura '(' para iniciar la condición del if.\n");
	} else if(!validarExpresion(ifSentence[2])){
                printf("El identificador %s no es válido o no coincide con el tipo esperado.\n", ifSentence[2]);
                printf("Recuerde que los identificadores deben contener solo letras y números.\n");
        } else if((strcmp(ifSentence[3], "<") != 0) && (strcmp(ifSentence[3], ">") != 0) && (strcmp(ifSentence[3], "<=") != 0) && (strcmp(ifSentence[3], ">=") != 0) && (strcmp(ifSentence[3], "==")!=0) && (strcmp(ifSentence[3], "!=")!=0) ){
                printf("Falta un operador relacional válido para la condición del if.\n");
                printf("Los operadores relacionales permitidos son: '<', '>', '<=', '>=', '==', '!='.\n");
        } else if(!validarExpresion(ifSentence[4])){
                printf("El identificador %s no es válido o no coincide con el tipo esperado.\n", ifSentence[4]);
                printf("Recuerde que los identificadores deben contener solo letras y números.\n");
	} else if (strcmp (ifSentence[5], ")")!=0) {
		printf ("El símbolo %s no pertenece a la estructura del if.\n", ifSentence[5]);
		printf ("Se esperaba un paréntesis de cierre ')' para finalizar la condición del if.\n");
	} else if (strcmp (ifSentence[6], "{")!=0) {
                printf ("El símbolo %s no pertenece a la estructura del if.\n", ifSentence[6]);
                printf ("Se esperaba una llave de apertura '{' para iniciar el bloque de código del if.\n");
      	}
	printf("Recuerde que la estructura correcta del if es: if ( condición ) { ... }\n"); 
}

void structureWhile(char* whileSentence[]){
        if (strcmp(whileSentence[1], "(")!=0) {
                printf ("El símbolo %s no pertenece a la estructura del while.\n", whileSentence[1]);
                printf ("Se esperaba un paréntesis de apertura '(' para iniciar la condición del while.\n");
        } else if (!validarExpresion(whileSentence[2])) {
                printf("El identificador %s no es válido o no coincide con el tipo esperado.\n", whileSentence[2]);
                printf("Recuerde que los identificadores deben contener solo letras y números.\n");
        } else if((strcmp(whileSentence[3], "<") != 0) && (strcmp(whileSentence[3], ">") != 0) && (strcmp(whileSentence[3], "<=") != 0) && (strcmp(whileSentence[3], ">=") != 0) && (strcmp(whileSentence[3], "==")!=0) && (strcmp(whileSentence[3], "!=")!=0) ){
                printf("Falta un operador relacional válido para la condición del while.\n");
                printf("Los operadores relacionales permitidos son: '<', '>', '<=', '>=', '==', '!='.\n");
        } else if (!validarExpresion(whileSentence[4])){
                printf("El identificador %s no es válido o no coincide con el tipo esperado.\n", whileSentence[4]);
                printf("Recuerde que los identificadores deben contener solo letras y números.\n");
	} else if (strcmp (whileSentence[5], ")")!=0) {
                printf ("El símbolo %s no pertenece a la estructura del while.\n", whileSentence[5]);
                printf ("Se esperaba un paréntesis de cierre ')' para finalizar la condición del while.\n");
        } else if (strcmp (whileSentence[6], "{")!=0) {
                printf ("El símbolo %s no pertenece a la estructura del while.\n", whileSentence[6]);
                printf ("Se esperaba una llave de apertura '{' para iniciar el bloque de código del while.\n");
        }
        printf("Recuerde que la condición del while debe comparar elementos del mismo tipo.\n");
        printf("La estructura correcta del while es: while ( condición ) { ... }\n");
}


void structureIfElse(char* ifSentence[]){
        if (strcmp(ifSentence[1], "(")!=0) {
                printf ("El símbolo %s no pertenece a la estructura del if-else.\n", ifSentence[1]);
                printf ("Se esperaba un paréntesis de apertura '(' para iniciar la condición del if.\n");
        } else if(!validarExpresion(ifSentence[2])){
                printf("El identificador %s no es válido o no coincide con el tipo esperado.\n", ifSentence[2]);
                printf("Recuerde que los identificadores deben contener solo letras y números.\n");
        } else if((strcmp(ifSentence[3], "<") != 0) && (strcmp(ifSentence[3], ">") != 0) && (strcmp(ifSentence[3], "<=") != 0) && (strcmp(ifSentence[3], ">=") != 0) && (strcmp(ifSentence[3], "==")!=0) && (strcmp(ifSentence[3], "!=")!=0) ){
                printf("Falta un operador relacional válido para la condición del if.\n");
                printf("Los operadores relacionales permitidos son: '<', '>', '<=', '>=', '==', '!='.\n");
        } else if(!validarExpresion(ifSentence[4])){
                printf("El identificador %s no es válido o no coincide con el tipo esperado.\n", ifSentence[4]);
                printf("Recuerde que los identificadores deben contener solo letras y números.\n");
 
	} else if (strcmp (ifSentence[5], ")")!=0) {
                printf ("El símbolo %s no pertenece a la estructura del if-else.\n", ifSentence[5]);
                printf ("Se esperaba un paréntesis de cierre ')' para finalizar la condición del if.\n");
        } else if (strcmp (ifSentence[6], "{")!=0) {
                printf ("El símbolo %s no pertenece a la estructura del if-else.\n", ifSentence[6]);
                printf ("Se esperaba una llave de apertura '{' para iniciar el bloque de código del if.\n");
        } else if (strcmp (ifSentence[7], "}")!=0) {
		printf ("El símbolo %s no pertenece a la estructura del if-else.\n", ifSentence[7]);
                printf ("Se esperaba una llave de cierre '}' para finalizar el bloque de código del if.\n");
	} else if (strcmp (ifSentence[8], "else")!=0) {
                printf ("La palabra clave %s no se encuentra o está mal escrita.\n", ifSentence[8]);
                printf ("Se esperaba la palabra clave 'else' para indicar el bloque alternativo.\n");
        } else if (strcmp (ifSentence[9], "{")!=0) {
                printf ("El símbolo %s no pertenece a la estructura del if-else.\n", ifSentence[9]);
                printf ("Se esperaba una llave de apertura '{' para iniciar el bloque de código del else.\n");
        } else if (strcmp (ifSentence[10], "}")!=0) {
                printf ("El símbolo %s no pertenece a la estructura del if-else.\n", ifSentence[10]);
                printf ("Se esperaba una llave de cierre '}' para finalizar el bloque de código del else.\n");
	}
        printf("Recuerde que la estructura correcta del if-else es:\n");
        printf("if ( condición ) { ... } else { ... }\n");
}

void structureScanf(char* scanfSentence[]) {
	if (strcmp(scanfSentence[1], "(")!=0) {
		printf ("Falta el paréntesis de apertura '(' después de la función scanf.\n");
	} else if (!isString(scanfSentence[2])) {
		printf ("El segundo argumento de scanf debe ser una cadena de formato válida.\n");
		printf ("Asegúrese de que la cadena esté entre comillas dobles \"...\".\n");
	} else if (strcmp(scanfSentence[3], ",")!=0) {
		printf ("Falta la coma ',' para separar los argumentos de scanf.\n");
	} else if (!validarExpresion(scanfSentence[4])) {
		printf ("El identificador %s no es válido para almacenar el valor leído por scanf.\n", scanfSentence[4]);
		printf ("Los identificadores deben contener solo letras y números.\n");
	} else if (strcmp(scanfSentence[5], ")")!=0) {
		printf ("Falta el paréntesis de cierre ')' para finalizar la función scanf.\n");
	}
        printf("Recuerde que la estructura correcta de scanf es:\n");
        printf("scanf(\"formato\", &variable);\n");
}

void structureCout(char* coutSentence[]) {
	if (strcmp(coutSentence[1], "<<")!=0) {
		printf ("Falta el operador de inserción '<<' después de cout.\n");
	} else if(!isString(coutSentence[2])) {
		if (!validarExpresion(coutSentence[2])) {
			printf ("El elemento a imprimir no es un identificador válido.\n");
			printf ("Los identificadores deben contener solo letras y números.\n");
		} else {
			printf ("El elemento a imprimir debe ser una cadena entre comillas dobles \"...\" o un identificador válido.\n");
		}
	} else if (strcmp(coutSentence[3], ";")!=0) {
                printf ("Falta el punto y coma ';' al final de la sentencia cout.\n");
        }
        printf("Recuerde que la estructura correcta de cout es:\n");
        printf("cout << \"mensaje\" << variable << ...;\n");
}

void structureCin(char* cinSentence[]) {
        if (strcmp(cinSentence[1], ">>")!=0) {
                printf ("Falta el operador de extracción '>>' después de cin.\n");
        } else if(!validarExpresion(cinSentence[2])) {
        	printf ("El identificador %s no es válido para almacenar el valor leído por cin.\n", cinSentence[2]);
                printf ("Los identificadores deben contener solo letras y números, sin espacios.\n");
        } else if (strcmp(cinSentence[3], ";")!=0) {
		printf ("Falta el punto y coma ';' al final de la sentencia cin.\n");
	}
        printf("Recuerde que la estructura correcta de cin es:\n");
        printf("cin >> variable;\n");
}


void structureAss(char* assSentence[]){
        if (strcmp(assSentence[1], "=")!=0) {
                printf ("Falta el operador de asignación '='.\n");
        } else if (!isNumber(assSentence[2]) && !isCharacter(assSentence[2]) && !isString(assSentence[2]) && !isDecimal(assSentence[2])){
                printf ("El valor a asignar no es válido.\n");
                printf ("Debe ser un número entero, un carácter, una cadena o un número decimal.\n");
        } else if (strcmp (assSentence[3], ";")!=0) {
                printf ("Falta el punto y coma ';' al final de la sentencia de asignación.\n");
	}
        printf("Recuerde que la estructura correcta de una asignación es:\n");
        printf("variable = valor;\n");
}

void structureDecVar(char* decSentence[]){
        if (!validarExpresion(decSentence[1])) {
                printf ("El identificador %s no es válido para declarar una variable.\n", decSentence[1]);
                printf ("Los identificadores deben contener solo letras y números.\n");
	} else if (strcmp (decSentence[2], ";")!=0) {
                printf ("Falta el punto y coma ';' al final de la declaración de variable.\n");
        }
        printf("Recuerde que la estructura correcta para declarar una variable es:\n");
        printf("tipo identificador;\n");
}

void structureFor(char* forSentence[]){
	if(strcmp(forSentence[1], "(") != 0){
		printf("Falta el paréntesis de apertura '(' después de la palabra clave 'for'.\n");
	} else if(strcmp(forSentence[2], "int") != 0){
		printf("Debe inicializar una variable de control de tipo 'int' para el bucle for.\n");
	} else if(!validarExpresion(forSentence[3])){
		printf("El identificador %s no es válido para la variable de control del bucle for.\n", forSentence[3]);
		printf("Los identificadores deben contener solo letras y números.\n");
	} else if(strcmp(forSentence[4], "=") != 0){
		printf("Falta el operador de asignación '=' para inicializar la variable de control.\n");
	} else if(!isNumber(forSentence[5])){
		printf("El valor de inicialización de la variable de control debe ser un número entero.\n");
	} else if(strcmp(forSentence[6], ";") != 0){
		printf("Falta el punto y coma ';' después de la inicialización de la variable de control.\n");
	} else if(!validarExpresion(forSentence[7])){
		printf("El identificador %s no es válido para la condición del bucle for.\n", forSentence[7]);
		printf("Los identificadores deben contener solo letras y números.\n");
	} else if((strcmp(forSentence[8], "<") != 0) && (strcmp(forSentence[8], ">") != 0) && (strcmp(forSentence[8], "<=") != 0) && (strcmp(forSentence[8], ">=") != 0)){
		printf("Falta un operador relacional válido para la condición del bucle for.\n");
		printf("Los operadores relacionales permitidos son: '<', '>', '<=', '>='.\n");
	} else if(!validarExpresion(forSentence[9])){
		printf("El identificador %s no es válido para la condición del bucle for.\n", forSentence[9]);
		printf("Los identificadores deben contener solo letras y números.\n");
	} else if(strcmp(forSentence[10], ";") != 0){
		printf("Falta el punto y coma ';' después de la condición del bucle for.\n");
	} else if(!validarExpresion(forSentence[11])){
		printf("El identificador %s no es válido para la expresión de incremento del bucle for.\n", forSentence[11]);
		printf("Los identificadores deben contener solo letras y números.\n");
	} else if((strcmp(forSentence[12], "++") != 0) && (strcmp(forSentence[12], "--") != 0)){
		printf("Falta un operador de incremento válido para la variable de control del bucle for.\n");
		printf("Los operadores de incremento permitidos son: '++', '--'.\n");
	} else if(strcmp(forSentence[13], ")") != 0){
		printf("Falta el paréntesis de cierre ')' después de la expresión de incremento del bucle for.\n");
	} else if (strcmp (forSentence[14], "{")!=0) {
                printf ("Falta la llave de apertura '{' para iniciar el bloque de código del bucle for.\n");
        } else if (strcmp (forSentence[15], "}")!=0) {
                printf ("Falta la llave de cierre '}' para finalizar el bloque de código del bucle for.\n");
        }
	printf ("Recuerde que la estructura correcta del bucle for es: \n");
	printf ("for (int variable = valor; variable < limite; variable++) { ... }\n"); 
}

void structureInitVar(char* decSentence[]) {
if (validarExpresion(decSentence[1])) {
        if (contarPalabras(lineptr)<=5) {
            if (strcmp(decSentence[2], "=")!=0) {
                printf ("Falta el operador de asignación '=' para inicializar la variable.\n");
            } else if (!isString(decSentence[3])) {
                printf ("El valor de inicialización debe ser una cadena entre comillas dobles \"...\".\n");
            } else if (strcmp(decSentence[4], ";")!=0) {
                printf ("Falta el punto y coma ';' al final de la inicialización de variable.\n");
            }
        } else if ((contarPalabras(lineptr)>5) && (contarPalabras(lineptr)<=7)) {
		if (strcmp(decSentence[2], "[")!=0) {
                	printf ("Falta el corchete de apertura '[' para iniciar el índice del arreglo.\n");
            	} else if (strcmp(decSentence[3], "]")!=0) {
                	printf ("Falta el corchete de cierre ']' para finalizar el índice del arreglo.\n");
            	} else if (strcmp(decSentence[4], "=")!=0) {
                	printf ("Falta el operador de asignación '=' para inicializar el arreglo.\n");
            	} else if (!isString(decSentence[5])) {
               		printf ("El valor de inicialización del arreglo debe ser una cadena entre comillas dobles \"...\".\n");
            	} else if (strcmp(decSentence[6], ";")!=0) {
                	printf ("Falta el punto y coma ';' al final de la inicialización del arreglo.\n");
	}
} else {
       printf ("El identificador %s no es válido para declarar una variable.\n", decSentence[1]);
       printf ("Los identificadores deben contener solo letras y números.\n");
    }
    printf("Recuerde que la estructura correcta para inicializar una variable es:\n");
    printf("tipo identificador = valor;\n");
    printf("Para inicializar un arreglo, la estructura es:\n");
    printf("tipo identificador[tamaño] = valor;\n");
}
}

void structureLibrarie (char* decSentence[]) {
	printf("La sintaxis para incluir una librería es incorrecta.\n");
        printf("Recuerde que la estructura correcta es: #include <nombre_libreria.h>\n");
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
	printf("Error de sintaxis en la línea %d, columna %d: el token %s no es válido en esta posición.\n", yylineno,colum, yytext);
	fprintf(stderr,"%s", lineptr);
	for(int i = 0; i < colum - 1; i++)
        	fprintf(stderr,"_");
	fprintf(stderr,"^\n");       
	identifyStructure(elementList);
        printf("Revise la estructura de la sentencia y corrija los errores.\n");
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
