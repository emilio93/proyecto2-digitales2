`timescale 1ns/1ps

`define isTest 1

`include "includes.v"
`include "../bloques/flowControl/flowControl.v"
`include "../build/flowControl-sintetizado.v"

module flowControl_test();
  parameter FIFO_COUNT = 5;
  reg clk, rst, enb;
  reg [FIFO_COUNT-1:0] almost_full_in;
  reg [FIFO_COUNT-1:0] full_in;
  reg [FIFO_COUNT-1:0] almost_empty_in;
  reg [FIFO_COUNT-1:0] empty_in;
  reg [FIFO_COUNT-2:0] continuar;//negado de pausa, sera enable de fifos

  wire [FIFO_COUNT-2:0] cf;
  wire [FIFO_COUNT-1:0] almost_full_out;
  wire [FIFO_COUNT-1:0] full_out;
  wire [FIFO_COUNT-1:0] almost_empty_out;
  wire [FIFO_COUNT-1:0] empty_out;

  wire [FIFO_COUNT-2:0] cfSynth;
  wire [FIFO_COUNT-1:0] almost_full_outSynth;
  wire [FIFO_COUNT-1:0] full_outSynth;
  wire [FIFO_COUNT-1:0] almost_empty_outSynth;
  wire [FIFO_COUNT-1:0] empty_outSynth;

  flowControl flowControl(
   .clk(clk), .rst(rst), .enb(enb),
   .almost_full_in(almost_full_in),
   .full_in(full_in),
   .almost_empty_in(almost_empty_in),
   .empty_in(empty_in),
   .continuar(continuar),//negado de pausa, sera enable de fifos
   .cf(cf),
   .almost_full_out(almost_full_out),
   .full_out(full_out),
   .almost_empty_out(almost_empty_out),
   .empty_out(empty_out)
  );

  flowControlSynth flowControlSynth(
    .clk(clk), .rst(rst), .enb(enb),
    .almost_full_in(almost_full_in),
    .full_in(full_in),
    .almost_empty_in(almost_empty_in),
    .empty_in(empty_in),
    .continuar(continuar),//negado de pausa, sera enable de fifos
    .cf(cfSynth),
    .almost_full_out(almost_full_outSynth),
    .full_out(full_outSynth),
    .almost_empty_out(almost_empty_outSynth),
    .empty_out(empty_outSynth)
  );

  reg error_cf;
  reg error_almost_full_out;
  reg error_full_out;
  reg error_almost_empty_out;
  reg error_empty_out;
  always @ ( * ) begin
  	error_cf = cf != cfSynth;
  	error_almost_full_out = almost_full_out != almost_full_outSynth;
  	error_full_out = full_out != full_outSynth;
  	error_almost_empty_out = almost_empty_out != almost_empty_outSynth;
  	error_empty_out = empty_out != empty_outSynth;
  end


  always # 5 clk = ~clk;

  initial
  begin
    $dumpfile("gtkws/flowControl_test.vcd");
    $dumpvars();

    clk <= 0;

    almost_full_in  = 5'b0;
    full_in  <= 5'b0;
    almost_empty_in <= 5'b0;
    empty_in <= 5'b0;
    continuar <= 4'b1111;

    # 10; @(posedge clk)
    almost_full_in  = 5'b0;
    full_in  <= 5'b0;
    almost_empty_in <= 5'b0;
    empty_in <= 5'b11111;
    continuar <= 4'b1111;

    # 10; @(posedge clk)
    almost_full_in  = 5'b0;
    full_in  <= 5'b0;
    almost_empty_in <= 5'b0;
    empty_in <= 5'b11111;
    continuar <= 4'b1111;

    # 10; @(posedge clk)
    almost_full_in  = 5'b0;
    full_in  <= 5'b0;
    almost_empty_in <= 5'b11111;
    empty_in <= 5'b0;
    continuar <= 4'b1111;
  	continuar  <= 4'b1111;

    # 10; @(posedge clk)
    almost_full_in  = 5'b0;
    full_in  <= 5'b0;
    almost_empty_in <= 5'b0;
    empty_in <= 5'b11111;
    continuar <= 4'b1111;

    # 10; @(posedge clk)
    almost_full_in  = 5'b0;
    full_in  <= 5'b11111;
    almost_empty_in <= 5'b0;
    empty_in <= 5'b0;
    continuar <= 4'b1111;

    # 10; @(posedge clk)
    almost_full_in  = 5'b11111;
    full_in  <= 5'b0;
    almost_empty_in <= 5'b0;
    empty_in <= 5'b0;
    continuar <= 4'b1111;

    # 50 $finish;
  end
endmodule
