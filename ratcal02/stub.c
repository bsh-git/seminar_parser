#include <stdio.h>
#include "ratcal.h"

Rational rational_new(long, long);
Rational rational_sub(Rational, Rational);
Rational rational_add(Rational, Rational);
Rational rational_mul(Rational, Rational);
Rational rational_div(Rational, Rational);
Rational rational_neg(Rational);

void
print_rational(Rational r)
{
	printf("%ld/%ld\n", r.numerator, r.dominator);
}

void print_approx(Rational r)
{
	printf("%f\n",
	       (double)r.numerator / (double)r.dominator);
}

Rational
rational_new(long n, long d)
{
	Rational r;
	r.numerator = n;
	r.dominator = d;
	return r;
}

Rational
rational_add(Rational left, Rational right)
{
	fprintf(stderr, "[%s]", __func__);
	return left;
}

Rational
rational_sub(Rational left, Rational right)
{
	fprintf(stderr, "[%s]", __func__);
	return left;
}

Rational
rational_mul(Rational left, Rational right)
{
	fprintf(stderr, "[%s]", __func__);
	return left;
}

Rational
rational_div(Rational left, Rational right)
{
	fprintf(stderr, "[%s]", __func__);
	return left;
}

Rational
rational_neg(Rational r)
{
	r.numerator = - r.numerator;
	return r;
}

Rational
get_variable(const char *name)
{
	fprintf(stderr, "[%s]", __func__);
	Rational r = {0,0};
	return r;
}

void
assign_var(const char *name, Rational r)
{
	fprintf(stderr, "[%s]", __func__);
}
