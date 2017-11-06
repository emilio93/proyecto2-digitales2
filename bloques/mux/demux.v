`timescale 1ns/1ps

`ifndef demux
`define demux

module demux #(parameter DATA_BITS = 4) (
  input enb,
  input [DATA_BITS -1:0] entrada_dmux,
  input [$clog2(DATA_BITS) -1:0] selector_dmux,
  output [DATA_BITS -1:0] salida0_dmux,
  output [DATA_BITS -1:0] salida1_dmux,
  output [DATA_BITS -1:0] salida2_dmux,
  output [DATA_BITS -1:0] salida3_dmux
);

  // Entradas
  wire enb;
  wire [DATA_BITS-1:0] entrada_dmux;
  wire [$clog2(DATA_BITS) -1:0] selector_dmux;

  // Salidas
  reg [DATA_BITS-1:0] salida0_dmux;
  reg [DATA_BITS-1:0] salida1_dmux;
  reg [DATA_BITS-1:0] salida2_dmux;
  reg [DATA_BITS-1:0] salida3_dmux;

  //Funcionamiento
  always @ ( * ) begin
		  salida0_dmux = 0;
		  salida1_dmux = 0;
		  salida2_dmux = 0;
		  salida3_dmux = 0;
	  if (enb) begin
		  case(selector_dmux)
			  2'b00 : salida0_dmux = entrada_dmux;
			  2'b01 : salida1_dmux = entrada_dmux;
			  2'b10 : salida2_dmux = entrada_dmux;
			  2'b11 : salida3_dmux = entrada_dmux;
		  endcase
	  end
end

endmodule // demux
`endif
