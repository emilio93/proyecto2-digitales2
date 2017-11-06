`timescale 1ns/1ps

`define isTest 1

`include "../lib/cmos_cells.v"
`include "../bloques/roundRobin/roundRobin.v"
`include "../build/roundRobin-sintetizado.v"
`include "../testers/roundRobinTester.v"

module roundRobin_test #(parameter QUEUE_QUANTITY = 4, parameter DATA_BITS = 8);

  reg clk, rst, enb;
  reg [QUEUE_QUANTITY-1:0] buf_empty;
  reg [QUEUE_QUANTITY-1:0] almost_empty;
  wire [$clog2(QUEUE_QUANTITY)-1:0] selector;
  wire [$clog2(QUEUE_QUANTITY)-1:0] sint_selector;
  wire selector_enb;
  wire sint_selector_enb;

  roundRobinTester roundRobinTester(
    .clk(clk), .rst(rst), .enb(enb),
    .buf_empty(buf_empty),
    .selector(selector),
    .selector_enb(selector_enb),
    .sint_selector(sint_selector),
    .sint_selector_enb(sint_selector_enb)
  );

  always # 5 clk = ~clk;

  initial
  begin
    $dumpfile("gtkws/roundRobin_test.vcd");
    $dumpvars();

    clk <= 0;
    rst <= 1;
    enb <= 1;
    buf_empty <= 4'b0000;

    # 15
    @(posedge clk) rst <= 0;

    # 40
    @(posedge clk) buf_empty[0] <= 1; buf_empty[1] <= 1;
    @(posedge clk) buf_empty[0] <= 0; buf_empty[1] <= 0;

    # 40
    @(posedge clk) buf_empty[0] <= 1; buf_empty[1] <= 1; buf_empty[2] <= 1; buf_empty[3] <= 1;
    @(posedge clk) buf_empty[0] <= 0; buf_empty[1] <= 0; buf_empty[2] <= 0; buf_empty[3] <= 0;

    # 30
    @(posedge clk) almost_empty[0] <= 1;
    @(posedge clk) almost_empty[0] <= 0;

    # 60
    @(posedge clk) buf_empty[2'b11] <= 1;
    @(posedge clk) buf_empty[2'b11] <= 0;

    # 20
    @(posedge clk) buf_empty[2'b10] <= 1;
    @(posedge clk) buf_empty[2'b10] <= 0;

    # 40
    @(posedge clk) buf_empty[2] <= 0;


    # 15 $finish;
  end
endmodule
