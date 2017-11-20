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
  /*               n  hex codificado
  * RESET          0  01
  * ERROR          1  02
  * INIT           2  04
  * IDLE_EMPTY     3  08
  * PAUSE          4  10
  * CONTINUE_STATE 5  20
  * ACTIVE         6  40
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
  // RST Y ACTUALIZACION DE ESTADO
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

  // ALWAYS PARA ONEHOT COMBINACIONAL
  // SELECCION DE ESTADO SIGUIENTE.
  always @(*) begin
    next = 0; // se limpia next para tener solo un bit arriba
    case (1'b1)
      // para estado active, puede pasar a CONTINUE_STATE, PAUSE, IDLE_EMPTY
      // o ERROR
      state[ACTIVE] : begin
        if(full > 0) next[ERROR] = 1'b1; // existe algun fifo con señal full en alto
        else if(almost_full > 0) next[PAUSE] = 1'b1; // || almost_full ||
        else if(empty > 0) next[IDLE_EMPTY] = 1'b1; // IDLE EMPTY
        else if(almost_empty > 0) next[CONTINUE_STATE] = 1'b1; // CONTINUE_STATE
        else next[ACTIVE] = 1'b1; // se mantiene en active
      end

      state[CONTINUE_STATE] : begin
        next[ACTIVE] = 1'b1; // siempre regresa a active
      end

      state[PAUSE] : begin
        next[ACTIVE] = 1'b1; // siempre regresa a active
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

  // ALWAYS PARA ONEHOT SECUENCIAL
  // ASIGNACION DE SALIDAS
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

        // IDLE SE MANTINE EN 1 MIENTRAS ESTÉ EN IDLE EMPTY
        next[IDLE_EMPTY] : begin
          idle <= 1;
        end

        // TRANSMISION DE DATOS POR DEFECTO
        next[ACTIVE] : begin
        end

        // SEÑAL ALMOST FULL SE ENVIA EN PAUSA
        // ESTO INDICA AL FIFO QUE DEBE DEJAR DE
        // RECIBIR DATOS(wr_en en bajo)
        // strobe
        next[PAUSE] : begin
          pausa <= almost_full;
        end

        // CONTINUE_STATE indica que un fifo está casi vacio
        // por lo que evita sacar datos de este (rd_en en bajo)
        // strobe
        next[CONTINUE_STATE] : begin
          continuar <= almost_empty;
        end

        // INDICA ERRORES DE FIFOS FULL SE MANTIENE EN ESTE ESTADO
        // HASTA TENER UNA SEÑAL DE RESET
        next[ERROR], next[RESET] : begin
          error_full <= full;
        end
      endcase
    end
  end
endmodule // fsm
`endif
