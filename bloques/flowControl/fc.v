`timescale 1ns/1ps

`ifndef fc
`define fc


module fc(
  input aff0,
  input aff1,
  input aff2,
  input aff3,
  input aff4,
  input ff0,
  input ff1,
  input ff2,
  input ff3,
  input ff4,
  input aef0,
  input aef1,
  input aef2,
  input aef3,
  input aef4,
  input ef0,
  input ef1,
  input ef2,
  input ef3,
  input clk,
  input [3:0] continuar,//negado de pausa, sera enable de fifos
  output [3:0] cf,
//  output cf0
//  output cf1,
//  output cf2,
//  output cf3,
  output [4:0] almost_full,
  output [4:0] full,
  output [4:0] almost_empty,
  output [4:0] empty
);

	  // Entradas
  wire aff0;
  wire aff1;
  wire aff2;
  wire aff3;
  wire aff4;
  wire ff0;
  wire ff1;
  wire ff2;
  wire ff3;
  wire ff4;
  wire aef0;
  wire aef1;
  wire aef2;
  wire aef3;
  wire aef4;
  wire ef0;
  wire ef1;
  wire ef2;
  wire ef3;
  wire ef4;
  wire clk;
  wire [3:0] continue;//negado de pausa; sera enable de fifos
 
  //Salidas
  reg [4:0] almost_full;//5 fifos
  reg [4:0] full;
  reg [4:0] almost_empty;
  reg [4:0] empty;
  reg [3:0] cf;
//  reg cf1;
//  reg cf2;
//  reg cf3;

  always @(posedge clk)begin
	almost_full[0] <= aff0;
	almost_full[1] <= aff1;
	almost_full[2] <= aff2;
	almost_full[3] <= aff3;
	almost_full[4] <= aff4;
	full[0] <= ff0;
	full[1] <= ff1;
	full[2] <= ff2;
	full[3] <= ff3;
	full[4] <= ff4;
	almost_empty[0] <= aef0;
	almost_empty[1] <= aef1;
	almost_empty[2] <= aef2;
	almost_empty[3] <= aef3;
	almost_empty[4] <= aef4;
	empty[0] <= ef0; 
	empty[1] <= ef1;
	empty[2] <= ef2;
	empty[3] <= ef3;
	empty[4] <= ef4;
	cf[0] <= continue[0];
	cf[1] <= continue[1];
	cf[2] <= continue[2];
	cf[3] <= continue[3];

  end



endmodule
`endif 
