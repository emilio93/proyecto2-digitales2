`timescale 1ns/1ps

`ifndef roundRobinPesado
`define roundRobinPesado

// Implementacion de fila roundRobin
module roundRobinPesado #(
  parameter QUEUE_QUANTITY = 4, // se utilizan 4 filas fifo
  parameter DATA_BITS = 8,      // Los datos son de 8 bits
  parameter BUF_WIDTH = 3,      // Los datos son de 8 bits
  parameter MAX_WEIGHT = 64     // El peso máximo es de 64 = 2^6
) (
  input clk,
  input rst,
  input enb,
  // peso de cada fifo
  // Para los parámetros: QUEUE_QUANTITY = 4, MAX_WEIGHT = 64
  // Se tienen de ((4)*(6)) = 24-1 = 23 a 0
  // Para utilizarse se debe seleccionar la n-esima porción requerida
  // pesos[((n+1)*$clog2(MAX_WEIGHT))-1:n*$clog2(MAX_WEIGHT)]
  input [((QUEUE_QUANTITY)*($clog2(MAX_WEIGHT)))-1:0] pesos,
  input [QUEUE_QUANTITY-1:0] buf_empty, // indicadores de buf empty en el fifo, uno por cada QUEUE que exista.
  output [$clog2(QUEUE_QUANTITY)-1:0] selector, // Selector de fifo del roundRobin.
  output selector_enb // Indica si existe un valor de salida.
);

  // Entradas
  wire clk, rst, enb;
  wire [QUEUE_QUANTITY-1:0] buf_empty;
  wire [QUEUE_QUANTITY-1:0] arreglo_pesos [$clog2(MAX_WEIGHT)-1:0];


  // Estados
  reg [$clog2(QUEUE_QUANTITY)-1:0] contador;
  reg [QUEUE_QUANTITY-1:0] contadoresPeso [$clog2(MAX_WEIGHT)-1:0];
  reg enable_toggle;
  reg selector_enb;

  // Salidas
  reg [$clog2(QUEUE_QUANTITY)-1:0] selector;
  reg out_enb;

  // Obtiene un arreglo de m*nx1 en un arreglo de mxn
  genvar n;
  generate
    for (n=0; n<QUEUE_QUANTITY; n=n+1) begin : asignar_pesos
      assign arreglo_pesos[n] = pesos [((n+1)*$clog2(MAX_WEIGHT))-1:n*$clog2(MAX_WEIGHT)];
    end
  endgenerate

  always @ ( * ) begin
    out_enb = !buf_empty[contador];
    {selector_enb, selector} = {1'b0, 2'b0};
    if (!buf_empty[contador]) {selector_enb, selector} = {1'b1, contador};
    else if (!buf_empty[contador+2'd1]) {selector_enb, selector} = {1'b1, contador+2'd1};
    else if (!buf_empty[contador+2'd2]) {selector_enb, selector} = {1'b1, contador+2'd2};
    else if (!buf_empty[contador+2'd3]) {selector_enb, selector} = {1'b1, contador+2'd3};
  end

  genvar c;
  generate
    for (c = 0; c < QUEUE_QUANTITY; c = c + 1) begin: asignar_contadoresPeso_enb
      always @(posedge clk) begin
        if (rst) begin
          contadoresPeso[c] <= arreglo_pesos[c]-1;
        end else if (enb) begin
          contadoresPeso[c] <= contador==c ? contadoresPeso[c]-1 : arreglo_pesos[c]-1;
        end
      end
    end
  endgenerate

  always @ (posedge clk) begin
    // En modo reset
    if (rst) begin
      contador <= 0;

    // Contando
    end else if (enb) begin
      if (contador < (QUEUE_QUANTITY-1)) begin
        if (contadoresPeso[contador] == 0) contador <= contador+1;
      end else begin
        if (contadoresPeso[contador] == 0) contador <= 0;
      end
    end
  end

endmodule // roundRobin
`endif
