yosys -import

set curDir         "$::env(CUR_DIR)"
set vlogModuleName "$::env(VLOG_MODULE_NAME)"
set vlogFileName   "$::env(VLOG_FILE_NAME)"

yosys read_verilog $vlogFileName

hierarchy -check -top $vlogModuleName
show -prefix pdfs/$vlogModuleName-original -format pdf -colors 3 -viewer echo $vlogModuleName

yosys proc
show -prefix pdfs/$vlogModuleName-proc -format pdf -colors 3 -viewer echo $vlogModuleName

opt
show -prefix pdfs/$vlogModuleName-proc_opt -format pdf -colors 3 -viewer echo $vlogModuleName

fsm
show -prefix pdfs/$vlogModuleName-fsm -format pdf -colors 3 -viewer echo $vlogModuleName

opt
show -prefix pdfs/$vlogModuleName-fsm_opt -format pdf -colors 3 -viewer echo $vlogModuleName

memory
show -prefix pdfs/$vlogModuleName-memory -format pdf -colors 3 -viewer echo $vlogModuleName

opt
show -prefix pdfs/$vlogModuleName-memory_opt -format pdf -colors 3 -viewer echo $vlogModuleName

techmap
# show -prefix pdfs/$vlogModuleName-techmap -format pdf -colors 3 -viewer echo $vlogModuleName

opt
# show -prefix pdfs/$vlogModuleName-techmap_opt -format pdf -colors 3 -viewer echo $vlogModuleName

write_verilog ./build/$vlogModuleName-rtlil.v

dfflibmap -liberty ./lib/cmos_cells.lib

# show -prefix pdfs/$vlogModuleName-dff_seq -lib ./lib/cmos_cells.v -format pdf -colors 3 -viewer echo $vlogModuleName

abc -liberty ./lib/cmos_cells.lib
# show -prefix pdfs/$vlogModuleName-abc_comb -lib ./lib/cmos_cells.v -format pdf -colors 3 -viewer echo $vlogModuleName

clean

# show -prefix pdfs/$vlogModuleName-synth -lib ./lib/cmos_cells.v -viewer echo -format pdf -colors 3 -viewer echo $vlogModuleName
write_verilog ./build/$vlogModuleName-sintetizado.v
