# Makefile for INTEL: DDMETIS

SHELL = /bin/bash

.SUFFIXES = .f90 .f .o .mod

VPATH = src

PROGRAM=./bin/ddmetis.exe

SRC=\
	ddmetis.f\
	main.f

SRCDIR    = ./src
OBJDIR    = ./obj
MODDIR    = ./mod
FMETISDIR = /home/alejo/Desktop/Datos/FMetis/fmetis/build

OBJ = $(addprefix $(OBJDIR)/, $(SRC:.f=.o))

FORTRAN=gfortran
FFLAGS= -I $(FMETISDIR)/include 
LIBS= -L $(FMETISDIR)/lib -lfmetis -lmetis

.PHONY: all
all: start
start:
	@echo ""
	@echo "   DDMETIS: Domain Decomposition with Metis."
	@echo " "
	
	@$(MAKE) $(PROGRAM)
	@$(MAKE) tags

	@echo " "
	@echo "   Done!"
	@echo " "

$(PROGRAM): $(OBJ)
	$(FORTRAN) -o $@ $^ $(LIBS)

$(OBJDIR)/%.o: %.f
	$(FORTRAN) $(FFLAGS) -c $^ -o $@ -J$(MODDIR) 

.PHONY: clean
clean:
	@echo " "
	@echo "   Removing binary files and tags."
	-@rm -f $(OBJDIR)/*.o $(MODDIR)/*.f $(MODDIR)/*.mod *.mod $(PROGRAM) tags 2>/dev/null || true        # silently remove files
	@echo ""

.PHONY: tags
tags:
	@ctags $(SRCDIR)/*.f --languages=fortran 
	@echo '   Adding tags file.'
