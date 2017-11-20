`timescale 1ns/1ps

`ifndef isTest
  `include "../bloques/qos/qos.v"
  `include "../build/qos-sintetizado.v"
`endif

module qosTester(
  input clk, rst, enb,
  input iniciar,
  input [$clog2(QUEUE_QUANTITY)-1:0]             vc_id,
  input [BUF_WIDTH:0]                            data_word,
  input [$clog2(MAX_MAG_UMBRAL)-1:0]             umbral_max,
  input [$clog2(MAX_MAG_UMBRAL)-1:0]             umbral_min,
  input [$clog2(TIPOS_ROUND_ROBIN)-1:0]          mem_seleccion_roundRobin,
  input [QUEUE_QUANTITY*$clog2(MAX_WEIGHT)-1:0]  mem_pesos,
  input [TABLE_SIZE*$clog2(MAX_WEIGHT)-1:0]      mem_pesosArbitraje,
  input [TABLE_SIZE*$clog2(QUEUE_QUANTITY)-1:0]  mem_selecciones,

  output [QUEUE_QUANTITY-1:0] error_full,
  output [QUEUE_QUANTITY-1:0] pausa,
  output [QUEUE_QUANTITY-1:0] continuar,
  output                      idle,
  output [BUF_WIDTH:0]        dataOut,

  output [QUEUE_QUANTITY-1:0] error_fullSynth,
  output [QUEUE_QUANTITY-1:0] pausaSynth,
  output [QUEUE_QUANTITY-1:0] continuarSynth,
  output                      idleSynth,
  output [BUF_WIDTH:0]        dataOutSynth
);
  parameter QUEUE_QUANTITY = 4;    // se utilizan 4 filas fifo
  parameter DATA_BITS = 8;         // Los datos son de 8 bits
  parameter BUF_WIDTH = 3;         // Los datos son de 8 bits
  parameter MAX_WEIGHT = 64;       // El peso máximo es de 64 = 2^6
  parameter TABLE_SIZE = 8;        // Tamaño de la tabla de arbitraje
  parameter MAX_MAG_UMBRAL = 16;   // Tamaño máximo de los umbrales
  parameter TIPOS_ROUND_ROBIN = 3; // Tamaño máximo de los umbrales
  parameter FIFO_COUNT = 5;

  wire clk, rst, enb;
  wire iniciar_in;
  wire [4:0] almost_full_in;
  wire [4:0] full_in;
  wire [4:0] almost_empty_in;
  wire [4:0] empty_in;

  wire errorConduct, idleConduct;
  wire [3:0] pausaConduct;
  wire [3:0] continuarConduct;

  wire errorSynth, idleSynth;
  wire [3:0] pausaSynth;
  wire [3:0] continuarSynth;

  reg errError, errIdle, errPausa, errContinuar;
  always @ ( * ) begin
    errError = errorConduct != errorSynth;
    errIdle = idleConduct != idleSynth;
    errPausa = pausaConduct != pausaSynth;
    errContinuar = continuarConduct != continuarSynth;
  end

  qos qos(
    .clk(clk), .rst(rst), .enb(enb),
    .iniciar(iniciar_in),
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
    .dataOut(dataOut)
  );

  qosSynth qosSynth(
    .clk(clk), .rst(rst), .enb(enb),
    .iniciar(iniciar_in),
    .vc_id(vc_id),
    .data_word(data_word),
    .umbral_max(umbral_max),
    .umbral_min(umbral_min),
    .mem_seleccion_roundRobin(mem_seleccion_roundRobin),
    .mem_pesos(mem_pesos),
    .mem_pesosArbitraje(mem_pesosArbitraje),
    .mem_selecciones(mem_selecciones),

    .error_full(error_fullSynth),
    .pausa(pausaSynth),
    .continuar(continuarSynth),
    .idle(idleSynth),
    .dataOut(dataOutSynth)
  );

endmodule
