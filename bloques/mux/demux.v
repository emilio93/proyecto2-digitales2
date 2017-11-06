`timescale 1ns/1ps

`ifndef demux
`define demux

module demux #(parameter DATA_BITS = 4) (
  input enb,
  input [DATA_BITS -1:0] entrada,
  input [$clog2(DATA_BITS) -1:0] selector,
  output [DATA_BITS -1:0] salida0,
  output [DATA_BITS -1:0] salida1,
  output [DATA_BITS -1:0] salida2,
  output [DATA_BITS -1:0] salida3
);

  // Entradas
  wire enb;
  wire [DATA_BITS-1:0] entrada;
  wire [$clog2(DATA_BITS) -1:0] selector;

  // Salidas
  reg [DATA_BITS-1:0] salida0;
  reg [DATA_BITS-1:0] salida1;
  reg [DATA_BITS-1:0] salida2;
  reg [DATA_BITS-1:0] salida3;

  //Funcionamiento
  always @ ( * ) begin
    salida0 = 0;
    salida1 = 0;
    salida2 = 0;
    salida3 = 0;
    if (enb) begin
      if (selector == 2'b00) salida0 = entrada;
      else if (selector == 2'b01) salida1 = entrada;
      else if (selector == 2'b10) salida2 = entrada;
      else salida3 = entrada;
    end
  end

endmodule // demux
`endif
