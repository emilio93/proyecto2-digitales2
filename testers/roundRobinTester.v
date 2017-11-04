`timescale 1ns/1ps


`ifndef roundRobinTester
`define roundRobinTester

module roundRobinTester (
  input clk,
  input rst,
  input enb,
  input [QUEUE_QUANTITY-1:0] buf_empty,
  output [$clog2(QUEUE_QUANTITY)-1:0] selector,
  output out_enb,
  output [$clog2(QUEUE_QUANTITY)-1:0] sint_selector,
  output sint_out_enb
);
parameter QUEUE_QUANTITY = 4;
parameter DATA_BITS = 8;
wire data_out;
wire sint_data_out;

roundRobin #(.QUEUE_QUANTITY(QUEUE_QUANTITY), .DATA_BITS(DATA_BITS)) roundRobinTest(
  .clk(clk), .rst(rst), .enb(enb),
  .buf_empty(buf_empty), // Selector de queue al cual entra el dato
  .selector(selector), // dato que entra al queue
  .out_enb(out_enb) // Salida de dato del roundRobin
);

roundRobinSynth #(.QUEUE_QUANTITY(QUEUE_QUANTITY), .DATA_BITS(DATA_BITS)) roundRobinSynthTest(
  .clk(clk), .rst(rst), .enb(enb),
  .buf_empty(buf_empty), // Selector de queue al cual entra el dato
  .selector(sint_selector), // dato que entra al queue
  .out_enb(sint_out_enb) // Salida de dato del roundRobin
);

endmodule

`endif
