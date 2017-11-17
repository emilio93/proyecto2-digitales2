`timescale 1ns/1ps

`ifndef roundRobinArbitrado
`define roundRobinArbitrado

// Implementacion de fila roundRobin
module roundRobinArbitrado #(
  parameter QUEUE_QUANTITY = 4, // se utilizan 4 filas fifo
  parameter DATA_BITS = 8,      // Los datos son de 8 bits
  parameter BUF_WIDTH = 3,      // Los datos son de 8 bits
  parameter MAX_WEIGHT = 64,    // El peso máximo es de 64 = 2^6
  parameter TABLE_SIZE = 8      // Tamaño de la tabla de arbitraje
) (
  input clk,
  input rst,
  input enb,
  input [((TABLE_SIZE)*($clog2(MAX_WEIGHT)))-1:0] pesos,   // 4x6
  input [(TABLE_SIZE)*$clog2(QUEUE_QUANTITY)-1:0] selecciones, // 8x2
  input [QUEUE_QUANTITY-1:0] buf_empty, // indicadores de buf empty en el fifo, uno por cada QUEUE que exista.
  input [(QUEUE_QUANTITY*BUF_WIDTH)-1:0] fifo_counter, // contador de datos en el fifo.
  output [$clog2(QUEUE_QUANTITY)-1:0] selector, // Selector de dato del roundRobin.
  output selector_enb // Indica si existe un valor de salida.
);

  // Entradas
  wire clk, rst, enb;
  wire [QUEUE_QUANTITY-1:0] buf_empty;
  wire  [$clog2(MAX_WEIGHT)-1:0] arreglo_pesos [TABLE_SIZE-1:0]; // arreglo_pesos [4][6]
  wire [$clog2(QUEUE_QUANTITY)-1:0] arreglo_selecciones [TABLE_SIZE-1:0]; // arreglo_selecciones [8][2]


  // Estados
  reg [$clog2(TABLE_SIZE)-1:0] contador;
  reg [$clog2(MAX_WEIGHT)-1:0] contadoresPeso [TABLE_SIZE-1:0] ;
  reg enable_toggle;
  reg selector_enb;

  // Salidas
  reg [$clog2(QUEUE_QUANTITY)-1:0] selector;
  wire out_enb;

  // Obtiene un arreglo de m*nx1 en un arreglo de mxn
  genvar n;
  generate
    for (n=0; n<TABLE_SIZE; n=n+1) begin : asignar_pesos
      assign arreglo_pesos[n] = pesos [((n+1)*$clog2(MAX_WEIGHT))-1:n*$clog2(MAX_WEIGHT)];
    end
  endgenerate

  genvar m;
  generate
    for (m=0; m<TABLE_SIZE; m=m+1) begin : asignar_selecciones
      assign arreglo_selecciones[m] = selecciones [((m+1)*$clog2(QUEUE_QUANTITY))-1:m*$clog2(QUEUE_QUANTITY)];
    end
  endgenerate

  genvar p;
  generate
    for (p=0; p<TABLE_SIZE; p=p+1) begin : chequear_out_enb
      assign out_enb = contadoresPeso[contador]==p? !buf_empty[contador]: 0;
    end
  endgenerate

  always @ ( * ) begin
    {selector_enb, selector} = {1'b0, 2'b0};
    if (!buf_empty[contador]) {selector_enb, selector} = {1'b1, selecciones[contador]};
    else if (!buf_empty[contador+2'd1]) {selector_enb, selector} = {1'b1, selecciones[contador+2'd1]};
    else if (!buf_empty[contador+2'd2]) {selector_enb, selector} = {1'b1, selecciones[contador+2'd2]};
    else if (!buf_empty[contador+2'd3]) {selector_enb, selector} = {1'b1, selecciones[contador+2'd3]};
  end


  always @ (posedge clk) begin
    // En modo reset
    if (rst) begin
      contador <= 0;
    // Contando
    end else if (enb) begin
      if (contador < (TABLE_SIZE)) begin
        if (contadoresPeso[contador] == 0) contador <= contador+1;
      end else begin
        if (contadoresPeso[contador] == 0) contador <= 0;
      end
    end
  end

  genvar b;
  generate
    for (b = 0; b < TABLE_SIZE; b = b + 1) begin: asignar_contadoresPeso_rst
      always @(posedge clk) begin
        if (rst) begin
          contadoresPeso[b] <= arreglo_pesos[b]-1;
        end
      end
    end
  endgenerate

  genvar c;
  generate
    for (c = 0; c < TABLE_SIZE; c = c + 1) begin: asignar_contadoresPeso_enb
      always @(posedge clk) begin
        if (!rst && enb) begin
          contadoresPeso[c] <= contador==0 ? contadoresPeso[c]-1 : arreglo_pesos[c]-1;
        end
      end
    end
  endgenerate

endmodule // roundRobin
`endif
