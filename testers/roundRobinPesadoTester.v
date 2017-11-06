`timescale 1ns/1ps

`ifndef isTest
  `include "../bloques/roundRobin/roundRobinPesado.v"
  `include "../build/roundRobinPesado-sintetizado.v"
`endif

`ifndef roundRobinPesadoTester
`define roundRobinPesadoTester


module roundRobinPesadoTester (
  input clk,
  input rst,
  input enb,
  input [QUEUE_QUANTITY*$clog2(MAX_WEIGHT)-1:0] pesos,
  input [QUEUE_QUANTITY-1:0] buf_empty,
  input [QUEUE_QUANTITY*BUF_WIDTH-1:0] fifo_counter,
  output [$clog2(QUEUE_QUANTITY)-1:0] selector,
  output selector_enb,
  output [$clog2(QUEUE_QUANTITY)-1:0] sint_selector,
  output sint_selector_enb
);

parameter QUEUE_QUANTITY = 4;
parameter DATA_BITS = 8;
parameter BUF_WIDTH  = 3;
parameter MAX_WEIGHT = 64;

reg errSelector;
reg errSelector_enb;
always @ ( * ) begin
  errSelector_enb = sint_selector_enb != selector_enb;
  errSelector = sint_selector != selector;
end

roundRobinPesado #(.QUEUE_QUANTITY(QUEUE_QUANTITY), .DATA_BITS(DATA_BITS)) test(
  .clk(clk), .rst(rst), .enb(enb),
  .pesos(pesos),
  .buf_empty(buf_empty),
  .fifo_counter(fifo_counter),
  .selector(selector),
  .selector_enb(selector_enb)
);

roundRobinPesadoSynth synthTest(
  .clk(clk), .rst(rst), .enb(enb),
  .pesos(pesos),
  .buf_empty(buf_empty),
  .fifo_counter(fifo_counter),
  .selector(sint_selector),
  .selector_enb(sint_selector_enb)
);

endmodule

`endif
