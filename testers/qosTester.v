`timescale 1ns/1ps

`ifndef isTest
  `include "../bloques/qos/qos.v"
  `include "../build/qos-sintetizado.v"
`endif

module qosTester(
  input clk, rst, enb,
  input iniciar_in,
  input [4:0] almost_empty_in,
  input [4:0] almost_full_in,
  input [4:0] full_in,
  input [4:0] empty_in,
  output errorConduct,
  output idleConduct,
  output [3:0] pausaConduct,
  output [3:0] continuarConduct,
  output errorSynth,
  output idleSynth,
  output [3:0] pausaSynth,
  output [3:0] continuarSynth
  );

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
    .almost_full(almost_full_in),
    .full(full_in),
    .almost_empty(almost_empty_in),
    .empty(empty_in),
    .continuar(continuarConduct),
    .error_full(errorConduct),
    .pausa(pausaConduct),
    .idle(idleConduct)
  );

  qosSynth qosSynth(
    .clk(clk), .rst(rst), .enb(enb),
    .iniciar(iniciar_in),
    .almost_full(almost_full_in),
    .full(full_in),
    .almost_empty(almost_empty_in),
    .empty(empty_in),
    .continuar(continuarSynth),
    .error_full(errorSynth),
    .pausa(pausaSynth),
    .idle(idleSynth)
  );

endmodule
