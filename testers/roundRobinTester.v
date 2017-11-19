`timescale 1ns/1ps

`ifndef isTest
  `include "../bloques/roundRobin/roundRobin.v"
  `include "../build/roundRobin-sintetizado.v"
`endif

`ifndef roundRobinTester
`define roundRobinTester

module roundRobinTester (
  input clk,
  input rst,
  input enb,
  input [QUEUE_QUANTITY-1:0] buf_empty,
  output [$clog2(QUEUE_QUANTITY)-1:0] selector,
  output selector_enb,
  output [$clog2(QUEUE_QUANTITY)-1:0] sint_selector,
  output sint_selector_enb
);
parameter QUEUE_QUANTITY = 4;
parameter DATA_BITS = 8;
wire data_out;
wire sint_data_out;

reg errSelector;
reg errSelector_enb;

always @ ( * ) begin
  errSelector_enb = sint_selector_enb != selector_enb;
  errSelector = sint_selector != selector;
end

roundRobin #(.QUEUE_QUANTITY(QUEUE_QUANTITY), .DATA_BITS(DATA_BITS)) roundRobinTest(
  .clk(clk), .rst(rst), .enb(enb),
  .buf_empty(buf_empty), // Selector de queue al cual entra el dato
  .selector(selector), // dato que entra al queue
  .selector_enb(selector_enb) // Salida de dato del roundRobin
);

roundRobinSynth roundRobinSynthTest(
  .clk(clk), .rst(rst), .enb(enb),
  .buf_empty(buf_empty), // Selector de queue al cual entra el dato
  .selector(sint_selector), // dato que entra al queue
  .selector_enb(sint_selector_enb) // Salida de dato del roundRobin
);

endmodule

`endif
