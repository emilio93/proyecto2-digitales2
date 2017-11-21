`timescale 1ns/1ps

`ifndef isTest
  `include "../../bloques/roundRobin/roundRobin.v"
  `include "../../bloques/roundRobin/roundRobinPesado.v"
  `include "../../bloques/roundRobin/roundRobinArbitrado.v"
`endif

`ifndef interfazRoundRobin
`define interfazRoundRobin

// Interfaz Seleccionadora de roundRobin
module interfazRoundRobin #(
  parameter QUEUE_QUANTITY = 4, // se utilizan 4 filas fifo
  parameter DATA_BITS = 8,      // Los datos son de 8 bits
  parameter BUF_WIDTH = 3,      // Los datos son de 8 bits
  parameter MAX_WEIGHT = 64,    // El peso máximo es de 64 = 2^6
  parameter TABLE_SIZE = 8      // Tamaño de la tabla de arbitraje
) (
  input clk, rst, enb,
  input [1:0] seleccion_roundRobin, // 00,11: rrRegular, 01: rrPesado, 10: rrArbitrado
  input [QUEUE_QUANTITY-1:0] buf_empty, // indicadores de buf empty en el fifo, uno por cada QUEUE que exista.
  input [((QUEUE_QUANTITY)*($clog2(MAX_WEIGHT)))-1:0] pesos,
  input [((TABLE_SIZE)*($clog2(MAX_WEIGHT)))-1:0] pesosArbitraje,
  input [(TABLE_SIZE)*$clog2(QUEUE_QUANTITY)-1:0] selecciones,
  output [$clog2(QUEUE_QUANTITY)-1:0] selector, // Selector de fifo del roundRobin.
  output selector_enb // Indica si existe un valor de salida.
);

  wire  clk, rst, enb;
  wire [QUEUE_QUANTITY-1:0] buf_empty;
  wire [((QUEUE_QUANTITY)*($clog2(MAX_WEIGHT)))-1:0] pesos;
  wire [((TABLE_SIZE)*($clog2(MAX_WEIGHT)))-1:0] pesosArbitraje;
  wire [(TABLE_SIZE)*$clog2(QUEUE_QUANTITY)-1:0] selecciones;

  reg [$clog2(QUEUE_QUANTITY)-1:0] selector;
  reg selector_enb;

  reg enbRegular, enbPesado, enbArbitrado;

  wire [$clog2(QUEUE_QUANTITY)-1:0] selectorRegular;
  wire [$clog2(QUEUE_QUANTITY)-1:0] selectorPesado;
  wire [$clog2(QUEUE_QUANTITY)-1:0] selectorArbitrado;

  wire selector_enbRegular;
  wire selector_enbPesado;
  wire selector_enbArbitrado;

  roundRobin rrRegular(
    .clk(clk), .rst(rst), .enb(enbRegular),
    .buf_empty(buf_empty),
    .selector(selectorRegular),
    .selector_enb(selector_enbRegular)
  );

  roundRobinPesado rrPesado(
    .clk(clk), .rst(rst), .enb(enbPesado),
    .buf_empty(buf_empty),
    .pesos(pesos),
    .selector(selectorPesado),
    .selector_enb(selector_enbPesado)
  );

  roundRobinArbitrado rrArbitrado(
    .clk(clk), .rst(rst), .enb(enbArbitrado),
    .buf_empty(buf_empty),
    .pesos(pesosArbitraje),
    .selecciones(selecciones),
    .selector(selectorArbitrado),
    .selector_enb(selector_enbArbitrado)
  );

  always @ ( * ) begin
    enbRegular = 0;
    enbPesado = 0;
    enbArbitrado = 0;
    selector = 0;
    selector_enb = 0;
    if (enb) begin
      case (seleccion_roundRobin)
        2'b00, 2'b11:   {enbRegular, selector, selector_enb} = {1'b1, selectorRegular, selector_enbRegular};
        2'b01:    {enbPesado, selector, selector_enb} = {1'b1, selectorPesado, selector_enbPesado};
        2'b10: {enbArbitrado, selector, selector_enb} = {1'b1, selectorArbitrado, selector_enbArbitrado};
        default:   {enbRegular, selector, selector_enb} = {1'b1, selectorRegular, selector_enbRegular};
      endcase
    end
  end

endmodule // roundRobin
`endif
