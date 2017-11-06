DIRS  = build pdfs

CC       = iverilog
CCFLAGS  = -Ttyp -g specify -g2005-sv
CC1      = vvp
CC2      = gtkwave
CC3      = yosys -c
VPI      = -M ~/.local/install/ivl/lib/ivl

# Evita salidas de un comando
NO_OUTPUT = > /dev/null

# Evita impresion de errores de un comando
NO_ERROR  = 2> /dev/null

# crea folders necesarios en caso que no existan
MAKE_FOLDERS := $(shell mkdir -p $(DIRS))

.PHONY: 	compile run synth

# Sintetiza con yosys, compila con iverilog y corre con vvp
all: synth compile run

# Compila con iverilog
# Primero realiza un preprocesamiento de los módulos para
# permitir el uso de macros(ifndef, define, etc)
# Luego compila con iverilog los archivos preprocesados
compile:
	$(foreach test,$(wildcard pruebas/*.v),cd pruebas; $(CC) -E -DKEY=10 -o ../build/$(subst pruebas/,,$(subst .v,.pre.v,$(test))) $(subst pruebas/,,$(test)) $(CCFLAGS);cd ..;)
	$(foreach test,$(wildcard build/*.pre.v),cd build; $(CC) -o $(subst build/,,$(subst .pre.v,.o,$(test))) $(subst build/,,$(test)) $(CCFLAGS);cd ..;)

# Sintetiza segun scripts de yosys dentro de las carpetas para los bloques
synth: synthYosys renameSynths
synthYosys:
	$(foreach vlog,$(wildcard ./bloques/**/*.v), VLOG_FILE_NAME=$(vlog) VLOG_MODULE_NAME=$(subst .v,,$(notdir $(vlog))) CUR_DIR=$(shell pwd) $(CC3) ./yosys.tcl $(NO_OUTPUT);)
	rm -f ./pdfs/*.dot
# Renombra los archivos sintetizables
renameSynths:
	bash ./renameSynths.sh

# Ejecuta vvp para todos los tests compilados
run:
	$(foreach test,$(wildcard build/*.o), $(CC1) $(VPI) $(test);)

# Este comando acepta argumentos al correrlo de la siguiente manera
# > make gtkw="./achivo.gtkw" view
# Resulta más sencillo utilizar simplemente
# > gtkwave ./archivo.gtkw
# Sin embargo se agrega la funcionalidad
#
# TODO actualizar para permitir utilizar el siguiente comando
# make m="<nombreModulo>" view
# esto busca en la carpeta de los gtkws el archivo .gtkw
# correspondiente y visualiza las ondas
view:
	gtkwave $(gtkw)

# Limpia el proyecto eliminando todos los archivos generados.
clean:
	rm -r build
	rm -r pdfs
	rm -f ./*.dot
	rm -f gtkws/*.vcd
