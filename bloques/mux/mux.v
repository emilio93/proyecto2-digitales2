`timescale 1ns/1ps

`ifndef mux
`define mux

module mux #(parameter DATA_WIDTH = 4) (
  input enb,
  input [DATA_WIDTH -1:0] entrada0_mux,
  input [DATA_WIDTH -1:0] entrada1_mux,
  input [DATA_WIDTH -1:0] entrada2_mux,
  input [DATA_WIDTH -1:0] entrada3_mux,
  input [$clog2(DATA_WIDTH) -1:0] selector_mux,
  output [DATA_WIDTH -1:0] salida_mux
);

  // Entradas
  wire enb;
  wire [DATA_WIDTH-1:0] entrada0_mux;
  wire [DATA_WIDTH-1:0] entrada1_mux;
  wire [DATA_WIDTH-1:0] entrada2_mux;
  wire [DATA_WIDTH-1:0] entrada3_mux;
  wire [$clog2(DATA_WIDTH) -1:0] selector_mux;

  // Salidas
  reg [DATA_WIDTH-1:0] salida_mux;

  //Funcionamiento
  always @ ( * ) begin
    if (enb) begin
	    case(selector_mux)
		    2'b00 : salida_mux = entrada0_mux;
		    2'b01 : salida_mux = entrada1_mux;
		    2'b10 : salida_mux = entrada2_mux;
		    2'b11 : salida_mux = entrada3_mux;
	    endcase
    end
	    else salida_mux = 0;
    end

endmodule // mux
`endif
