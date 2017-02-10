#ifndef RATCAL_H
#define RATCAL_H

void lexerror(char *);

typedef struct rational {
	long numerator;
	long dominator;
} Rational;

#endif	/* RATCAL_H */
