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
  input [(QUEUE_QUANTITY*BUF_WIDTH)-1:0] fifo_counter, // contador de datos en el fifo.
  output [$clog2(QUEUE_QUANTITY)-1:0] selector, // Selector de dato del roundRobin.
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
    selector = contador;
    selector_enb = 1;
  end

  always @ (posedge clk) begin
    // En modo reset
    if (rst) begin
      contador <= 0;
      // contadores descendentes.
      contadoresPeso[0] <= arreglo_pesos[0];
      contadoresPeso[1] <= arreglo_pesos[1];
      contadoresPeso[2] <= arreglo_pesos[2];
      contadoresPeso[3] <= arreglo_pesos[3];

    // Contando
    end else if (enb) begin
      if (contador < QUEUE_QUANTITY-1) begin
        if (contadoresPeso[contador] == 0) contador <= contador+1;
      end else begin
        if (contadoresPeso[contador] == 0) contador <= 0;
      end
      contadoresPeso[0] <= contador==0 ? contadoresPeso[0]-1 : arreglo_pesos[0];
      contadoresPeso[1] <= contador==1 ? contadoresPeso[1]-1 : arreglo_pesos[1];
      contadoresPeso[2] <= contador==2 ? contadoresPeso[2]-1 : arreglo_pesos[2];
      contadoresPeso[3] <= contador==3 ? contadoresPeso[3]-1 : arreglo_pesos[3];

    end
  end

endmodule // roundRobin
`endif
