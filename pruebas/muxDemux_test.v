`timescale 1ns/1ps
//liberia de celdas cmos
`ifndef cmos_cells
	`include "../lib/cmos_cells.v"
`endif
//include de design under test(DUT), units under test(UUT)
`ifndef mux
  `include "../bloques/mux/mux.v"
`endif
`ifndef muxSynth
  `include "../build/mux-sintetizado.v"
`endif
`ifndef demux
  `include "../bloques/mux/demux.v"
`endif
`ifndef demuxSynth
  `include "../build/demux-sintetizado.v"
`endif

module muxDemux_test();


parameter DATA_BITS = 4;//tamaño de palabras

reg enb;
reg [$clog2(DATA_BITS)-1:0] selectorMux, selectorDemux;
reg [DATA_BITS-1:0] e0, e1, e2, e3;
wire [DATA_BITS-1:0] s0, s1, s2, s3;
wire [DATA_BITS-1:0] s0Synth, s1Synth, s2Synth, s3Synth;
wire [DATA_BITS-1:0] salidaMux;
wire [DATA_BITS-1:0] salidaSynthMux;

mux #(.DATA_BITS(DATA_BITS)) mux(
	.enb(enb),
	.entrada0_mux(e0),
	.entrada1_mux(e1),
	.entrada2_mux(e2),
	.entrada3_mux(e3),
	.selector_mux(selectorMux),
	.salida_mux(salidaMux)
	);

muxSynth muxSynth(
	.enb(enb),
	.entrada0_mux(e0),
	.entrada1_mux(e1),
	.entrada2_mux(e2),
	.entrada3_mux(e3),
	.selector_mux(selectorMux),
	.salida_mux(salidaSynthMux)
	);

demux #(.DATA_BITS(DATA_BITS)) demux(
	.enb(enb),
	.entrada_dmux(salidaMux),
	.selector_dmux(selectorDemux),
	.salida0_dmux(s0),
	.salida1_dmux(s1),
	.salida2_dmux(s2),
	.salida3_dmux(s3)
	);

demuxSynth demuxSynth(
	.enb(enb),
	.entrada_dmux(salidaSynthMux),
	.selector_dmux(selectorDemux),
	.salida0_dmux(s0Synth),
	.salida1_dmux(s1Synth),
	.salida2_dmux(s2Synth),
	.salida3_dmux(s3Synth)
	);

parameter delay = 10;

initial
begin
  $dumpfile("gtkws/muxDemux_test.vcd");
  $dumpvars();

	enb = 0;
	#delay
	selectorDemux = 2'b10;
	e0 = 4'b0010;
	selectorMux = 2'b01;
	e1 = 4'b1010;
	selectorMux = 2'b11;
	e2 = 4'b0110;
	selectorMux = 2'b00;
	e3 = 4'b1011;
	selectorMux = 2'b00;
	#delay
	enb = 1;
	e0 = 4'b1110;
	e1 = 4'b1110;
	e2 = 4'b1100;
	e3 = 4'b1000;
	selectorMux = 2'b00;
	selectorDemux = 2'b11;
	#delay
	selectorMux = 2'b01;
	selectorDemux = 2'b10;
	#delay
	selectorMux = 2'b10;
	selectorDemux = 2'b01;
	#delay
	selectorMux = 2'b11;
	selectorDemux = 2'b00;
	#delay
     #15 $finish;
end

endmodule
