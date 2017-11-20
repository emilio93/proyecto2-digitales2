`timescale 1ns/1ps
`define isQos 1

`ifndef isTest
  `include "../../bloques/fifo/fifo8.v"
  `include "../../bloques/fifo/fifo16.v"
  `include "../../bloques/flowControl/fsm.v"
  `include "../../bloques/mux/mux.v"
  `include "../../bloques/mux/demux.v"
  `include "../../bloques/roundRobin/roundRobin.v"
  `include "../../bloques/roundRobin/roundRobinPesado.v"
  `include "../../bloques/roundRobin/roundRobinArbitrado.v"
  `include "../../bloques/roundRobin/interfazRoundRobin.v"
`endif

module qos #(
  parameter QUEUE_QUANTITY = 4, // se utilizan 4 filas fifo
  parameter DATA_BITS = 8,      // Los datos son de 8 bits
  parameter BUF_WIDTH = 3,      // Los datos son de 8 bits
  parameter MAX_WEIGHT = 64,    // El peso máximo es de 64 = 2^6
  parameter TABLE_SIZE = 8      // Tamaño de la tabla de arbitraje
)(
  //output hacia capa de enlace de datos
  output wire[DATA_BITS-1:0] output_qos,
  //output hacia control
  output wire [QUEUE_QUANTITY-1:0] error_full_qos, pausa_qos, continue_qos,
  output wire idle_qos,
  //inputs señales de control
  input wire clk, rst, enb, init,
  input wire [BUF_WIDTH:0] uH,
  input wire [BUF_WIDTH:0] uL,//umbrales de almost_full, almost_empty para los fifos
  input wire [$clog2(QUEUE_QUANTITY)-1:0] vc_id, //identificadores de los canales virtuales
  input wire [QUEUE_QUANTITY-1:0] arbiterTable,
  //inputs data
  input wire[BUF_WIDTH:0] input_qos
  );


  //Parametros
  parameter BUF_WIDTH3 = 3;
  parameter BUF_WIDTH4 = 4;
  parameter BUF_SIZE8 = ( 1<<BUF_WIDTH3 );
  parameter BUF_SIZE16 = ( 1<<BUF_WIDTH4 );

  //Variables internas
  //fifo8
  wire wr_en, rd_en;
  wire buf_full, buf_empty, almost_full, almost_empty;
  wire [QUEUE_QUANTITY-1:0] vc0_in;
  wire [QUEUE_QUANTITY-1:0] vc1_in;
  wire [QUEUE_QUANTITY-1:0] vc2_in;
  wire [QUEUE_QUANTITY-1:0] vc3_in;
  wire [QUEUE_QUANTITY-1:0] vc0_out, vc1_out, vc2_out, vc3_out;
  wire [QUEUE_QUANTITY-1:0] vc_wr_en;
  wire [QUEUE_QUANTITY-1:0] vc_rd_en;
  wire [QUEUE_QUANTITY-1:0] vc_empty;
  wire [QUEUE_QUANTITY-1:0] vc_almost_full;
  wire [QUEUE_QUANTITY-1:0] vc_almost_empty;
  wire [QUEUE_QUANTITY-1:0] vc_full;

  wire [BUF_WIDTH3-1:0] vc0_fifo8_counter;
  wire [BUF_WIDTH3-1:0] vc1_fifo8_counter;
  wire [BUF_WIDTH3-1:0] vc2_fifo8_counter;
  wire [BUF_WIDTH3-1:0] vc3_fifo8_counter;
  //señales retardadas desde roundRobin
  //

  wire [QUEUE_QUANTITY-1:0] vc0_fifo_counter;
  wire [QUEUE_QUANTITY-1:0] vc1_fifo_counter;
  wire [QUEUE_QUANTITY-1:0] vc2_fifo_counter;
  wire [QUEUE_QUANTITY-1:0] vc3_fifo_counter;

  //mux
  wire [1:0] selectorMux;
  wire [(DATA_BITS-1):0]salidaMux;

  wire [$clog2(QUEUE_QUANTITY)-1:0] selector;
  wire [QUEUE_QUANTITY-1:0] selector_enb;


  //estancias

  demux demux(
  	.enb(enb),
  	.entrada_dmux(input_qos),
  	.selector_dmux(vc_id),
  	.salida0_dmux(vc0_in),
  	.salida1_dmux(vc1_in),
  	.salida2_dmux(vc2_in),
  	.salida3_dmux(vc3_in)
  	);

    fifo8 vc0(
    	.buf_in(vc0_in), .buf_out(vc0_out),//datos entrada y salida
    	.clk(clk), .rst(rst), .uH(uH), .uL(uL),//señales de control,umbrales de almost_full, almost_empty
      .wr_en(vc_wr_en[0]), .rd_en(vc_rd_en[0]),//señales de lectura y escritura
      .buf_empty(vc_empty[0]), .buf_full(vc_full[0]),//banderas de estado del fifo
    	.almost_full(vc_almost_full[0]), .almost_empty(vc_almost_empty[0]),
    	.fifo_counter(vc0_fifo_counter) //contador de datos en fifo
    	);

    fifo8 vc1(
      	.buf_in(vc1_in), .buf_out(vc1_out),//datos entrada y salida
      	.clk(clk), .rst(rst), .uH(uH), .uL(uL),//señales de control,umbrales de almost_full, almost_empty
        .wr_en(vc_wr_en[1]), .rd_en(vc_rd_en[1]),//señales de lectura y escritura
      	.buf_empty(vc_empty[1]), .buf_full(vc_full[1]),//banderas de estado del fifo
      	.almost_full(vc_almost_full[1]), .almost_empty(vc_almost_empty[1]),
      	.fifo_counter(vc1_fifo_counter) //contador de datos en fifo
      	);

      fifo8 vc2(
        	.buf_in(vc2_in), .buf_out(vc2_out),//datos entrada y salida
        	.clk(clk), .rst(rst), .uH(uH), .uL(uL),//señales de control,umbrales de almost_full, almost_empty
          .wr_en(vc_wr_en[2]), .rd_en(vc_rd_en[2]),//señales de lectura y escritura
        	.buf_empty(vc_empty[2]), .buf_full(vc_full[2]),//banderas de estado del fifo
        	.almost_full(vc_almost_full[2]), .almost_empty(vc_almost_empty[2]),
        	.fifo_counter(vc2_fifo_counter) //contador de datos en fifo
        	);

    fifo8 vc3(
            .buf_in(vc3_in), .buf_out(vc3_out),//datos entrada y salida
            .clk(clk), .rst(rst), .uH(uH), .uL(uL),//señales de control,umbrales de almost_full, almost_empty
            .wr_en(vc_wr_en[3]), .rd_en(vc_rd_en[3]),//señales de lectura y escritura
            .buf_empty(vc_empty[3]), .buf_full(vc_full[3]),//banderas de estado del fifo
            .almost_full(vc_almost_full[3]), .almost_empty(vc_almost_empty[3]),
            .fifo_counter(vc3_fifo_counter) //contador de datos en fifo
            );


// input clk,
// input rst,
// input enb,
// input [QUEUE_QUANTITY-1:0] buf_empty, // indicadores de buf empty en el fifo, uno por cada QUEUE que exista.
// input [QUEUE_QUANTITY-1:0] fifo_counter, // contador de datos en el buffer
// output [$clog2(QUEUE_QUANTITY)-1:0] selector, // Selector de dato del roundRobin.
// output selector_enb

  mux mux(
  	.enb(enb),
  	.entrada0_mux(vc0_out),
  	.entrada1_mux(vc1_out),
  	.entrada2_mux(vc2_out),
  	.entrada3_mux(vc3_out),
  	.selector_mux(selector),
  	.salida_mux(selector_enb)
  	);




//Variables internas:




endmodule
