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

  //Funcionamiento
  always @ ( * ) begin
    if (enb) begin
	    case(selector)
		    2'b00 : salida = entrada0;
		    2'b01 : salida = entrada1;
		    2'b10 : salida = entrada2;
		    2'b11 : salida = entrada3;
	    endcase
    end
	    else salida = 0;
    end

endmodule // mux
`endif
