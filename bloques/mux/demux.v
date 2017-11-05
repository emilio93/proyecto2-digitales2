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

  parameter s0 = 2'b00,
            s1 = 2'b01,
            s2 = 2'b10,
            s3 = 2'b11;

  //Funcionamiento
  always @ ( * ) begin
	  if (enb) begin
		  if (selector == s0 ) salida0 = entrada; 
		  else if (selector == s1 ) salida1 = entrada; 
		  else if (selector == s2 ) salida2 = entrada;
		  else salida3 = entrada;
	  end
	  else begin
			salida0 = 0;
			salida1 = 0;
		      	salida2 = 0;
		      	salida3 = 0;
		end
  end

endmodule // demux
`endif           



/*		NO FUNCIONAN ESTOS CASES
*		
  //Funcionamiento
  always @ ( * ) begin
	  if (enb) begin
          case(selector)
        s0 : salida0 = entrada;
        s1 : salida1 = entrada;
	s2 : salida2 = entrada;        
	s3 : salida3 = entrada;
	default: begin
		       	salida0 = 0;
			salida1 = 0;
		      	salida2 = 0;
		      	salida3 = 0;
	end
	endcase
	end

  end

*/
