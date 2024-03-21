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
FMETISDIR = ~/GitRepos/fmetis/build/

OBJ = $(addprefix $(OBJDIR)/, $(SRC:.f=.o))

FORTRAN=ifx
FFLAGS= -O3 -xHost -check pointers -check bounds -check format -check shape -traceback -fpe0 -init=zero -save -warn all -warn notruncated_source -warn noexternals -fpmodel=precise -assume buffered_io -ipo -fp-model fast -I $(FMETISDIR)/include
LIBS= -O3 -xHost -assume buffered_io -ipo -fp-model fast -L $(FMETISDIR)/lib -lfmetis -lmetis 

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
	$(FORTRAN) $(FFLAGS) -c $^ -o $@ -module $(MODDIR) -I$(MODDIR) 

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
