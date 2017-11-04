`timescale 1ns/1ps

`ifndef roundRobin
`define roundRobin

// Implementacion de fila roundRobin
module roundRobin #(parameter QUEUE_QUANTITY = 4, parameter DATA_BITS = 8) (
  input clk,
  input rst,
  input enb,
  input [QUEUE_QUANTITY-1:0] buf_empty, // indicadores de buf empty en el fifo
  output [$clog2(QUEUE_QUANTITY)-1:0] selector, // Selector de dato del roundRobin
  output out_enb // Indica si exista un valor de salida
);

  // Entradas
  wire clk, rst, enb;
  wire [QUEUE_QUANTITY-1:0] buf_empty;

  // Estados
  reg [$clog2(QUEUE_QUANTITY)-1:0] contador;

  // Salidas
  reg [$clog2(QUEUE_QUANTITY)-1:0] selector;
  reg out_enb;

  // En modo reset
  always @ (posedge clk) begin
    if (rst) begin
      contador <= 0-1;
    end else if (enb) begin
      contador <= contador < QUEUE_QUANTITY-1? contador + 1: 0;
    end
  end

  genvar i;
  generate
    for (i = 0; i < QUEUE_QUANTITY ; i = i + 1) begin
      always @(posedge clk) begin
        if (enb) begin
          if (buf_empty[i]) begin
            out_enb <= 0;
          end else if (contador == i && !buf_empty[i]) begin
            selector <= contador;
            out_enb <= 1;
          end
        end
      end
    end
  endgenerate

endmodule // roundRobin
`endif
