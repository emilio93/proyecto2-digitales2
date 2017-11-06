`timescale 1ns/1ps

`ifndef fsm
`define fsm

//Usar mas de un always, usar one Hot o parecido, especificar.

module fsm(
  input iniciar,
  input reset,
  input almost_full,
  input full,
  input almost_empty,
  input empty,
  input clk,
  output continuar,
  output error_full,
  output pausa,
  output idle
);

  // Entradas
  wire iniciar, reset;
  wire almost_full;
  wire full;
  wire empty;
  wire clk;

  //Salidas
  reg error_full;
  reg pausa;
  reg continuar;
  reg idle;

  //Se tienen 7 estados por lo tanto basta representarlos con 3 bits en
  //Codificacion binario ordinario

  //Variables internas
  /*
  * active7
  * pause5
  * error2
  * rst1
  * continue6
  * idle4
  * init3
  * */
  parameter rst = 3'b001,
	  error = 3'b010,
	  init = 3'b100,
	  idleEmpty = 3'b011,
	  pause = 3'b101,
	  continue = 3'b110,
	  active = 3'b111;

  reg [2:0] proximo, actual;

//  always @(posedge clk or negedge reset)begin
//	  if (!rst) atual <= active;
//	  else actual <= proximo;
//end

  always @(posedge clk)begin
	actual <= proximo;
	if (rst) actual <= init;

//v	  else actual <= proximo;

//	  always @(actual or full or almost_full or empty or almost_empty or reset or init) begin
	case(actual)

		active : begin
			continuar = 0;
			pausa = 0;
			error_full = 0;
			idle = 0;
			if(full > 0) proximo = error;
				else if(almost_full > 0) proximo = pausa;
				else if(empty > 0) proximo = idleEmpty;
				else if(almost_empty > 0) proximo = continue;
			else proximo = actual;
		end

		continue : begin 
			continuar = 1;
			pausa = 0;
			error_full = 0;
			idle = 0;
			if(full > 0) proximo = error;
				else proximo =  active;
		end

		pause : begin 
			continuar = 0;
			pausa = 1;
			error_full = 0;
			idle = 0;
			proximo = active;
		end  

		idleEmpty : begin 
			continuar = 0;
			pausa = 0;
			error_full = 0;
			idle = 1;
			if(empty < 0) proximo = active;
				else proximo = actual;
		end

		init : begin 
			continuar <= 0;
			pausa <= 0;
			error_full <= 0;
			idle <= 0;
			if(iniciar) proximo <= idleEmpty;
				else proximo <= actual;
		end

		error : begin  
			continuar = 0;
			pausa = 0;
			error_full = 1;
			idle = 0;
			proximo = rst;
		end

		rst :  begin 
			continuar = 0;
			pausa = 0;
			error_full = 1;
			idle = 0;
			proximo = idleEmpty;
		end

	endcase

end

endmodule // fsm
`endif

