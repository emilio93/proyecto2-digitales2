`timescale 1ns/1ps

`define isTest 1

`include "includes.v"

`include "../bloques/qos/qos.v"
`include "../build/qos-sintetizado.v"
`include "../testers/qosTester.v"

module qos_test #(
  parameter QUEUE_QUANTITY = 4,    // se utilizan 4 filas fifo
  parameter DATA_BITS = 8,         // Los datos son de 8 bits
  parameter DATA_WIDTH = 4,        // Los datos son de 4 bits
  parameter BUF_WIDTH = 3,         // Los datos son de 8 bits
  parameter MAX_WEIGHT = 64,       // El peso máximo es de 64 = 2^6
  parameter TABLE_SIZE = 8,        // Tamaño de la tabla de arbitraje
  parameter MAX_MAG_UMBRAL = 16,   // Tamaño máximo de los umbrales
  parameter TIPOS_ROUND_ROBIN = 3, // Tamaño máximo de los umbrales
  parameter FIFO_COUNT = 5
)();

reg clk, rst, enb;

reg iniciar;
reg [$clog2(QUEUE_QUANTITY)-1:0]             vc_id;
reg [BUF_WIDTH:0]                            data_word;
reg [$clog2(MAX_MAG_UMBRAL)-1:0]             umbral_max;
reg [$clog2(MAX_MAG_UMBRAL)-1:0]             umbral_min;
reg [$clog2(TIPOS_ROUND_ROBIN)-1:0]          mem_seleccion_roundRobin;
reg [QUEUE_QUANTITY*$clog2(MAX_WEIGHT)-1:0]  mem_pesos;
reg [TABLE_SIZE*$clog2(MAX_WEIGHT)-1:0]      mem_pesosArbitraje;
reg [TABLE_SIZE*$clog2(QUEUE_QUANTITY)-1:0]  mem_selecciones;

wire [QUEUE_QUANTITY-1:0] error_full;
wire [QUEUE_QUANTITY-1:0] pausa;
wire [QUEUE_QUANTITY-1:0] continuar;
wire                      idle;
wire [BUF_WIDTH:0]        dataOut;

wire [QUEUE_QUANTITY-1:0] error_fullSynth;
wire [QUEUE_QUANTITY-1:0] pausaSynth;
wire [QUEUE_QUANTITY-1:0] continuarSynth;
wire                      idleSynth;
wire [BUF_WIDTH:0]        dataOutSynth;

qosTester qosTester(
  .clk(clk), .rst(rst), .enb(enb),
  .iniciar(iniciar),
  .vc_id(vc_id),
  .data_word(data_word),
  .umbral_max(umbral_max),
  .umbral_min(umbral_min),
  .mem_seleccion_roundRobin(mem_seleccion_roundRobin),
  .mem_pesos(mem_pesos),
  .mem_pesosArbitraje(mem_pesosArbitraje),
  .mem_selecciones(mem_selecciones),

  .error_full(error_full),
  .pausa(pausa),
  .continuar(continuar),
  .idle(idle),
  .dataOut(dataOut),

  .error_fullSynth(error_fullSynth),
  .pausaSynth(pausaSynth),
  .continuarSynth(continuarSynth),
  .idleSynth(idleSynth),
  .dataOutSynth(dataOutSynth)
);



always # 5 clk = ~clk;

initial
begin
  $dumpfile("gtkws/qos_test.vcd");
  $dumpvars();
end

initial begin
  clk <= 0;
  rst <= 1;
  enb <= 1;

  iniciar                   <= 0;
  vc_id                     <= 0;
  data_word                 <= 8;

  umbral_max                <= 2;
  umbral_min                <= 2;
  mem_seleccion_roundRobin  <= 0;
  mem_pesos                 <= 0;
  mem_pesosArbitraje        <= 0;
  mem_selecciones           <= 0;



  # 20
  @(posedge clk);
  iniciar <= 1;
  @(posedge clk);
  iniciar <= 0;

  # 40
  @(posedge clk);
  rst <= 0;

  # 20 @(posedge clk);
  vc_id <= 1;
  data_word <= 5;
  # 20 @(posedge clk);
  vc_id <= 2;
  data_word <= 2;
  # 20 @(posedge clk);
  vc_id <= 3;
  data_word <= 3;

  # 20 @(posedge clk);
  vc_id <= 0;
  data_word <= 14;
  # 20 @(posedge clk);
  vc_id <= 1;
  data_word <= 10;
  # 20 @(posedge clk);
  vc_id <= 2;
  data_word <= 4;

  # 10
  @(posedge clk);
  iniciar <= 1;
  @(posedge clk);
  iniciar <= 0;

  # 20 @(posedge clk);
  vc_id <= 1;
  data_word <= 5;
  # 20 @(posedge clk);
  vc_id <= 2;
  data_word <= 2;
  # 20 @(posedge clk);
  vc_id <= 3;
  data_word <= 3;

  # 20 @(posedge clk);
  vc_id <= 0;
  data_word <= 14;
  # 20 @(posedge clk);
  vc_id <= 1;
  data_word <= 10;
  # 20 @(posedge clk);
  vc_id <= 2;
  data_word <= 4;

  # 50 @(posedge clk);
  umbral_max                <= 3;
  umbral_min                <= 3;
  mem_seleccion_roundRobin  <= 1; // pesado
  mem_pesos                 <= {6'b000010, 6'b000100, 6'b000001, 6'b000110};

  # 20 @(posedge clk);
  vc_id <= 1;
  data_word <= 10;
  # 20 @(posedge clk);
  vc_id <= 2;
  data_word <= 12;
  # 20 @(posedge clk);
  vc_id <= 3;
  data_word <= 8;

  # 20 @(posedge clk);
  vc_id <= 0;
  data_word <= 6;
  # 20 @(posedge clk);
  vc_id <= 1;
  data_word <= 3;;
  # 20 @(posedge clk);
  vc_id <= 2;
  data_word <= $urandom%15;

  # 20 @(posedge clk);
  vc_id <= 0;
  data_word <= 14;
  # 20 @(posedge clk);
  vc_id <= 1;
  data_word <= 13;
  # 20 @(posedge clk);
  vc_id <= 2;
  data_word <= 11;
  # 20 @(posedge clk);
  vc_id <= 3;
  data_word <= 5;

  # 50 @(posedge clk);
  rst <= 1;
  # 20 @(posedge clk);
  rst <= 0;
  # 30 @(posedge clk);
  iniciar <= 1;
  @(posedge clk);
  iniciar <= 0;

  # 750 @(posedge clk);
  umbral_max                <= 3;
  umbral_min                <= 3;
  mem_seleccion_roundRobin  <= 2; // arbitrado
  mem_pesosArbitraje        <= {6'b10, 6'b10, 6'b10, 6'b10, 6'b10, 6'b10, 6'b10, 6'b100};
  mem_selecciones           <= {2'b11, 2'b10, 2'b00, 2'b01, 2'b10, 2'b10, 2'b01, 2'b10};

  # 50 @(posedge clk);
  rst <= 1;
  # 20 @(posedge clk);
  rst <= 0;
  # 30 @(posedge clk);
  iniciar <= 1;
  @(posedge clk);
  iniciar <= 0;

  #1000
  $finish();
end

// task push;
// input [(DATA_WIDTH-1):0] data;
//    if( !qosTester.qos.fifoSalida.buf_full ) begin
//       qosTester.qos.fifoSalida.buf_in = data;
//       qosTester.qos.fifoSalida.wr_en = 1;
//       @(posedge clk);
//       #1 qosTester.qos.fifoSalida.wr_en = 0;
//     end
// endtask
//
// task pop;
//   output [(DATA_WIDTH-1):0] data;
//    if( !qosTester.qos.fifoSalida.buf_empty ) begin
//     qosTester.rd_en = 1;
//     @(posedge clk);
//     #1 qosTester.rd_en = 0;
//     data = qosTester.qos.fifoSalida.buf_out;
//   end
// endtask
//

task aleatorio;
  output [DATA_WIDTH-1:0] num;
  num=$urandom%15;
endtask

endmodule
