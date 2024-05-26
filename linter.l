%{
#include "linter.tab.h"
extern char* yytext;
extern FILE *yyin;

static int next_colum = 1;
int colum = 1;

#define HANDLE_COLUM colum = next_colum; next_colum += strlen(yytext)


char *lineptr = NULL;
size_t n = 0;
size_t consumed = 0;
size_t available = 0;

size_t min(size_t a, size_t b);
    #define YY_INPUT(buf,result,max_size) {\
        if(available <= 0) {\
            consumed = 0;\
            available = getline(&lineptr, &n, yyin);\
            if (available < 0) {\
                if (ferror(yyin)) { perror("read error:"); }\
                    available = 0;\
                }\
        }\
        result = min(available, max_size);\
        strncpy(buf, lineptr + consumed, result);\
        consumed += result;\
        available -= result;\
    }

%}

%option noyywrap noinput nounput yylineno


int		-?[0-9]+
decimal		-?[0-9](\.[0-9])+
char		\'[^(\n|\')]{1}\'
string		\"[^(\n|\")]*\"
identifier 	[a-zA-Z0-9]+
libToImport	\<([a-zA-Z0-9_-]+\.h)\>

%%

{int}           {HANDLE_COLUM; return VINT;}
{decimal}       {HANDLE_COLUM; return DEC;}
{char}          {HANDLE_COLUM; return VCHA;}
{string}        {HANDLE_COLUM; return STR;}
{libToImport}   {HANDLE_COLUM; return LTI;}
"void"          {HANDLE_COLUM; return VOI;}
"if"            {HANDLE_COLUM; return IFF;}
"else"          {HANDLE_COLUM; return ELS;}
"long"          {HANDLE_COLUM; return LON;}
"return"        {HANDLE_COLUM; return RET;}
"short"         {HANDLE_COLUM; return SHO;} 
"for"           {HANDLE_COLUM; return FOR;}
"while"		{HANDLE_COLUM; return WHI;}
"double"        {HANDLE_COLUM; return DOU;}
"int"           {HANDLE_COLUM; return INT;}
"char"          {HANDLE_COLUM; return CHA;}
"#include"      {HANDLE_COLUM; return INC;}
"scanf" 	{HANDLE_COLUM; return SCA;}
"cout" 		{HANDLE_COLUM; return COU;}
"cin" 		{HANDLE_COLUM; return CIN;}
","		{HANDLE_COLUM; return COM;}
=		{HANDLE_COLUM; return ASS;}
"++"            {HANDLE_COLUM; return PPP;}
"--"		{HANDLE_COLUM; return MMM;}
\+		{HANDLE_COLUM; return PLS;}
\*		{HANDLE_COLUM; return AST;}
\-		{HANDLE_COLUM; return MIN;}
\/		{HANDLE_COLUM; return SLS;}
">>"		{HANDLE_COLUM; return MMQ;}
"<<"            {HANDLE_COLUM; return MMN;}
"<"             {HANDLE_COLUM; return MTQ;}
"<="            {HANDLE_COLUM; return MET;}
">"             {HANDLE_COLUM; return GTQ;}
">="            {HANDLE_COLUM; return GEQ;}
"=="            {HANDLE_COLUM; return EQL;}
"!="            {HANDLE_COLUM; return NQL;}
"("             {HANDLE_COLUM; return OPP;}
")"		{HANDLE_COLUM; return CPP;}
"{" 		{HANDLE_COLUM; return OCB;}
"}" 		{HANDLE_COLUM; return CCB;}
"[" 		{HANDLE_COLUM; return OBK;}
"]" 		{HANDLE_COLUM; return CBK;}
";"		{HANDLE_COLUM; return SMC;}
{identifier}	{HANDLE_COLUM; return IDE;}
[ \t]+		{HANDLE_COLUM;}	
[\n]		{HANDLE_COLUM; next_colum=1;}
.		{}

%% 

size_t min(size_t a, size_t b) {
    return b < a ? b : a;
}