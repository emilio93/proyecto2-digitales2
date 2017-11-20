`timescale 1ns/1ps

`define isTest 1

`include "includes.v"
`include "../bloques/flowControl/flowControl.v"
`include "../build/flowControl-sintetizado.v"

module flowControl_test();

  // Entradas
  reg aff0;
  reg aff1;
  reg aff2;
  reg aff3;
  reg aff4;
  reg ff0;
  reg ff1;
  reg ff2;
  reg ff3;
  reg ff4;
  reg aef0;
  reg aef1;
  reg aef2;
  reg aef3;
  reg aef4;
  reg ef0;
  reg ef1;
  reg ef2;
  reg ef3;
  reg ef4;
  reg clk;
  reg [3:0] continuar;//negado de pausa; sera enable de fifos

  //Salidas
  wire [4:0] afull;//5 fifos
  wire [4:0] full;
  wire [4:0] aempty;
  wire [4:0] empty;
  wire [3:0] cf;

  wire [4:0] afullSynth;//5 fifos
  wire [4:0] fullSynth;
  wire [4:0] aemptySynth;
  wire [4:0] emptySynth;
  wire [3:0] cfSynth;

  flowControl fc(
   .aff0(aff0),
   .aff1(aff1),
   .aff2(aff2),
   .aff3(aff3),
   .aff4(aff4),
   .ff0(ff0),
   .ff1(ff1),
   .ff2(ff2),
   .ff3(ff3),
   .ff4(ff4),
   .aef0(aef0),
   .aef1(aef1),
   .aef2(aef2),
   .aef3(aef3),
   .aef4(aef4),
   .ef0(ef0),
   .ef1(ef1),
   .ef2(ef2),
   .ef3(ef3),
   .ef4(ef4),
   .clk(clk),
   .continuar(continuar),//negado de pausa(), sera enable de fifos
   .cf(cf),
   .almost_full(afull),
   .full(full),
   .almost_empty(aempty),
   .empty(empty)
  );

  flowControlSynth fcSynth(
   .aff0(aff0),
   .aff1(aff1),
   .aff2(aff2),
   .aff3(aff3),
   .aff4(aff4),
   .ff0(ff0),
   .ff1(ff1),
   .ff2(ff2),
   .ff3(ff3),
   .ff4(ff4),
   .aef0(aef0),
   .aef1(aef1),
   .aef2(aef2),
   .aef3(aef3),
   .aef4(aef4),
   .ef0(ef0),
   .ef1(ef1),
   .ef2(ef2),
   .ef3(ef3),
   .ef4(ef4),
   .clk(clk),
   .continuar(continuar),//negado de pausa(), sera enable de fifos
   .cf(cfSynth),
   .almost_full(afullSynth),
   .full(fullSynth),
   .almost_empty(aemptySynth),
   .empty(emptySynth)
  );


  always # 5 clk = ~clk;

  initial
  begin
    $dumpfile("gtkws/flowControl_test.vcd");
    $dumpvars();
    $display("fc_test");

	aff0  = 0;
	aff1  <= 0;
	aff2  <= 0;
	aff3  <= 0;
	aff4  <= 0;
	ff0  <= 0;
	ff1  <= 0;
	ff2  <= 0;
	ff3  <= 0;
	ff4  <= 0;
	aef0  <= 0;
	aef1  <= 0;
	aef2  <= 0;
	aef3  <= 0;
	aef4  <= 0;
	ef0  <= 1;
	ef1  <= 1;
	ef2  <= 1;
	ef3  <= 1;
	ef4  <= 1;
	continuar  <= 4'b1111;

    clk <= 0;
    # 10; @(posedge clk)


	aff0  = 0;
	aff1  <= 0;
	aff2  <= 0;
	aff3  <= 0;
	aff4  <= 0;
	ff0  <= 0;
	ff1  <= 0;
	ff2  <= 0;
	ff3  <= 0;
	ff4  <= 0;
	aef0  <= 0;
	aef1  <= 0;
	aef2  <= 0;
	aef3  <= 0;
	aef4  <= 0;
	ef0  <= 1;
	ef1  <= 1;
	ef2  <= 1;
	ef3  <= 1;
	ef4  <= 1;
	continuar  <= 4'b1111;
    # 10; @(posedge clk)


	aff0  = 0;
	aff1  <= 0;
	aff2  <= 0;
	aff3  <= 0;
	aff4  <= 0;
	ff0  <= 0;
	ff1  <= 0;
	ff2  <= 0;
	ff3  <= 0;
	ff4  <= 0;
	aef0  <= 0;
	aef1  <= 0;
	aef2  <= 0;
	aef3  <= 0;
	aef4  <= 0;
	ef0  <= 1;
	ef1  <= 1;
	ef2  <= 1;
	ef3  <= 1;
	ef4  <= 1;
	continuar  <= 4'b1111;
  # 10; @(posedge clk)


	aff0  = 0;
	aff1  <= 0;
	aff2  <= 0;
	aff3  <= 0;
	aff4  <= 0;
	ff0  <= 0;
	ff1  <= 0;
	ff2  <= 0;
	ff3  <= 0;
	ff4  <= 0;
	aef0  <= 1;
	aef1  <= 1;
	aef2  <= 1;
	aef3  <= 1;
	aef4  <= 1;
	ef0  <= 0;
	ef1  <= 0;
	ef2  <= 0;
	ef3  <= 0;
	ef4  <= 0;
	continuar  <= 4'b1111;
  # 10; @(posedge clk)


	aff0  = 1;
	aff1  <= 1;
	aff2  <= 1;
	aff3  <= 1;
	aff4  <= 1;
	ff0  <= 0;
	ff1  <= 0;
	ff2  <= 0;
	ff3  <= 0;
	ff4  <= 0;
	aef0  <= 0;
	aef1  <= 0;
	aef2  <= 0;
	aef3  <= 0;
	aef4  <= 0;
	ef0  <= 0;
	ef1  <= 0;
	ef2  <= 0;
	ef3  <= 0;
	ef4  <= 0;
	continuar  <= 4'b1111;
  # 10; @(posedge clk)


	aff0  = 1;
	aff1  <= 0;
	aff2  <= 0;
	aff3  <= 0;
	aff4  <= 0;
	ff0  <= 0;
	ff1  <= 1;
	ff2  <= 1;
	ff3  <= 1;
	ff4  <= 1;
	aef0  <= 0;
	aef1  <= 0;
	aef2  <= 0;
	aef3  <= 0;
	aef4  <= 0;
	ef0  <= 0;
	ef1  <= 0;
	ef2  <= 0;
	ef3  <= 0;
	ef4  <= 0;
	continuar  <= 4'b0001;
  # 10; @(posedge clk)


  # 50 $finish;
  end
endmodule
