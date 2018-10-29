# Makefile for Minesweeper

# The compiler being used

CC= gcc

# compiler options
CFLAGS = -Wall -O3

# object files

OBJECTS= P1-1.o minefield.o

all: msweep

msweep: $(OBJECTS)
	${CC} ${CFLAGS} $(OBJECTS) -o msweep

P1-1.o: P1-1.c minefield.h
	${CC} ${CFLAGS} -c P1-1.c

clean:
	rm P1-1.o
	rm msweep


