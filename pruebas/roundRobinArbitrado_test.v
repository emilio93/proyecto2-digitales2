`timescale 1ns/1ps

`define isTest 1

`include "../lib/osu018_stdcells.v"
`include "../bloques/roundRobin/roundRobinArbitrado.v"
`include "../build/roundRobinArbitrado-sintetizado.v"
`include "../testers/roundRobinArbitradoTester.v"

module roundRobinArbitrado_test #(parameter QUEUE_QUANTITY = 4, parameter DATA_BITS = 8, MAX_WEIGHT=64, BUF_WIDTH=3, TABLE_SIZE=8);
  reg clk, rst, enb;
  reg [((TABLE_SIZE)*($clog2(MAX_WEIGHT)))-1:0] pesos;
  reg [(TABLE_SIZE)*$clog2(QUEUE_QUANTITY)-1:0] selecciones;
  reg [QUEUE_QUANTITY-1:0] buf_empty;
  reg [QUEUE_QUANTITY*BUF_WIDTH-1:0] fifo_counter;
  wire [$clog2(QUEUE_QUANTITY)-1:0] selector;
  wire [$clog2(QUEUE_QUANTITY)-1:0] sint_selector;
  wire selector_enb;
  wire sint_selector_enb;

  roundRobinArbitradoTester rrpTester(
    .clk(clk), .rst(rst), .enb(enb),
    .pesos(pesos),
    .selecciones(selecciones),
    .buf_empty(buf_empty),
    .fifo_counter(fifo_counter),
    .selector(selector),
    .selector_enb(selector_enb),
    .sint_selector(sint_selector),
    .sint_selector_enb(sint_selector_enb)
  );

  always # 5 clk <= ~clk;

  initial
  begin
    $dumpfile("gtkws/roundRobinArbitrado_test.vcd");
    $dumpvars();

    clk <= 0;
    rst <= 1;
    enb <= 1;
    buf_empty <= 8'b00000000;
    fifo_counter <= {4'b1000, 4'b1000, 4'b1000, 4'b1000};
    pesos <= {6'b110, 6'b11, 6'b10, 6'b1};
    selecciones <= {2'b10, 2'b11, 2'b10, 2'b01, 2'b00, 2'b10, 2'b11, 2'b11};

    # 40
    @(posedge clk) rst <= 0;

    # 40
    @(posedge clk) buf_empty[0] <= 0;

    # 40
    @(posedge clk) buf_empty[0] <= 0; buf_empty[1] <= 0; buf_empty[2] <= 0; buf_empty[3] <= 0;

    # 20
    @(posedge clk) buf_empty[2] <= 0; buf_empty[3] <= 0;


    # 450 $finish;
  end
endmodule
