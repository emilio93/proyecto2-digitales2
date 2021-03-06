`timescale 1ns/1ps

`define isTest 1

`include "includes.v"
`include "../bloques/flowControl/fsm.v"
`include "../build/fsm-sintetizado.v"
`include "../testers/fsmTester.v"

module fsm_test();

  reg clk, rst, enb, iniciar_in;
  reg [4:0] almost_full_in;
  reg [4:0] full_in;
  reg [4:0] almost_empty_in;
  reg [4:0] empty_in;

  wire idleConduct;
  wire [3:0] pausaConduct;
  wire [3:0] continuarConduct;
  wire [3:0] errorConduct;

  wire idleSynth;
  wire [3:0] pausaSynth;
  wire [3:0] continuarSynth;
  wire [3:0] errorSynth;

  fsmTester fsmTester(
    .clk(clk), .rst(rst), .enb(enb),
    .iniciar_in(iniciar_in),
    .almost_full_in(almost_full_in),
    .full_in(full_in),
    .almost_empty_in(almost_empty_in),
    .empty_in(empty_in),
    .continuarConduct(continuarConduct),
    .errorConduct(errorConduct),
    .pausaConduct(pausaConduct),
    .idleConduct(idleConduct),
    .continuarSynth(continuarSynth),
    .errorSynth(errorSynth),
    .pausaSynth(pausaSynth),
    .idleSynth(idleSynth));

  always # 5 clk = ~clk;

  initial
  begin
    $dumpfile("gtkws/fsm_test.vcd");
    $dumpvars();
    $display("fsm_test");

    clk <= 0;
    rst <= 1;
    enb <= 1;

    iniciar_in <= 0;
    almost_full_in <= 4'b0000;
    full_in <= 4'b0000;
    almost_empty_in <= 4'b0000;
    empty_in <= 4'b1111;
    full_in <= 4'b0000;

    # 30
    @ (posedge clk);
    rst <= 0;

    # 60
    @ (posedge clk);
    iniciar_in <= 1;
    @ (posedge clk);
    iniciar_in <= 0;

    # 40
    empty_in <= 4'b0;

    # 30; @ (posedge clk);
    almost_empty_in <= 4'b1000;
    # 10; @ (posedge clk);
    almost_empty_in <= 4'b0100;
    # 10; @ (posedge clk);
    almost_empty_in <= 4'b0010;
    # 10; @ (posedge clk);
    almost_empty_in <= 4'b0001;
    # 10; @ (posedge clk);
    almost_empty_in <= 4'b0000;

    # 40; @ (posedge clk);
    almost_full_in <= 4'b1000;
    # 10; @ (posedge clk);
    almost_full_in <= 4'b0100;
    # 10; @ (posedge clk);
    almost_full_in <= 4'b0010;
    # 10; @ (posedge clk);
    almost_full_in <= 4'b0001;
    # 10; @ (posedge clk);
    almost_full_in <= 4'b0000;

    # 40; @ (posedge clk);
    full_in <= 4'b1000;
    # 10; @ (posedge clk);
    full_in <= 4'b1100;
    # 10; @ (posedge clk);
    full_in <= 4'b1110;
    # 10; @ (posedge clk);
    full_in <= 4'b1111;


    # 30; @ (posedge clk);
    full_in <= 4'b0000;

    # 10; @ (posedge clk);
    rst <= 1;
    # 10; @ (posedge clk);
    rst <= 0;

    # 30; @ (posedge clk);
    iniciar_in <= 1;
    # 10; @ (posedge clk);
    iniciar_in <= 0;

    # 50; $finish;
  end
endmodule
