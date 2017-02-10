%{
/*
 * 有理数計算機の字句解析器
 */
#include "ratcal.h"
#include "ratcal_parse.h"
%}

%%
\+	return '+';
-	return '-';
\*	return '*';
\/	return '/';
=	return '=';
\.	return '.';
\(	return '(';
\)	return ')';
\n	return '\n';

[0-9]+	{
	yylval.integer = strtoul(yytext, NULL, 10);
	return INTEGER;
 }

[a-zA-Z_][a-zA-Z_0-9]* {
	yylval.name = strdup(yytext);
	return VAR;
 }

%%
/*
 * lexical error
 */
void lexerror(char *msg)
{
	extern int yynerrs, yylineno;

	++yynerrs;
	fprintf(stderr, "%d: %s\n", yylineno, msg);
}
