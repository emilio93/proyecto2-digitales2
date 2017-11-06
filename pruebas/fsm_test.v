`timescale 1ns/1ps

`define isTest 1

`include "../lib/cmos_cells.v"
`include "../bloques/flowControl/fsm.v"
`include "../build/fsm-sintetizado.v"

module fsm_test();

  reg clk, reset, aFull, full , aEmpty, empty, iniciar;
  wire continuar, error, pausa, idle;
  wire continuarSynth, errorSynth, pausaSynth, idleSynth;

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
    aFull <= 0;
    full <= 0;
    aEmpty <= 1;
    empty <= 0;
    full <= 0;

    #delay;

    #delay;

    iniciar <= 0;
    aFull <= 0;
    full <= 0;
    aEmpty <= 0;
    empty <= 0;
    reset <= 0;

    #delay;
    reset <= 0;

    #delay;
    iniciar <= 1;
    aFull <= 0;
    full <= 0;
    aEmpty <= 0;
    empty <= 0;
    reset <= 0;


    #delay;
    iniciar <= 0;
    aFull <= 0;
    full <= 0;
    aEmpty <= 0;
    empty <= 0;
    reset <= 0;

    #delay;
    iniciar <= 0;
    aFull <= 1;
    full <= 0;
    aEmpty <= 0;
    empty <= 0;
    reset <= 0;

    #delay;
    iniciar <= 0;
    aFull <= 0;
    full <= 1;
    aEmpty <= 0;
    empty <= 0;
    reset <= 0;

    #delay;
    iniciar <= 0;
    aFull <= 0;
    full <= 0;
    aEmpty <= 0;
    empty <= 0;
    reset <= 1;

    #delay;
    iniciar <= 0;
    aFull <= 0;
    full <= 0;
    aEmpty <= 0;
    empty <= 0;
    reset <= 0;

    #delay;
    iniciar <= 0;
    aFull <= 0;
    full <= 0;
    aEmpty <= 0;
    empty <= 0;
    reset <= 0;

    #delay;
    iniciar <= 0;
    aFull <= 1;
    full <= 0;
    aEmpty <= 0;
    empty <= 0;
    reset <= 0;

    #delay;
    iniciar <= 0;
    aFull <= 0;
    full <= 1;
    aEmpty <= 0;
    empty <= 0;
    reset <= 0;


    # 15 $finish;
  end
endmodule
