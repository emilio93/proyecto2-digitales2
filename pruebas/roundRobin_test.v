`timescale 1ns/1ps

`include "../lib/cmos_cells.v"
`include "../bloques/roundRobin/roundRobin.v"
`include "../build/roundRobin-sintetizado.v"
`include "../testers/roundRobinTester.v"

module roundRobin_test #(parameter QUEUE_QUANTITY = 4, parameter DATA_BITS = 8);

  reg clk, rst, enb;
  reg [QUEUE_QUANTITY-1:0] buf_empty;
  wire [1:0]selector;
  wire [1:0]sint_selector;
  wire out_enb;
  wire sint_out_enb;

  roundRobinTester roundRobinTester(
    .clk(clk), .rst(rst), .enb(enb),
    .buf_empty(buf_empty),
    .selector(selector),
    .out_enb(out_enb),
    .sint_selector(sint_selector),
    .sint_out_enb(sint_out_enb)
  );

  always # 5 clk = ~clk;

  initial
  begin
    $dumpfile("gtkws/roundRobin_test.vcd");
    $dumpvars();
    $display("roundRobin_test");

    clk <= 0;
    rst <= 1;
    enb <= 1;
    buf_empty <= 4'b0000;

    # 15
    @(posedge clk) rst = 0;

    # 40
    @(posedge clk) buf_empty[0] <= 1;

    # 40
    @(posedge clk) buf_empty[0] <= 0;

    # 40
    @(posedge clk) buf_empty[2] <= 0;


    # 15 $finish;
  end
endmodule
