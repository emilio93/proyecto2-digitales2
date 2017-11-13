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
`endif

module qos #(parameter DATA_WIDTH = 4, parameter QUEUE_QUANTITY = 4)(
  //output hacia capa de enlace de datos
  output wire[DATA_WIDTH-1:0] output_qos,
  //output hacia control
  output wire [QUEUE_QUANTITY-1:0] error_full_qos, pausa_qos, continue_qos,
  output wire idle_qos,
  //inputs señales de control
  input wire clk, rst, enb, init,
  input wire uh,ub,//umbrales de almost_full, almost_empty para los fifos
  input wire [1:0] vc_id, //identificadores de los canales virtuales
  input wire [QUEUE_QUANTITY-1:0] arbiterTable,
  //inputs data
  input wire[DATA_WIDTH-1:0] input_qos
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
  wire [(DATA_WIDTH-1):0] vc0_in, vc1_in, vc2_in, vc3_in;
  wire [(DATA_WIDTH-1):0] vc0_out, vc1_out, vc2_out, vc3_out;
  wire [QUEUE_QUANTITY-1:0] vc_wr_en;
  wire [QUEUE_QUANTITY-1:0] vc_rd_en;
  wire [QUEUE_QUANTITY-1:0] vc_empty;
  wire [QUEUE_QUANTITY-1:0] vc_almost_full;
  wire [QUEUE_QUANTITY-1:0] vc_almost_empty;
  wire [QUEUE_QUANTITY-1:0] vc_full;
  //wire  vc0_wr_en, vc1_wr_en, vc2_wr_en, vc3_wr_en;
  //wire  vc0_rd_en, vc1_rd_en, vc2_rd_en, vc3_rd_en;
  wire [BUF_WIDTH3 :0] vc0_fifo8_counter,vc1_fifo8_counter,vc2_fifo8_counter, vc3_fifo8_counter;


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
    	.clk(clk), .rst(rst), .wr_en(vc_wr_en[0]), .rd_en(vc_rd_en[0]),//señales de control
    	.buf_empty(vc_empty[0]), .buf_full(vc_full[0]),//banderas de estado del fifo
    	.almost_full(vc_almost_full[0]), .almost_empty(vc_almost_empty[0]),
    	.fifo_counter(vc0_fifo_counter) //contador de datos en fifo
    	);

    fifo8 vc1(
      	.buf_in(vc1_in), .buf_out(vc1_out),//datos entrada y salida
      	.clk(clk), .rst(rst), .wr_en(vc_wr_en[1]), .rd_en(vc_rd_en[1]),//señales de control
      	.buf_empty(vc_empty[1]), .buf_full(vc_full[1]),//banderas de estado del fifo
      	.almost_full(vc_almost_full[1]), .almost_empty(vc_almost_empty[1]),
      	.fifo_counter(vc1_fifo_counter) //contador de datos en fifo
      	);

      fifo8 vc2(
        	.buf_in(vc2_in), .buf_out(vc2_out),//datos entrada y salida
        	.clk(clk), .rst(rst), .wr_en(vc_wr_en[2]), .rd_en(vc_rd_en[2]),//señales de control
        	.buf_empty(vc_empty[2]), .buf_full(vc_full[2]),//banderas de estado del fifo
        	.almost_full(vc_almost_full[2]), .almost_empty(vc_almost_empty[2]),
        	.fifo_counter(vc2_fifo_counter) //contador de datos en fifo
        	);

    fifo8 vc3(
            .buf_in(vc3_in), .buf_out(vc3_out),//datos entrada y salida
            .clk(clk), .rst(rst), .wr_en(vc_wr_en[3]), .rd_en(vc_rd_en[3]),//señales de control
            .buf_empty(vc_empty[3]), .buf_full(vc_full[3]),//banderas de estado del fifo
            .almost_full(vc_almost_full[3]), .almost_empty(vc_almost_empty[3]),
            .fifo_counter(vc3_fifo_counter) //contador de datos en fifo
            );


  mux mux(
  	.enb(enb),
  	.entrada0_mux(e0),
  	.entrada1_mux(e1),
  	.entrada2_mux(e2),
  	.entrada3_mux(e3),
  	.selector_mux(selectorMux),
  	.salida_mux(salidaMux)
  	);




//Variables internas:




endmodule
