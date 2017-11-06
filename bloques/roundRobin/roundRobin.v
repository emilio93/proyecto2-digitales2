`timescale 1ns/1ps

`ifndef roundRobin
`define roundRobin

// Implementacion de fila roundRobin
module roundRobin #(parameter QUEUE_QUANTITY = 4, parameter DATA_BITS = 8) (
  input clk,
  input rst,
  input enb,
  input [QUEUE_QUANTITY-1:0] buf_empty, // indicadores de buf empty en el fifo, uno por cada QUEUE que exista.
  output [$clog2(QUEUE_QUANTITY)-1:0] selector, // Selector de dato del roundRobin.
  output selector_enb // Indica si existe un valor de salida.
);

  // Entradas
  wire clk, rst, enb;
  wire [QUEUE_QUANTITY-1:0] buf_empty;

  // Estados
  reg [$clog2(QUEUE_QUANTITY)-1:0] contador;
  reg enable_toggle;
  reg selector_enb;

  // Salidas
  reg [$clog2(QUEUE_QUANTITY)-1:0] selector;
  reg out_enb;

  always @ ( * ) begin
    out_enb = !buf_empty[contador];
    {selector_enb, selector} = {1'b0, 2'b0};
    if (!buf_empty[contador]) {selector_enb, selector} = {1'b1, contador};
    else if (!buf_empty[contador+2'd1]) {selector_enb, selector} = {1'b1, contador+2'd1};
    else if (!buf_empty[contador+2'd2]) {selector_enb, selector} = {1'b1, contador+2'd2};
    else if (!buf_empty[contador+2'd3]) {selector_enb, selector} = {1'b1, contador+2'd3};
  end

  always @ (posedge clk) begin
    // En modo reset
    if (rst) begin
      contador <= 0 ;
    // Contando
    end else if (enb) begin
      contador <= !out_enb? selector + 1: contador < QUEUE_QUANTITY-1? contador + 1: 0;
    end
  end

endmodule // roundRobin
`endif
