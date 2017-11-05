`timescale 1ns/1ps

`ifndef mux
`define mux

module mux #(parameter DATA_BITS = 4) (
  input enb,
  input [DATA_BITS -1:0] entrada0,
  input [DATA_BITS -1:0] entrada1,
  input [DATA_BITS -1:0] entrada2,
  input [DATA_BITS -1:0] entrada3,
  input [$clog2(DATA_BITS) -1:0] selector,
  output [DATA_BITS -1:0] salida
);

  // Entradas
  wire enb;
  wire [DATA_BITS-1:0] entrada0;
  wire [DATA_BITS-1:0] entrada1;
  wire [DATA_BITS-1:0] entrada2;
  wire [DATA_BITS-1:0] entrada3;
  wire [$clog2(DATA_BITS) -1:0] selector;

  // Salidas
  reg [DATA_BITS-1:0] salida;

  parameter s0 = 2'b00,
	    s1 = 2'b01,
	    s2 = 2'b10,
	    s3 = 2'b11;

  //Funcionamiento
  always @ ( * ) begin
//	  case(selector)
//if(enb) begin
	if(selector == s0) salida = entrada0;
	else
//		else salida = 0;
        if(selector == s1) salida = entrada1;
	else
//		else salida = 0;
	if(selector == s2) salida = entrada2;
	else
//		else salida = 0;
	if(selector == s3) salida = entrada3;
		else salida = 0;
//	default : salida <= 0;
//	endcase
//	end
//	else
//		salida <= 0;

  end

endmodule // mux
`endif
