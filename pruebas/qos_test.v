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
reg wr_en, rd_en;

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
  .wr_en(wr_en), .rd_en(rd_en),

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
  data_word                 <= 0;
  umbral_max                <= 0;
  umbral_min                <= 0;
  mem_seleccion_roundRobin  <= 0;
  mem_pesos                 <= 0;
  mem_pesosArbitraje        <= 0;
  mem_selecciones           <= 0;
  wr_en                     <= 0;
  rd_en                     <= 0;
  # 40
  @(posedge clk);
  rst <= 0;

  # 10
  @(posedge clk);
  iniciar <= 1;
  @(posedge clk);
  iniciar <= 0;

  #1000
  $finish();
end

endmodule
