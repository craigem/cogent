#
# Copyright 2016, NICTA
#
# This software may be distributed and modified according to the terms of
# the GNU General Public License version 2. Note that NO WARRANTY is provided.
# See "LICENSE_GPLv2.txt" for details.
#
# @TAG(NICTA_GPL)
#

NAME=wordarray_simple

SRC=wordarray_simple.cogent
OUTPUT=generated # $(SRC:.cogent=-gen)
COUTPUT=$(addsuffix .c, $(OUTPUT))
HOUTPUT=$(addsuffix .h, $(OUTPUT))

LIBGUM=../libgum
PLATLIBGUM=../plat/console/libgum

AHFILES=$(LIBGUM)/abstract/WordArray.ah
ACFILES=main.ac 

PP=$(ACFILES:.ac=_pp.ac)
PPINFER=$(ACFILES:.ac=_pp_inferred.c)

ABSDIR=./abstract

OBJ=$(PPINFER:.c=.o)

CFLAGS=-I. -I.. -I../plat/console

.PHONY: default cogent clean gen-anti test
.SECONDARY:

default: all

all: gen-anti $(OBJ)
	$(CC) -o $(NAME) $(OBJ)

test: gen-anti $(OBJ)

$(OBJ): $(PPINFER)

gen-anti:
	mkdir -p $(ABSDIR)
	cogent -g $(SRC) --debug --infer-c-types="$(AHFILES)" --infer-c-funcs="$(ACFILES)" --cpp-args="\$$CPPIN -E -P $(CFLAGS) -o \$$CPPOUT" --ext-types=types.cfg --entry-funcs=entrypoints.cfg -Od -ogenerated

clean:
	rm -f $(COUTPUT) $(HOUTPUT) $(PP) $(PPINFER) $(OBJ)
	rm -f generated.o
	rm -f $(ABSDIR)/*.h
	rm -f $(NAME)

