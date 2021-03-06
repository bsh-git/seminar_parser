%{
#include <sys/cdefs.h>
#include <sys/types.h>	
#include <stdio.h>
#include "ratcal.h"

void assign_var(const char *, Rational);
Rational get_variable(const char *);
%}

%left '+' '-'
%left '*'
%right '/'
%left NEG     /* 単項マイナス */

%union {
	Rational val;
	long integer;
	const char *name;
}

%type <val> expr
%token <integer> INTEGER
%token <name> VAR

%%
input: /* empty */
	| input sentence
	;

sentence: '\n'
	| expr '\n' { print_rational($1); }
	| VAR '=' expr '\n'
	{ assign_var($1, $3); }
	| '.' expr '\n' { print_approx($2); }
	;

expr:     INTEGER { $$ = rational_new($1, 1); }
	| VAR { $$ = get_variable($1); }
	| expr '+' expr { $$ = rational_add($1, $3); }
	| expr '-' expr { $$ = rational_sub($1, $3); }
	| expr '*' expr { $$ = rational_mul($1, $3); }
	| expr '/' expr { $$ = rational_div($1, $3); }
	| '-' expr %prec NEG { $$ = rational_neg($2); }
	| '(' expr ')' { $$ = $2; }
	;
%%

void
yyerror(const char *msg)
{
	fprintf(stderr, "Error: %s\n", msg);
}


int
main(int argc, char **argv)
{
	yyparse();
}
