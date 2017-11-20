`timescale 1ns/1ps

`define isTest 1

`include "includes.v"
`include "../bloques/roundRobin/interfazRoundRobin.v"
`include "../build/interfazRoundRobin-sintetizado.v"

`include "../testers/interfazRoundRobinTester.v"

// `include "../bloques/roundRobin/roundRobin.v"
// `include "../build/roundRobin-sintetizado.v"
//
// `include "../bloques/roundRobin/roundRobinPesado.v"
// `include "../build/roundRobinPesado-sintetizado.v"
//
// `include "../bloques/roundRobin/roundRobinArbitrado.v"
// `include "../build/roundRobinArbitrado-sintetizado.v"

module interfazRoundRobin_test #(parameter QUEUE_QUANTITY = 4, parameter DATA_BITS = 8, MAX_WEIGHT=64, BUF_WIDTH=3, TABLE_SIZE=8);
  reg clk, rst, enb;
  reg [$clog2(QUEUE_QUANTITY)-1:0] seleccion_roundRobin;
  reg [((QUEUE_QUANTITY)*($clog2(MAX_WEIGHT)))-1:0] pesos;
  reg [((TABLE_SIZE)*($clog2(MAX_WEIGHT)))-1:0] pesosArbitraje;
  reg [(TABLE_SIZE)*$clog2(QUEUE_QUANTITY)-1:0] selecciones;
  reg [QUEUE_QUANTITY-1:0] buf_empty;
  wire [$clog2(QUEUE_QUANTITY)-1:0] selector;
  wire [$clog2(QUEUE_QUANTITY)-1:0] sint_selector;
  wire selector_enb;
  wire sint_selector_enb;

  interfazRoundRobinTester rrTester(
    .clk(clk), .rst(rst), .enb(enb),
    .seleccion_roundRobin(seleccion_roundRobin),
    .pesos(pesos),
    .pesosArbitraje(pesosArbitraje),
    .selecciones(selecciones),
    .buf_empty(buf_empty),
    .selector(selector),
    .selector_enb(selector_enb),
    .sint_selector(sint_selector),
    .sint_selector_enb(sint_selector_enb)
  );

  always # 5 clk <= ~clk;

  initial
  begin
    $dumpfile("gtkws/interfazRoundRobin_test.vcd");
    $dumpvars();

    clk <= 0;
    rst <= 1;
    enb <= 1;
    buf_empty <= 8'b00000000;
    seleccion_roundRobin <= 2'b11;
    pesos <= {6'b10, 6'b111, 6'b101, 6'b110};
    selecciones <= {2'b10, 2'b00, 2'b10, 2'b01, 2'b00, 2'b10, 2'b01, 2'b11};

    # 40
    @(posedge clk) rst <= 0;

    # 1000
    @(posedge clk)
    selecciones <= {2'b10, 2'b11, 2'b10, 2'b01, 2'b00, 2'b10, 2'b01, 2'b11};
    pesos <= {6'b1, 6'b1, 6'b1, 6'b1, 6'b1, 6'b1, 6'b1, 6'b1};

    # 40
    @(posedge clk) rst <= 1;
    pesosArbitraje <= {6'b1110, 6'b101, 6'b101, 6'b11, 6'b1111, 6'b1011, 6'b1011, 6'b110};
    # 40
    @(posedge clk) rst <= 0;
    # 100
    @(posedge clk)
    enb <= 0;

    # 100
    @(posedge clk)
    enb <= 1;

    # 100
    @(posedge clk)
    seleccion_roundRobin <= 2'b01;
    pesos <= {6'b100, 6'b10, 6'b11, 6'b101, 6'b1000, 6'b1, 6'b111, 6'b10};

    # 750
    @(posedge clk)
    seleccion_roundRobin <= 2'b10;
    pesos <= {6'b100, 6'b10, 6'b11, 6'b101, 6'b1000, 6'b1, 6'b111, 6'b10};

    # 2000
    @(posedge clk)
    selecciones <= {2'b1, 2'b10, 2'b0, 2'b01, 2'b00, 2'b11, 2'b10, 2'b11};
    pesosArbitraje <= {6'b100, 6'b1000, 6'b100, 6'b1000, 6'b100, 6'b1000, 6'b100, 6'b1000};

    # 2000 $finish;
  end
endmodule
