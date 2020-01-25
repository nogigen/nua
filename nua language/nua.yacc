/* calculator.y */

%{
#include <stdio.h>
%}

%union{ double   real; /* real value */
        int   integer; /* integer value */
        char* string;
}

%token <string> STRING_VARIABLE STRING
%token <real> REAL SENSOR PRIM_FUNC REAL_VARIABLE
%token <integer> INTEGER SWITCH RECEIVE_INTEGER INT_VARIABLE
%token PLUS MINUS TIMES DIVIDE LP RP IF ELSE WHILE FOR DEFINE_FUNC SEND_INTEGER CONNECT_URL CALL_FUNC LB RB LESS_EQ GREATER_EQ GREATER LESS ASSIGN_OP SEMICOLON COLON EQUAL_OP NOT_EQ CHAR_VARIABLE STRING_VARIABLE AND_LOGIC OR_LOGIC COMMENT

%type <real> rexpr rnum
%type <integer> iexpr inum
%type <string> sexpr str

%left PLUS MINUS
%left TIMES DIVIDE
%left UMINUS

%nonassoc THEN
%nonassoc ELSE
%%

program: statements
{ printf("\n---------program is valid!--------\n");}
;

statements: /* nothing */
         | statements statement
;

statement: while_stmnt
            |for_stmt
            |assignment SEMICOLON
            |define_func_stmt
            |CONNECT_URL SEMICOLON
            | CALL_FUNC SEMICOLON
            |COMMENT
            |if_stm
;

if_stm: IF LP conditions RP LB statements RB           %prec THEN
   | IF LP conditions RP LB statements RB ELSE LB statements RB
;

expr: iexpr | rexpr | sexpr
;

while_stmnt: WHILE LP conditions RP LB statements RB
;

for_stmt: FOR LP assignment SEMICOLON conditions SEMICOLON assignment RP LB statements RB

assignment: variable ASSIGN_OP expr
;

define_func_stmt: DEFINE_FUNC LB statements RB
;

variable: CHAR_VARIABLE | STRING_VARIABLE | INT_VARIABLE |REAL_VARIABLE;

str: STRING |
    STRING_VARIABLE
;

inum: INTEGER
        | SWITCH
        | RECEIVE_INTEGER
    | INT_VARIABLE
;

rnum: REAL
        | SENSOR
        | PRIM_FUNC
    | REAL_VARIABLE
;

logics: AND_LOGIC | OR_LOGIC
;
cond_idents: LESS_EQ | GREATER_EQ | GREATER | LESS | EQUAL_OP | NOT_EQ
;

condition: LP expr cond_idents expr RP | LP condition logics condition RP | expr cond_idents expr
;

conditions: condition | condition logics conditions
  
sexpr: str
         | LP sexpr RP
           { $$ = $2;}
;

iexpr: inum
     | iexpr PLUS iexpr
       { $$ = $1 + $3;}
     | iexpr MINUS iexpr
       { $$ = $1 - $3;}
     | iexpr TIMES iexpr
       { $$ = $1 * $3;}
     | iexpr DIVIDE iexpr
       { if($3) $$ = $1 / $3;
         else { yyerror("divide by zero");
       }
     }
     | MINUS iexpr %prec UMINUS
       { $$ = - $2;}
     | LP iexpr RP
       { $$ = $2;}
;

rexpr: rnum
        | rexpr PLUS rexpr
      { $$ = $1 + $3;}
      | rexpr MINUS rexpr
      { $$ = $1 - $3;}
      | rexpr TIMES rexpr
      { $$ = $1 * $3;}
      | rexpr DIVIDE rexpr
      { if($3) $$ = $1 / $3;
        else { yyerror( "divide by zero" );
        }
      }
      | MINUS rexpr %prec UMINUS
      { $$ = - $2;}
      | LP rexpr RP
      { $$ = $2;}
      | iexpr PLUS rexpr
      { $$ = (double)$1 + $3;}
      | iexpr MINUS rexpr
      { $$ = (double)$1 - $3;}
      | iexpr TIMES rexpr
      { $$ = (double)$1 * $3;}
      | iexpr DIVIDE rexpr
      { if($3) $$ = (double)$1 / $3;
        else { yyerror( "divide by zero" );
        }
      }
      | rexpr PLUS iexpr
      { $$ = $1 + (double)$3;}
      | rexpr MINUS iexpr
      { $$ = $1 - (double)$3;}
      | rexpr TIMES iexpr
      { $$ = $1 * (double)$3;}
      | rexpr DIVIDE iexpr
      { if($3) $$ = $1 / (double)$3;
        else { yyerror( "divide by zero" ); }
      }
 ;

%%
#include "lex.yy.c"
int lineno;

main() {
    
  return yyparse();
}

yyerror( char *s ) { fprintf( stderr, "%slineno:%d\n", s, (lineno + 1)); };




