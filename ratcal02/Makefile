.include <bsd.own.mk>

PROG=ratcal
MKMAN=no

GENSRCS=ratcal_lex.c ratcal_parse.c

SRCS= $(GENSRCS) stub.c
DPSRCS+=${GENSRCS}
YHEADER=1
CPPFLAGS+=-I${.CURDIR} -I.

.include <bsd.prog.mk>
