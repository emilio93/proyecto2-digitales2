`timescale 1ns/1ps

module memorias #(
  parameter QUEUE_QUANTITY = 4,    // se utilizan 4 filas fifo
  parameter DATA_BITS = 8,         // Los datos son de 8 bits
  parameter BUF_WIDTH = 3,         // Los datos son de 8 bits
  parameter MAX_WEIGHT = 64,       // El peso máximo es de 64 = 2^6
  parameter TABLE_SIZE = 8,        // Tamaño de la tabla de arbitraje
  parameter MAX_MAG_UMBRAL = 8,    // Tamaño máximo de los umbrales
  parameter TIPOS_ROUND_ROBIN = 3, // Tamaño máximo de los umbrales
  parameter FIFO_COUNT = 5
)(
  // señales de control basico
  input clk, rst, enb,
  input iniciar, // strobe que indica la actualizacion de la memoria

  // señales de entrada
  input [$clog2(TIPOS_ROUND_ROBIN)-1:0] seleccion_roundRobin_in,
  input [QUEUE_QUANTITY*$clog2(MAX_WEIGHT)-1:0] pesos_in,
  input [TABLE_SIZE*$clog2(MAX_WEIGHT)-1:0] pesosArbitraje_in,
  input [TABLE_SIZE*$clog2(QUEUE_QUANTITY)-1:0] selecciones_in,

  // señales de salida
  output [$clog2(TIPOS_ROUND_ROBIN)-1:0] seleccion_roundRobin_out,
  output [QUEUE_QUANTITY*$clog2(MAX_WEIGHT)-1:0] pesos_out,
  output [TABLE_SIZE*$clog2(MAX_WEIGHT)-1:0] pesosArbitraje_out,
  output [TABLE_SIZE*$clog2(QUEUE_QUANTITY)-1:0] selecciones_out
);

  wire [$clog2(TIPOS_ROUND_ROBIN)-1:0] seleccion_roundRobin_in;
  wire [QUEUE_QUANTITY*$clog2(MAX_WEIGHT)-1:0] pesos_in;
  wire [TABLE_SIZE*$clog2(MAX_WEIGHT)-1:0] pesosArbitraje_in;
  wire [TABLE_SIZE*$clog2(QUEUE_QUANTITY)-1:0] selecciones_in;

  // memoria de selecciones
  //
  reg [$clog2(TIPOS_ROUND_ROBIN)-1:0] seleccion_roundRobin_out;
  reg [QUEUE_QUANTITY*$clog2(MAX_WEIGHT)-1:0] pesos_out;
  reg [TABLE_SIZE*$clog2(MAX_WEIGHT)-1:0] pesosArbitraje_out;
  reg [TABLE_SIZE*$clog2(QUEUE_QUANTITY)-1:0] selecciones_out;

  always @ (posedge clk) begin
    if (iniciar) begin
      seleccion_roundRobin_out <= seleccion_roundRobin_in;
      pesos_out <= pesos_in;
      pesosArbitraje_out <= pesosArbitraje_in;
      selecciones_out <= selecciones_in;
    end
  end

endmodule
