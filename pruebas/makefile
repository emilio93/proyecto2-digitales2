# Author:  Robin Gonzalez 
# Nov, 2017

#ARGS son las palabras que se pasan de "argumento" al makefile
#MODULES son los modulos que existen: nombre archivos .v en /bloques sin el .v
#VERILOGSRC  son todos los .v de modulos en /bloques
#USEDARGS son las palabras que son modulos existentes, por lo tanto se usaran
#CMDS son los comandos que querremos habilitar


CC       = iverilog
CCFLAGS  = -Ttyp -g specify -g2005-sv
CC1      = vvp
CC2      = gtkwave
CC3      = yosys -c
VPI      = -M ~/.local/install/ivl/lib/ivl
DIRS  = build pdfs

# Evita salidas de un comando
NO_OUTPUT = > /dev/null

# Evita impresion de errores de un comando
NO_ERROR  = 2> /dev/null

# crea folders necesarios en caso que no existan
MAKE_FOLDERS := $(shell mkdir -p $(DIRS))


CMDS = synth compile run view clean
ARGS = $(MAKECMDGOALS)
VERILOGSRC := $(shell ls ./bloques/**/*.v)
MODULES:= $(subst .v,,$(notdir $(VERILOGSRC)))#obtiene los modulos existentes
USEDARGS := $(filter $(ARGS), $(MODULES))#obtiene los modulos pasados como argumentos
USEDCMDS := $(filter $(ARGS), $(CMDS))#obtiene los comandos pasados como argumentos
MAKECMDGOALS := $(filter-out $(USEDARGS), $(MAKECMDGOALS))
USEDVERILOGSRC = $(filter %$(USEDARGS)%, $(VERILOGSRC))#obtiene las direcciones usadas por los argumentos


#h := $(filter %fsm.v, $(VERILOGSRC))
h := $(foreach dir, $(USEDARGS), $(filter %dir.v ,$(VERILOGSRC)))
#h := $(filter $(foreach dir, $(USEDARGS) , %dir.v) ,$(VERILOGSRC))

OBJS := $(foreach program,$(USEDARGS), bloques/*/$(program).v)

all:
	@echo "VERILOGSRC are: $(VERILOGSRC)"
	@echo "MODULES are: $(MODULES)"
	@echo "USEDARGS are: $(USEDARGS)"
	@echo "USEDCMDS are: $(USEDCMDS)"
	@echo "USEDCMDSGOALS are: $(MAKECMDGOALS)"
	@echo "USEDVERILOGSRC are: $(USEDVERILOGSRC)"
	@echo "USEDVERILOGSRC are: $(h)"
	@echo "OBJS are: $(OBJS)"


#	$(CMDS)
#	$(wildcard $(@echo " $(CMDS)"))
	$(foreach comando,  $(CMDS), $(comando) @echo"$(comando)" )
#	USEDCMDS



synth: synthYosys renameSynths
synthYosys:
	$(foreach vlog, $(OBJS) , VLOG_FILE_NAME=$(./bloques/fifo/fifo.v) VLOG_MODULE_NAME=$(vlog) CUR_DIR=$(shell pwd) $(CC3) ./yosys.tcl $(NO_OUTPUT);)
	rm -f ./pdfs/*.dot
# Renombra los archivos sintetizables
renameSynths:
	bash ./renameSynths.sh

	@echo "codigo para synth "

compile:
	@echo "codigo para compile $(USEDARGS) " 

run:
	@echo "codigo para run $(USEDARGS) "

view:
	@echo "codigo para view $(USEDARGS) "

clean:
	@echo "codigo para clean $(USEDARGS) "

# Ejecuta vvp para todos los tests compilados
run:
	$(foreach test,$(wildcard build/*.o), $(CC1) $(VPI) $(test);)

#$(MAKECMDGOALS):	#sobreecribe otras reglas
#	@echo "VERILOGSRC are: $(VERILOGSRC)"
#	@echo "MODULES are: $(MODULES)"
#	@echo "MODULES are: $(MODULES)"
#	@echo "MODULES are: $(MODULES)"
#	@echo "USEDARGS are: $(USEDARGS)"
#	@echo "USEDCMDS are: $(USEDCMDS)"




#USEDARGS = fifo roundRobin flowControl mux 
#MODULES =	
#MODULES := $(USEDARGS)
#USEDARGS = $(filter-out bla3, $(MODULES))
RESULTADOS = 

#@echo action $(filter $RESULTADOS,$(MAKECMDGOALS))
#$(filter $RESULTADOS,$(MODULES))



action:
#	        @echo action $(filter-out $@,$(MAKECMDGOALS))
	        @echo action $(filter $RESULTADOS,$(MAKECMDGOALS))

#%:      # thanks to chakrit
#		@:    # thanks to William Pursell


#run:
#	$(ARGS) += "roundRobin"
#	$(lol)


#run:
#	mkdir -p hiliws

lol:
#	@echo "USEDARGS is: $(USEDARGS)"
#	$(MODULES) $(subst .v,,$(notdir $(VERILOGSRC)))
	        @echo action $(filter $RESULTADOS,$(MAKECMDGOALS))
	$(filter $RESULTADOS,$(MODULES))

#	@echo $(MODULES)
	

hola:
	modules += hola


