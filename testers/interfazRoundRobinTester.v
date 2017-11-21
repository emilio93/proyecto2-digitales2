`timescale 1ns/1ps

`ifndef isTest
  `include "../bloques/roundRobin/interfazRoundRobin.v"
  `include "../build/roundRobinArbitrado-sintetizado.v"
  `include "../bloques/roundRobin/roundRobin.v"
  `include "../bloques/roundRobin/roundRobin-sintetizado.v"
  `include "../bloques/roundRobin/roundRobinPesado.v"
  `include "../bloques/roundRobin/roundRobinPesado-sintetizado.v"
  `include "../bloques/roundRobin/roundRobinArbitrado.v"
  `include "../bloques/roundRobin/roundRobinArbitrado-sintetizado.v"
`endif

`ifndef interfazRoundRobinTester
`define interfazRoundRobinTester


module interfazRoundRobinTester (
  input clk,
  input rst,
  input enb,
  input [$clog2(QUEUE_QUANTITY)-1:0] seleccion_roundRobin,
  input [((QUEUE_QUANTITY)*($clog2(MAX_WEIGHT)))-1:0] pesos,
  input [((TABLE_SIZE)*($clog2(MAX_WEIGHT)))-1:0] pesosArbitraje,
  input [(TABLE_SIZE)*$clog2(QUEUE_QUANTITY)-1:0] selecciones,
  input [QUEUE_QUANTITY-1:0] buf_empty,
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

interfazRoundRobin #(.QUEUE_QUANTITY(QUEUE_QUANTITY), .DATA_BITS(DATA_BITS)) test(
  .clk(clk), .rst(rst), .enb(enb),
  .seleccion_roundRobin(seleccion_roundRobin),
  .pesos(pesos),
  .pesosArbitraje(pesosArbitraje),
  .selecciones(selecciones),
  .buf_empty(buf_empty),
  .selector(selector),
  .selector_enb(selector_enb)
);

interfazRoundRobinSynth synthTest(
  .clk(clk), .rst(rst), .enb(enb),
  .seleccion_roundRobin(seleccion_roundRobin),
  .pesos(pesos),
  .pesosArbitraje(pesosArbitraje),
  .selecciones(selecciones),
  .buf_empty(buf_empty),
  .selector(sint_selector),
  .selector_enb(sint_selector_enb)
);

endmodule

`endif
