.include <bsd.own.mk>

PROG=ratcal

GENSRCS=ratcal_lex.c ratcal_parse.c

SRCS= $(GENSRCS)
DPSRCS+=${GENSRCS}
YHEADER=1
CPPFLAGS+=-I${.CURDIR} -I.

.include <bsd.prog.mk>
