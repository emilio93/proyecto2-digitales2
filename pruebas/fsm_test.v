`timescale 1ns/1ps

`define isTest 1

`include "../lib/osu018_stdcells.v"
`include "../bloques/flowControl/fsm.v"
`include "../build/fsm-sintetizado.v"

module fsm_test();

  reg clk, reset, iniciar;
  reg [4:0] aFull;
  reg [4:0] full;
  reg [4:0] aEmpty;
  reg [4:0] empty;
  wire error, idle;
  wire [3:0] pausa;
  wire [3:0] continuar;
  wire errorSynth, idleSynth;
  wire [3:0] pausaSynth;
  wire [3:0] continuarSynth;

  parameter delay = 10;

  fsm fsm(
	.iniciar(clk),
	.reset(reset),
	.almost_full(aFull),
	.full(full),
	.almost_empty(aEmpty),
	.empty(empty),
	.clk(clk),
	.continuar(continuar),
	.error_full(error),
	.pausa(pausa),
	.idle(idle)
  );

  fsm fsmSynth(
	.iniciar(clk),
	.reset(reset),
	.almost_full(aFull),
	.full(full),
	.almost_empty(aEmpty),
	.empty(empty),
	.clk(clk),
	.continuar(continuarSynth),
	.error_full(errorSynth),
	.pausa(pausaSynth),
	.idle(idleSynth)
  );


  always # 5 clk = ~clk;

  initial
  begin
    $dumpfile("gtkws/fsm_test.vcd");
    $dumpvars();
    $display("fsm_test");

    clk <= 0;
    reset <= 1;

    iniciar <= 0;
    aFull <= 4'b0000;
    full <= 4'b0000;
    aEmpty <= 4'b0001;
    empty <= 4'b0000;
    full <= 4'b0000;

    #delay;

    #delay;
    iniciar <= 0;
    aFull <= 4'b0000;
    full <= 4'b0000;
    aEmpty <= 4'b0001;
    empty <= 4'b0000;
    full <= 4'b0000;

    #delay;
    reset <= 0;
    iniciar <= 1;
    #delay
    iniciar <= 0;

    #delay;
    iniciar <= 0;
    aFull <= 4'b0000;
    full <= 4'b0000;
    aEmpty <= 4'b0001;
    empty <= 4'b0000;
    full <= 4'b0000;

    #delay;
    iniciar <= 0;
    aFull <= 4'b0000;
    full <= 4'b0000;
    aEmpty <= 4'b0001;
    empty <= 4'b0000;
    full <= 4'b0000;



    iniciar <= 0;
    aFull <= 4'b0000;
    full <= 4'b0000;
    aEmpty <= 4'b0000;
    empty <= 4'b0001;

    #delay;
    iniciar <= 0;
    aFull <= 4'b0000;
    full <= 4'b0000;
    aEmpty <= 4'b0001;
    empty <= 4'b0000;

    #delay;
    iniciar <= 0;
    aFull <= 4'b0000;
    full <= 4'b0000;
    aEmpty <= 4'b0001;
    empty <= 4'b0000;

    #delay;
    iniciar <= 0;
    aFull <= 4'b0000;
    full <= 4'b0000;
    aEmpty <= 4'b0000;
    empty <= 4'b0000;


    #delay;
    iniciar <= 0;
    aFull <= 4'b0001;
    full <= 4'b0000;
    aEmpty <= 4'b0000;
    empty <= 4'b0000;


    #delay;
    iniciar <= 0;
    aFull <= 4'b0001;
    full <= 4'b0000;
    aEmpty <= 4'b0000;
    empty <= 4'b0000;


    #delay;
    iniciar <= 0;
    aFull <= 4'b0000;
    full <= 4'b0001;
    aEmpty <= 4'b0000;
    empty <= 4'b0000;


    #delay;
    iniciar <= 0;
    aFull <= 4'b0000;
    full <= 4'b0001;
    aEmpty <= 4'b0000;
    empty <= 4'b0000;


    reset = 1;
    #delay;
    iniciar <= 0;
    aFull <= 4'b0000;
    full <= 4'b0000;
    aEmpty <= 4'b0000;
    empty <= 4'b0000;

    reset = 0;

    #delay;
    iniciar <= 1;
    aFull <= 4'b0000;
    full <= 4'b0000;
    aEmpty <= 4'b0000;
    empty <= 4'b0000;


    #delay;
    iniciar <= 0;
    aFull <= 4'b0000;
    full <= 4'b0000;
    aEmpty <= 4'b0000;
    empty <= 4'b0001;


    fsm.actual = 3'b100;
    fsmSynth.actual = 3'b100;
    #delay

    fsm.actual = 3'b010;
    fsmSynth.actual = 3'b010;
    #delay

    fsmSynth.actual = 3'b001;
    fsm.actual = 3'b001;
    #delay

    fsmSynth.actual = 3'b110;
    fsm.actual = 3'b110;
    #delay

    fsmSynth.actual = 3'b101;
    fsm.actual = 3'b101;
    #delay

    fsmSynth.actual = 3'b011;
    fsm.actual = 3'b011;
    #delay

    fsmSynth.actual = 3'b111;
    fsm.actual = 3'b111;
    #delay

    fsmSynth.actual = 3'b101;
    fsm.actual = 3'b101;
    #delay

    fsmSynth.actual = 3'b110;
    fsm.actual = 3'b110;
    #delay

    fsmSynth.actual = 3'b001;
    fsm.actual = 3'b001;
    #delay


    # 15 $finish;
  end
endmodule
