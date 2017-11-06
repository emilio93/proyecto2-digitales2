VAR = fifo roundRobin flowControl mux 
MODULES = fifo
TMPVAR := $(VAR)
#VAR = $(filter-out bla3, $(TMPVAR))
VAR = $(filter $(MODULES), $(TMPVAR))


action:
#	        @echo action $(filter-out $@,$(MAKECMDGOALS))
	        @echo action $(filter $resultados,$(MAKECMDGOALS))

#%:      # thanks to chakrit
#		@:    # thanks to William Pursell


run:
	$(MODULES) += "roundRobin"
	$(lol)


#run:
#	mkdir -p hiliws

lol:
	@echo "VAR is: $(VAR)"

hola:
	modules += hola


