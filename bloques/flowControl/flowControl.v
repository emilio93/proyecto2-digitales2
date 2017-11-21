`timescale 1ns/1ps

`ifndef fc
`define fc

module flowControl #(parameter FIFO_COUNT = 5) (
  input clk, rst, enb,
  input [FIFO_COUNT-1:0] almost_full_in,
  input [FIFO_COUNT-1:0] full_in,
  input [FIFO_COUNT-1:0] almost_empty_in,
  input [FIFO_COUNT-1:0] empty_in,
  input [FIFO_COUNT-2:0] continuar,//negado de pausa, sera enable de fifos
  output [FIFO_COUNT-2:0] cf, //continue fifo 
  output [FIFO_COUNT-1:0] almost_full_out,
  output [FIFO_COUNT-1:0] full_out,
  output [FIFO_COUNT-1:0] almost_empty_out,
  output [FIFO_COUNT-1:0] empty_out
);

  reg [3:0] cf;
  reg [4:0] almost_full_out;
  reg [4:0] full_out;
  reg [4:0] almost_empty_out;
  reg [4:0] empty_out;

  always @(*) begin
  almost_full_out = almost_full_in;
  full_out = full_in;
  almost_empty_out = almost_empty_in;
  empty_out = empty_in;
  cf = continuar;
  end
endmodule
`endif
