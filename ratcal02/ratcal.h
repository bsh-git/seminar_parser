#ifndef RATCAL_H
#define RATCAL_H

void lexerror(char *);
int yylex (void);
void yyerror(const char *);

typedef struct rational {
	long numerator;
	long dominator;
} Rational;


Rational rational_new(long, long);
Rational rational_sub(Rational, Rational);
Rational rational_add(Rational, Rational);
Rational rational_mul(Rational, Rational);
Rational rational_div(Rational, Rational);
Rational rational_neg(Rational);

void print_rational(Rational);
void print_approx(Rational);

#endif	/* RATCAL_H */
