yosys -import

set curDir         "$::env(CUR_DIR)"
set vlogModuleName "$::env(VLOG_MODULE_NAME)"
set vlogFileName   "$::env(VLOG_FILE_NAME)"
set cellLib        osu018_stdcells
# set cellLib        cmos_cells

yosys read_verilog $vlogFileName

hierarchy -check -top $vlogModuleName
show -prefix pdfs/$vlogModuleName-original -colors 3 -viewer echo $vlogModuleName

yosys proc
show -prefix pdfs/$vlogModuleName-proc -colors 3 -viewer echo $vlogModuleName

opt
show -prefix pdfs/$vlogModuleName-proc_opt -colors 3 -viewer echo $vlogModuleName

fsm
show -prefix pdfs/$vlogModuleName-fsm -colors 3 -viewer echo $vlogModuleName

opt
show -prefix pdfs/$vlogModuleName-fsm_opt -colors 3 -viewer echo $vlogModuleName

memory
show -prefix pdfs/$vlogModuleName-memory -colors 3 -viewer echo $vlogModuleName

opt
show -prefix pdfs/$vlogModuleName-memory_opt -colors 3 -viewer echo $vlogModuleName

techmap
show -prefix pdfs/$vlogModuleName-techmap -colors 3 -viewer echo $vlogModuleName

opt
show -prefix pdfs/$vlogModuleName-techmap_opt -colors 3 -viewer echo $vlogModuleName

write_verilog ./build/$vlogModuleName-rtlil.v

dfflibmap -liberty ./lib/$cellLib.lib

show -prefix pdfs/$vlogModuleName-dff_seq -lib ./lib/$cellLib.v -colors 3 -viewer echo $vlogModuleName

abc -liberty ./lib/$cellLib.lib
show -prefix pdfs/$vlogModuleName-abc_comb -lib ./lib/$cellLib.v -colors 3 -viewer echo $vlogModuleName

clean

show -prefix pdfs/$vlogModuleName-synth -lib ./lib/$cellLib.v -viewer echo -colors 3 -viewer echo $vlogModuleName
write_verilog ./build/$vlogModuleName-sintetizado.v
