`timescale 1ns/1ps

`ifndef isTest
  `include "../bloques/roundRobin/roundRobinArbitrado.v"
  `include "../build/roundRobinArbitrado-sintetizado.v"
`endif

`ifndef roundRobinArbitradoTester
`define roundRobinArbitradoTester


module roundRobinArbitradoTester (
  input clk,
  input rst,
  input enb,
  input [((TABLE_SIZE)*($clog2(MAX_WEIGHT)))-1:0] pesos,
  input [(TABLE_SIZE)*$clog2(QUEUE_QUANTITY)-1:0] selecciones,
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
parameter TABLE_SIZE = 8;

reg errSelector;
reg errSelector_enb;
always @ ( * ) begin
  errSelector_enb = sint_selector_enb != selector_enb;
  errSelector = sint_selector != selector;
end

roundRobinArbitrado #(.QUEUE_QUANTITY(QUEUE_QUANTITY), .DATA_BITS(DATA_BITS)) test(
  .clk(clk), .rst(rst), .enb(enb),
  .pesos(pesos),
  .selecciones(selecciones),
  .buf_empty(buf_empty),
  .fifo_counter(fifo_counter),
  .selector(selector),
  .selector_enb(selector_enb)
);

roundRobinArbitradoSynth synthTest(
  .clk(clk), .rst(rst), .enb(enb),
  .pesos(pesos),
  .selecciones(selecciones),
  .buf_empty(buf_empty),
  .fifo_counter(fifo_counter),
  .selector(sint_selector),
  .selector_enb(sint_selector_enb)
);

endmodule

`endif
