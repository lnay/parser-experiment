%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
	int ival;
	float fval;
//	struct bin_expr{
//		expr_t* l_expr;
//		expr_t* r_expr;
//		char operator;
//	}
	char operator;
}

%token<ival> T_INT
%token<fval> T_FLOAT
%token<operator> T_OP
%token T_LEFT T_RIGHT
%token T_NEWLINE T_QUIT
%left T_OP

%type<ival> expression
%type<fval> mixed_expression

%start calculation

%%

calculation:
	   | calculation line
;

line: T_NEWLINE
    | mixed_expression T_NEWLINE { printf("\tResult: %f\n", $1);}
    | expression T_NEWLINE { printf("\tResult: %i\n", $1); }
    | T_QUIT T_NEWLINE { printf("bye!\n"); exit(0); }
;

mixed_expression: T_FLOAT                 		 { $$ = $1; }
	  | mixed_expression T_OP mixed_expression
{ 
	switch($2){
		case '+':
			$$ = $1 + $3; 
			break;
		case '-':
			$$ = $1 - $3; 
			break;
		case '*':
			$$ = $1 * $3; 
			break;
		case '/':
			$$ = $1 / $3; 
			break;
		default:
			$$ = $1 + $3; 
			break;
	}
}
	  | T_LEFT mixed_expression T_RIGHT		 { $$ = $2; }
	  | expression T_OP mixed_expression
{ 
	switch($2){
		case '+':
			$$ = $1 + $3; 
			break;
		case '-':
			$$ = $1 - $3; 
			break;
		case '*':
			$$ = $1 * $3; 
			break;
		case '/':
			$$ = $1 / $3; 
			break;
		default:
			$$ = $1 + $3; 
			break;
	}
}
	  | mixed_expression T_OP expression
{ 
	switch($2){
		case '+':
			$$ = $1 + $3; 
			break;
		case '-':
			$$ = $1 - $3; 
			break;
		case '*':
			$$ = $1 * $3; 
			break;
		case '/':
			$$ = $1 / $3; 
			break;
		default:
			$$ = $1 + $3; 
			break;
	}
}
;

expression: T_INT				{ $$ = $1; }
	  | expression T_OP expression
{ 
	switch($2){
		case '+':
			$$ = $1 + $3; 
			break;
		case '-':
			$$ = $1 - $3; 
			break;
		case '*':
			$$ = $1 * $3; 
			break;
		case '/':
			$$ = $1 / $3; 
			break;
		default:
			$$ = $1 + $3; 
			break;
	}
}
	  | T_LEFT expression T_RIGHT		{ $$ = $2; }
;

%%

int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
