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
  input clk, rst, enb
);
endmodule
