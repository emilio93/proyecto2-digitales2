`timescale 1ns/1ps

`ifndef fsm
`define fsm

module fsm(
  input clk, input rst, input enb,

  input iniciar,
  input [4:0] almost_full,
  input [4:0] full,
  input [4:0] almost_empty,
  input [4:0] empty,
  output [3:0] continuar,
  output [3:0] error_full,
  output [3:0] pausa,
  output idle
  );

  // DEFINICION ONEHOT
  /*
  * RESET          0
  * ERROR          1
  * INIT           2
  * IDLE_EMPTY     3
  * PAUSE          4
  * CONTINUE_STATE 5
  * ACTIVE         6
  * */
  parameter
  RESET          = 0,
  ERROR          = 1,
  INIT           = 2,
  IDLE_EMPTY     = 3,
  PAUSE          = 4,
  CONTINUE_STATE = 5,
  ACTIVE         = 6;

  reg [6:0] state, next;

  // Entradas
  wire clk,rst, enb;
  wire iniciar;
  wire [4:0] almost_full;//5 fifos
  wire [4:0] full;
  wire [4:0] almost_empty;
  wire [4:0] empty;

  //Salidas
  reg [3:0] error_full;
  reg [3:0] pausa;//solo 4 fifos de arriba
  reg [3:0] continuar;
  reg idle;

  // ALWAYS PARA ONEHOT SECUENCIAL
  always @(posedge clk)begin
    if (rst) begin
      // ASIGNAR ESTADO DE RESET
      state <= 0;
      state[RESET] <= 1'b1;
    end else begin
      // PASAR AL SIGUIENTE ESTADO
      state <= next;
    end
  end

  always @(*) begin
    next = 0;
    case (1'b1)
      state[ACTIVE] : begin
        if(full > 0) next[ERROR] = 1'b1;
        else if(almost_full > 0) next[PAUSE] = 1'b1;
        else if(empty > 0) next[IDLE_EMPTY] = 1'b1;
        else if(almost_empty > 0) next[CONTINUE_STATE] = 1'b1;
        else next[ACTIVE] = 1'b1;
      end

      state[CONTINUE_STATE] : begin
        if(full > 0) next[ERROR] = 1'b1;
        else next[ACTIVE] = 1'b1;
      end

      state[PAUSE] : begin
        if(almost_full > 0) next[PAUSE] = 1'b1;
        else next[ACTIVE] = 1'b1;
      end

      state[IDLE_EMPTY] : begin
        if(empty) next[IDLE_EMPTY] = 1'b1;
        else next[ACTIVE] = 1'b1;
      end

      state[INIT] : begin
        if (iniciar) begin
          next[IDLE_EMPTY] = 1'b1;
        end else begin
          next[INIT] = 1'b1;
        end
      end

      state[ERROR] : begin
        if (!rst) next[ERROR] = 1'b1;
        else next[RESET] = 1'b1;
      end

      state[RESET] :  begin
        if (!rst) begin
          next[INIT] = 1'b1;
        end else begin
          next[RESET] = 1'b1;
        end
      end

      default:
       next = state;
    endcase
  end

  always @(posedge clk) begin
    continuar <= 1'b0;
    pausa <= 1'b0;
    error_full <= 1'b0;
    idle <= 1'b0;
    if (!rst) begin
      case (1'b1)
        next[INIT] : begin
          // permite la modificación de registros
          // 'Tabla de Arbitraje' y 'Umbrales'
        end

        next[ACTIVE] : begin
        end

        next[CONTINUE_STATE] : begin
          continuar <= 1;
        end

        next[PAUSE] : begin
          pausa <= 1;
        end

        next[IDLE_EMPTY] : begin
          idle <= 1;
        end

        next[ERROR], next[RESET] : begin
          continuar <= 0;
          pausa <= 0;
          error_full <= 1;
          idle <= 0;
        end
      endcase
    end
  end
endmodule // fsm
`endif
