`timescale 1ns/1ps
`define isQos 1

`ifndef isTest
  `include "../../bloques/qos/memorias.v"

  `include "../../bloques/fifo/fifo8.v"
  `include "../../bloques/fifo/fifo16.v"

  `include "../../bloques/flowControl/fsm.v"
  `include "../../bloques/flowControl/flowControl.v"

  `include "../../bloques/mux/mux.v"
  `include "../../bloques/mux/demux.v"

  `include "../../bloques/roundRobin/roundRobin.v"
  `include "../../bloques/roundRobin/roundRobinPesado.v"
  `include "../../bloques/roundRobin/roundRobinArbitrado.v"
  `include "../../bloques/roundRobin/interfazRoundRobin.v"
`endif

module qos #(
  parameter QUEUE_QUANTITY = 4,    // se utilizan 4 filas fifo
  parameter DATA_BITS = 8,         // Los datos son de 8 bits
  parameter BUF_WIDTH = 3,         // Los datos son de 8 bits
  parameter MAX_WEIGHT = 64,       // El peso máximo es de 64 = 2^6
  parameter TABLE_SIZE = 8,        // Tamaño de la tabla de arbitraje
  parameter MAX_MAG_UMBRAL = 16,    // Tamaño máximo de los umbrales
  parameter TIPOS_ROUND_ROBIN = 3, // Tamaño máximo de los umbrales
  parameter FIFO_COUNT = 5
)(
  input clk, rst, enb,
  input iniciar,
  input [$clog2(QUEUE_QUANTITY)-1:0]             vc_id,
  input [BUF_WIDTH:0]                          data_word,
  input [$clog2(MAX_MAG_UMBRAL)-1:0]             umbral_max,
  input [$clog2(MAX_MAG_UMBRAL)-1:0]             umbral_min,
  input [QUEUE_QUANTITY*$clog2(MAX_WEIGHT)-1:0]  pesos,
  input [TABLE_SIZE*$clog2(MAX_WEIGHT)-1:0]      pesosArbitraje,
  input [$clog2(TIPOS_ROUND_ROBIN)-1:0]          seleccion_roundRobin,
  input [TABLE_SIZE*$clog2(QUEUE_QUANTITY)-1:0]  selecciones,

  output [QUEUE_QUANTITY-1:0] error_full,
  output [QUEUE_QUANTITY-1:0] pausa,
  output [QUEUE_QUANTITY-1:0] continuar,
  output                      idle,
  output [BUF_WIDTH:0]        dataOut
);



  memorias memorias(
  );

  fsm fsm(
  );

  flowControl flowControl(
  );

  wire [FIFO_COUNT-1:0] buf_empty;
  wire [$clog2(QUEUE_QUANTITY)-1:0] selector_roundRobin_out;
  wire selector_roundRobin_enb_out;

  wire [FIFO_COUNT-1:0] buf_full;
  wire [FIFO_COUNT-1:0] almost_full;
  wire [FIFO_COUNT-1:0] almost_empty;
  wire [FIFO_COUNT-1:0] fifo_counter;

  wire [BUF_WIDTH:0] buf_in0;
  wire [BUF_WIDTH:0] buf_out0;
  wire [BUF_WIDTH:0] fifo_counter0;

  wire [BUF_WIDTH:0] buf_in1;
  wire [BUF_WIDTH:0] buf_out1;
  wire [BUF_WIDTH:0] fifo_counter1;

  wire [BUF_WIDTH:0] buf_in2;
  wire [BUF_WIDTH:0] buf_out2;
  wire [BUF_WIDTH:0] fifo_counter2;

  wire [BUF_WIDTH:0] buf_in3;
  wire [BUF_WIDTH:0] buf_out3;
  wire [BUF_WIDTH:0] fifo_counter3;

  wire [BUF_WIDTH:0] buf_in;

  interfazRoundRobin interfazRoundRobin(
    .clk(clk), .rst(rst), .enb(enb),
    .seleccion_roundRobin(seleccion_roundRobin),
    .pesos(pesos),
    .pesosArbitraje(pesosArbitraje),
    .selecciones(selecciones),
    .buf_empty(buf_empty[FIFO_COUNT-2:0]),
    .selector(selector_roundRobin_out),
    .selector_enb(selector_roundRobin_enb_out)
  );

  demux demux(
    .enb(enb),
    .entrada_dmux(data_word),
    .selector_dmux(vc_id),
    .salida0_dmux(buf_in0),
    .salida1_dmux(buf_in1),
    .salida2_dmux(buf_in2),
    .salida3_dmux(buf_in3)
  );


  fifo8 vc0 (
    .clk(clk), .rst(rst),
    .buf_in(buf_in0),
    .buf_out(buf_out0),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .uH(umbral_max),
    .uL(umbral_min),
    .buf_empty(buf_empty[0]),
    .buf_full(buf_full[0]),
    .almost_full(almost_full[0]),
    .almost_empty(almost_empty[0]),
    .fifo_counter(fifo_counter0)
  );


  fifo8 vc1 (
    .clk(clk), .rst(rst),
    .buf_in(buf_in1),
    .buf_out(buf_out1),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .uH(umbral_max),
    .uL(umbral_min),
    .buf_empty(buf_empty[1]),
    .buf_full(buf_full[1]),
    .almost_full(almost_full[1]),
    .almost_empty(almost_empty[1]),
    .fifo_counter(fifo_counter1)
  );


  fifo8 vc2(
    .clk(clk), .rst(rst),
    .buf_in(buf_in2),
    .buf_out(buf_out2),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .uH(umbral_max),
    .uL(umbral_min),
    .buf_empty(buf_empty[2]),
    .buf_full(buf_full[2]),
    .almost_full(almost_full[2]),
    .almost_empty(almost_empty[2]),
    .fifo_counter(fifo_counter2)
  );


  fifo8 vc3(
    .clk(clk), .rst(rst),
    .buf_in(buf_in3),
    .buf_out(buf_out3),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .uH(umbral_max),
    .uL(umbral_min),
    .buf_empty(buf_empty[3]),
    .buf_full(buf_full[3]),
    .almost_full(almost_full[3]),
    .almost_empty(almost_empty[3]),
    .fifo_counter(fifo_counter3)
  );


  mux mux(
    .enb(enb),
    .entrada0_mux(buf_out0),
    .entrada1_mux(buf_out1),
    .entrada2_mux(buf_out2),
    .entrada3_mux(buf_out3),
    .selector_mux(selector_roundRobin_out),
    .salida_mux(buf_in)
  );


  fifo16 fifoSalida(
    .clk(clk), .rst(rst),
    .buf_in(buf_in),
    .buf_out(dataOut),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .uH(umbral_max),
    .uL(umbral_min),
    .buf_empty(buf_empty[4]),
    .buf_full(buf_full[4]),
    .almost_full(almost_full[4]),
    .almost_empty(almost_empty[4]),
    .fifo_counter(fifo_counter)
  );
endmodule
