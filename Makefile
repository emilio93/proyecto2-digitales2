SHELL = /bin/sh

DIRS  = build pdfs

CC        = iverilog
CCFLAGS   = -Ttyp -g specify -g2005-sv -DCOMPILACION
CC1       = vvp
CC2       = gtkwave
CC3       = yosys -c
CC3_FLAGS = -q
VPI       = -M ~/.local/install/ivl/lib/ivl

# Evita salidas de un comando
NO_OUTPUT = > /dev/null

# Evita impresion de errores de un comando
NO_ERROR  = 2> /dev/null

# crea folders necesarios en caso que no existan
MAKE_FOLDERS := $(shell mkdir -p $(DIRS))

.PHONY: 	compile run synth

# ******************************************************************************
# ALL
# ******************************************************************************
# DESCRIPCION:
#   Realiza todo el proceso(synth compile run) para los modulos y pruebas
#   especificados, o para todos en caso de no indicarse ninguno.
# ARGUMENTOS:
# 	nombre-del-modulo-n: nombre de una modulo que se sintetiza. Los modulos se
# 	encuentran en la carpeta 'bloques/<nombre-del-grupo>/<nombre-del-modulo>' y
# 	se nombran <nombre-del-grupo>/<nombre-del-modulo>.v'.
# USO:
#   make all <nombre-del-modulo-1> <nombre-del-modulo-2> ... <nombre-de-la-prueba-1> <nombre-de-la-prueba-2> ...
all: synth compile run

# ******************************************************************************
# SYNTH
# ******************************************************************************
# DESCRIPCION:
#   Sintetiza segun scripts de yosys los modulos especificados o bien todos los
#   existentes en caso de no indicarse ninguno.
# ARGUMENTOS:
# 	nombre-del-modulo-n: nombre de una modulo que se sintetiza. Los modulos se
# 	encuentran en la carpeta 'bloques/<nombre-del-grupo>/<nombre-del-modulo>' y
# 	se nombran <nombre-del-grupo>/<nombre-del-modulo>.v'.
# USO:
#   make synth <nombre-del-modulo-1> <nombre-del-modulo-2> ...
ifeq ($(MAKECMDGOALS:synth%=%),$(MAKECMDGOALS))
synth: synthYosys synthRename
else
synth: synthYosys synthRename synthEnd
endif
ifneq ($(MAKECMDGOALS:synth%=%),)
synthYosys:
	@echo "****************************"
	@echo "*** MODULOS A SINTETIZAR ***"
	@echo "****************************"
	@echo ""
	@$(foreach module,$(MAKECMDGOALS:synth%=%),$(foreach vlog, $(wildcard ./bloques/**/$(module).v),echo $(vlog);))
	@echo ""
	@echo "****************************"
	@echo ""
	@$(foreach module,$(MAKECMDGOALS:synth%=%),$(foreach vlog, $(wildcard ./bloques/**/$(module).v), echo VLOG_FILE_NAME=$(vlog) VLOG_MODULE_NAME=$(module) CUR_DIR=$(shell pwd) $(CC3) ./yosys.tcl $(CC3_FLAGS); VLOG_FILE_NAME=$(vlog) VLOG_MODULE_NAME=$(module) CUR_DIR=$(shell pwd) $(CC3) ./yosys.tcl $(CC3_FLAGS);echo "";))
	@echo ""
else
synthYosys:
	@echo "*************************************"
	@echo "*** SINTETIZANDO TODO EL PROYECTO ***"
	@echo "*************************************"
	@echo ""
	@$(foreach vlog, $(wildcard ./bloques/**/*.v), echo VLOG_FILE_NAME=$(vlog) VLOG_MODULE_NAME=$(subst .v,,$(notdir $(vlog))) CUR_DIR=$(shell pwd) $(CC3) ./yosys.tcl $(CC3_FLAGS); VLOG_FILE_NAME=$(vlog) VLOG_MODULE_NAME=$(subst .v,,$(notdir $(vlog))) CUR_DIR=$(shell pwd) $(CC3) ./yosys.tcl $(CC3_FLAGS);echo "";)
	@echo ""
endif
# Convierte dots en pdfs y elimina los dots
synthDot2Pdf:
	@echo ""
	@echo "**************************"
	@echo "*** CONVIRTIENDO A PDF ***"
	@echo "**************************"
	@echo ""
	@$(foreach dot, $(wildcard ./pdfs/*.dot), echo dot -Tpdf $(dot) -o $(subst .dot,.pdf,$(dot)); dot -Tpdf $(dot) -o $(subst .dot,.pdf,$(dot));)
	rm -f ./pdfs/*.dot

# Renombra los archivos sintetizables
synthRename:
	@echo ""
	@echo "****************************************"
	@echo "*** RENOMBRANDO MODULOS SINTETIZADOS ***"
	@echo "****************************************"
	@echo ""
	@bash ./renameSynths.sh
synthEnd:
	$(error *** Fin de make synth *** ***)

# ******************************************************************************
# COMPILE
# ******************************************************************************
# DESCRIPCION:
# 	Compila con iverilog las pruebas especificadas o todas las existentes si no
# 	se indica ninguna.
# 	Primero realiza un preprocesamiento de los módulos para
# 	permitir el uso de macros(ifndef, define, etc)
# 	Luego compila con iverilog los archivos preprocesados.
# ARGUMENTOS:
# 	nombre-de-la-prueba-n: nombre de una prueba que se compila. Las pruebas se
# 	encuentran en la carpeta 'pruebas' y se nombran
# 	<nombre-de-la-prueba-n>_test.v'. En caso de no especificarse ninguna prueba
# 		se compilan todas las existentes.
# USO:
# 	make compile <nombre-de-la-prueba-1> <nombre-de-la-prueba-2> ...
ifeq ($(MAKECMDGOALS:compile%=%),$(MAKECMDGOALS))
compile: compilePre compileComp
else
compile: compilePre compileComp compileEnd
endif
ifneq ($(MAKECMDGOALS:compile%=%),)
compilePre:
	@echo "**************************"
	@echo "*** PRUEBAS A COMPILAR ***"
	@echo "**************************"
	@echo ""
	@$(foreach module,$(MAKECMDGOALS:compile%=%), $(foreach vlog, $(wildcard ./pruebas/$(module)_test.v), echo $(vlog);))
	@echo ""
	@echo "****************************"
	@echo ""
	@echo "****************"
	@echo "PREPROCESANDO..."
	@echo "****************"
	@$(foreach module,$(MAKECMDGOALS:compile%=%), $(foreach test, $(wildcard ./pruebas/$(module)_test.v), echo "";echo cd pruebas;echo $(CC) -E -DKEY=10 -o ../build/$(subst ./pruebas/,,$(subst .v,.pre.v,$(test))) $(subst ./pruebas/,,$(test)) $(CCFLAGS);echo cd ..; cd pruebas;$(CC) -E -DKEY=10 -o ../build/$(subst ./pruebas/,,$(subst .v,.pre.v,$(test))) $(subst ./pruebas/,,$(test)) $(CCFLAGS);cd ..;))
compileComp:
	@echo ""
	@echo "*************"
	@echo "COMPILANDO..."
	@echo "*************"
	@$(foreach module,$(MAKECMDGOALS:compile%=%), $(foreach test, $(wildcard ./build/$(module)_test.pre.v), echo "";echo cd build;echo $(CC) -o $(subst ./build/,,$(subst .pre.v,.o,$(test))) $(subst ./build/,,$(test)) $(CCFLAGS);echo cd ..; cd build;$(CC) -o $(subst ./build/,,$(subst .pre.v,.o,$(test))) $(subst ./build/,,$(test)) $(CCFLAGS);cd ..;))
else
compilePre:
	@echo "***********************************"
	@echo "*** COMPILANDO TODO EL PROYECTO ***"
	@echo "***********************************"
	@echo ""
	@echo "****************"
	@echo "PREPROCESANDO..."
	@echo "****************"
	@$(foreach test,$(wildcard pruebas/*.v),echo cd pruebas; echo $(CC) -E -DKEY=10 -o ../build/$(subst pruebas/,,$(subst .v,.pre.v,$(test))) $(subst pruebas/,,$(test)) $(CCFLAGS);echo cd ..;cd pruebas; $(CC) -E -DKEY=10 -o ../build/$(subst pruebas/,,$(subst .v,.pre.v,$(test))) $(subst pruebas/,,$(test)) $(CCFLAGS);cd ..;)
compileComp:
	@echo ""
	@echo "*************"
	@echo "COMPILANDO..."
	@echo "*************"
	@$(foreach test,$(wildcard build/*.pre.v),echo cd build; echo $(CC) -o $(subst build/,,$(subst .pre.v,.o,$(test))) $(subst build/,,$(test)) $(CCFLAGS);echo cd ..; cd build; $(CC) -o $(subst build/,,$(subst .pre.v,.o,$(test))) $(subst build/,,$(test)) $(CCFLAGS);cd ..;)
endif
compileEnd:
	$(error *** Fin de make compile *** ***)

# ******************************************************************************
# RUN
# ******************************************************************************
# DESCRIPCION:
#   Ejecuta el archivo compilado con vvp para las pruebas especificadas o todas
#   las existentes en caso de no indicarse ninguna.
# ARGUMENTOS:
# 	nombre-de-la-prueba-n: nombre de una prueba que se ejecuta. Las pruebas se
# 	encuentran en la carpeta 'pruebas' y se nombran
# 	<nombre-de-la-prueba-n>_test.v'.
# USO:
#   make run <nombre-de-la-prueba-1> <nombre-de-la-prueba-2> ...
ifeq ($(MAKECMDGOALS:run%=%),$(MAKECMDGOALS))
run: runRun makeEnd
else
run: runRun runEnd
endif
ifneq ($(MAKECMDGOALS:run%=%),)
runRun:
	@echo ""
	@echo "************"
	@echo "CORRIENDO..."
	@echo "************"
	@$(foreach module,$(MAKECMDGOALS:run%=%), $(foreach test, $(wildcard ./build/$(module)_test.o), echo "";echo $(CC1) $(VPI) $(test); $(CC1) $(VPI) $(test);echo "";))
else
runRun:
	@echo "************"
	@echo "CORRIENDO..."
	@echo "************"
	@echo ""
	$(foreach test,$(wildcard build/*.o), $(CC1) $(VPI) $(test);)
endif
runEnd:
	$(error *** Fin de make run *** ***)
makeEnd:
	$(error *** Fin de make all *** ***)

# ******************************************************************************
# VIEW
# ******************************************************************************
# DESCRIPCION:
#   Abre el visualizador de ondas gtkwave con los tests especificados.
# ARGUMENTOS:
# 	nombre-del-gtkw-n: nombre de un test que se muestra. Los tests se encuentran
# 	 en la carpeta 'gtkws' y se nombran '<nombre-del-test-n>_test.gtkw'.
# USO:
#   make view <nombre-del-gtkw-1> <nombre-del-gtkw-2> ...
ifneq ($(MAKECMDGOALS:view%=%),)
view:
	@$(foreach test,$(MAKECMDGOALS:view%=%), $(foreach gtkw, $(wildcard ./gtkws/$(test)_test.gtkw),echo $(CC2) $(gtkw);))
	@$(foreach test,$(MAKECMDGOALS:view%=%), $(foreach gtkw, $(wildcard ./gtkws/$(test)_test.gtkw), $(CC2) $(gtkw) & cd .;))
	$(warning *** Abriendo Visualizador *** ***)
else
view:
	$(error *** make view requiere argumento(s) *** ***)
endif

# ******************************************************************************
# CLEAN
# ******************************************************************************
# DESCRIPCION:
#   Limpia el proyecto eliminando todos los archivos generados.
#   No acepta comandos, es decir, borra todos los archivos generados
#   para modulos y pruebas.
# USO:
#   make clean
clean:
	rm -r build
	rm -r pdfs
	rm -f ./*.dot
	rm -f gtkws/*.vcd

help:
	@echo "*****************"
	@echo "*** make help ***"
	@echo "*****************"
	@echo ""
	@echo "EJEMPLOS DE USO:"
	@echo ""
	@echo "	make & make view prueba1"
	@echo "	make all modulo1 modulo2"
	@echo "	make synth"
	@echo "	make compile modulo1 & make run modulo1"
	@echo "	make run"
	@echo "	make view prueba1 prueba2"
	@echo "	make clean"
	@echo ""
	@echo "REGLAS DISPONIBLES: all, synth, compile, run, view, clean, help"
	@echo ""
	@echo "MODULOS DISPONIBLES:"
	@$(foreach vlog, $(wildcard ./bloques/**/*.v), echo "	$(subst .v,,$(notdir $(vlog)))";)
	@echo ""
	@echo "PRUEBAS DISPONIBLES:"
	@$(foreach vlog, $(wildcard ./pruebas/*_test.v), echo "	$(subst _test.v,,$(notdir $(vlog)))";)
	@echo ""
	@echo "******************************************************************************"
	@echo "ALL"
	@echo "******************************************************************************"
	@echo "DESCRIPCION:"
	@echo "	Realiza todo el proceso(synth compile run) para los modulos y pruebas"
	@echo "	especificados, o para todos en caso de no indicarse ninguno."
	@echo "ARGUMENTOS:"
	@echo "	 - nombre-del-modulo-n: nombre de una modulo que se sintetiza. Los modulos se"
	@echo "	encuentran en la carpeta 'bloques/<nombre-del-grupo>/<nombre-del-modulo>' y"
	@echo "	se nombran <nombre-del-grupo>/<nombre-del-modulo>.v'. No existe 'make all',"
	@echo "	para este comportamiento usar 'make'."
	@echo "USO:"
	@echo "	make all <nombre-del-modulo-1> <nombre-del-modulo-2> ... <nombre-de-la-prueba-1> <nombre-de-la-prueba-2> ..."
	@echo ""
	@echo "******************************************************************************"
	@echo "SYNTH"
	@echo "******************************************************************************"
	@echo "DESCRIPCION:"
	@echo "	Sintetiza segun scripts de yosys los modulos especificados o bien todos los"
	@echo "	existentes en caso de no indicarse ninguno."
	@echo "ARGUMENTOS:"
	@echo "	 - nombre-del-modulo-n: nombre de una modulo que se sintetiza. Los modulos se"
	@echo "	encuentran en la carpeta 'bloques/<nombre-del-grupo>/<nombre-del-modulo>' y"
	@echo "	se nombran <nombre-del-grupo>/<nombre-del-modulo>.v'."
	@echo "USO:"
	@echo "	make synth <nombre-del-modulo-1> <nombre-del-modulo-2> ..."
	@echo ""
	@echo "******************************************************************************"
	@echo "COMPILE"
	@echo "******************************************************************************"
	@echo "DESCRIPCION:"
	@echo "	Compila con iverilog las pruebas especificadas o todas las existentes si no"
	@echo "	se indica ninguna."
	@echo "	Primero realiza un preprocesamiento de los módulos para"
	@echo "	permitir el uso de macros(ifndef, define, etc)"
	@echo "	Luego compila con iverilog los archivos preprocesados."
	@echo "ARGUMENTOS:"
	@echo "	 - nombre-de-la-prueba-n: nombre de una prueba que se compila. Las pruebas se"
	@echo "	encuentran en la carpeta 'pruebas' y se nombran"
	@echo "	<nombre-de-la-prueba-n>_test.v'. En caso de no especificarse ninguna prueba"
	@echo "	se compilan todas las existentes."
	@echo "USO:"
	@echo "	make compile <nombre-de-la-prueba-1> <nombre-de-la-prueba-2> ..."
	@echo ""
	@echo "******************************************************************************"
	@echo "RUN"
	@echo "******************************************************************************"
	@echo "DESCRIPCION:"
	@echo "	Ejecuta el archivo compilado con vvp para las pruebas especificadas o todas"
	@echo "	las existentes en caso de no indicarse ninguna."
	@echo "ARGUMENTOS:"
	@echo "	 - nombre-de-la-prueba-n: nombre de una prueba que se ejecuta. Las pruebas se"
	@echo "	encuentran en la carpeta 'pruebas' y se nombran"
	@echo "	<nombre-de-la-prueba-n>_test.v'."
	@echo "USO:"
	@echo "  make run <nombre-de-la-prueba-1> <nombre-de-la-prueba-2> ..."
	@echo ""
	@echo "******************************************************************************"
	@echo "VIEW"
	@echo "******************************************************************************"
	@echo "DESCRIPCION:"
	@echo "	Abre el visualizador de ondas gtkwave con los tests especificados."
	@echo "ARGUMENTOS:"
	@echo "	nombre-del-gtkw-n: nombre de un test que se muestra. Los tests se encuentran"
	@echo "	 en la carpeta 'gtkws' y se nombran '<nombre-del-test-n>_test.gtkw'."
	@echo "USO:"
	@echo "  make view <nombre-del-gtkw-1> <nombre-del-gtkw-2> ..."
	@echo ""
	@echo "******************************************************************************"
	@echo "CLEAN"
	@echo "******************************************************************************"
	@echo "DESCRIPCION:"
	@echo "	Limpia el proyecto eliminando todos los archivos generados."
	@echo "	No acepta comandos, es decir, borra todos los archivos generados"
	@echo "	para modulos y pruebas."
	@echo "USO:"
	@echo "	make clean"
	@echo ""
