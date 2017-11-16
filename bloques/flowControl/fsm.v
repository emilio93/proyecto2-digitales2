`timescale 1ns/1ps

`ifndef fsm
`define fsm

//Usar mas de un always, usar one Hot o parecido, especificar.

module fsm(
  input iniciar,
  input reset,
  input [4:0] almost_full,
  input [4:0] full,
  input [4:0] almost_empty,
  input [4:0] empty,
  input clk,
  output [3:0] continuar,
  output error_full,
  output [3:0] pausa,
  output idle
);

  // Entradas
  wire iniciar, reset;
  wire [4:0] almost_full;//5 fifos
  wire [4:0] full;
  wire [4:0] almost_empty;
  wire [4:0] empty;
  wire clk;

  //Salidas
  reg error_full;
  reg [3:0] pausa;//solo 4 fifos de arriba
  reg [3:0] continuar;
  reg idle;

  //Se tienen 7 estados por lo tanto basta representarlos con 3 bits en
  //Codificacion binario ordinario

  //Variables internas
  /*
  * active7
  * pause5
  * error2
  * rst1
  * continuee6
  * idle4
  * init3
  * */
  parameter [2:0] rst = 3'b001, error = 3'b010, init = 3'b100, idleEmpty = 3'b011, pause = 3'b101, continuee = 3'b110,  active = 3'b111;

  reg [2:0] proximo;	//iniciales
  reg [2:0] actual; 

//  always @(posedge clk or negedge reset)begin
//	  if (!rst) actual <= active;
//	  else actual <= proximo;
//end
/*
  always @(posedge clk)begin
	  actual <= proximo;
  end
*/
  always @(posedge clk)begin
	  if (rst) actual <= init;
	  else actual <= proximo;
  end

//  always @(posedge clk)begin

//	  else actual <= proximo;
//
	  /*
	always @(*) begin
		if(actual == init ) begin 
			if(iniciar) begin
			proximo = idleEmpty;
			continuar = 4'b0000;	//4
			pausa = 4'b0000;	//4
			error_full = 0;
			idle = 0;
		end else begin
			proximo = init;
			continuar = 4'b0000;	//4
			pausa = 4'b0000;	//4
			error_full = 0;
			idle = 0;
		end
		end
		else if(actual == idleEmpty) begin 
			if(|empty)begin
			proximo = idleEmpty;
			continuar = 4'b1111;	//4
			pausa = 4'b0000;	//4
			error_full = 0;
			idle = 1;
		end else begin
			proximo = active;
			continuar = 4'b1111;	//4
			pausa = 4'b0000;	//4
			error_full = 0;
			idle = 0;

		end
		end
		else if(actual == active) begin
		       	if(full == 0 ) begin 
			proximo = error;
			continuar = 4'b1111;	//4
			pausa = 4'b0000;	//4
			error_full = 0;
			idle = 0;
		end	else begin
			if(almost_full > 0) begin
			proximo = pause;
			continuar = 4'b0000;	//4
			pausa = 4'b1111;	//4
			error_full = 0;
			idle = 0;
		end else begin
			proximo = continuee;
			continuar = 4'b1111;	//4
			pausa = 4'b0000;	//4
			error_full = 0;
			idle = 0;
		end
	end
	end
	else if(actual == continuee) begin
			proximo = active;
			continuar = 4'b1111;	//4
			pausa = 4'b0000;	//4
			error_full = 0;
			idle = 0;
		end
		else if(actual == pause) begin
			if(almost_full > 0) begin
			proximo = pause;
			continuar = 4'b0000;	//4
			pausa = 4'b1111;	//4
			error_full = 0;
			idle = 0;
		end
		else begin
			proximo = active;
			continuar = 4'b0000;	//4
			pausa = 4'b0000;	//4
			error_full = 0;
			idle = 0;
		end
	end else if(actual == error ) begin
			if(reset) begin
			proximo = rst;
			continuar = 4'b0000;	//4
			pausa = 4'b0000;	//4
			error_full = 1;
			idle = 0;
		end else begin
			proximo = error;
			continuar = 4'b0000;	//4
			pausa = 4'b0000;	//4
			error_full = 1;
			idle = 0;
		end
	end else if(actual == rst) begin
		if(!reset) begin
			proximo = init;
			continuar = 4'b0000;	//4
			pausa = 4'b0000;	//4
			error_full = 0;
			idle = 0;
		end
		else begin
			proximo = rst;
			continuar = 4'b0000;	//4
			pausa = 4'b0000;	//4
			error_full = 1;
			idle = 0;
		end
	end
	else 
		actual = active;
		proximo = idleEmpty;
		continuar = 4'b0000;	//4
		pausa = 4'b0000;	//4
		error_full = 0;
		idle = 0;

	end*/

	always @(*) begin
		proximo = actual;
		case(actual)

			active : begin
				if(full > 4'b0000) proximo = error;
					else if(almost_full > 4'b0000) proximo = pausa;
					else if(empty > 4'b0000) proximo = idleEmpty;
					else if(almost_empty > 4'b0000) proximo = continuee;
				else proximo = active;
			end

			continuee : begin 
				if(full > 4'b0000) proximo = error;
					else proximo =  active;
			end

			pause : begin 
				if(almost_full > 4'b0000) proximo = pause;
					else proximo =  active;
			end  

			idleEmpty : begin 
				if(|empty) proximo = active;
					else proximo = idleEmpty;
			end

			init : begin 
				if(iniciar) begin 
					proximo = 3'b011;//idleEmpty
				end
					else proximo = init;
			end

			error : begin  
				if (!reset) proximo = error;
					else proximo = rst;
			end

			rst :  begin
			       	if(reset)proximo = idleEmpty;
					else proximo = rst;
			end

			default : begin
				actual = actual;
				proximo = proximo;
			end

		endcase
	end

	always @(posedge clk) begin
	case(actual)

		init, active : begin
			continuar <= 0;
			pausa <= 0;
			error_full <= 0;
			idle <= 0;
		end

		continuee : begin 
			continuar <= 1;
			pausa <= 0;
			error_full <= 0;
			idle <= 0;
		end

		pause : begin 
			continuar <= 0;
			pausa <= 1;
			error_full <= 0;
			idle <= 0;
		end  

		idleEmpty : begin 
			continuar <= 0;
			pausa <= 0;
			error_full <= 0;
			idle <= 1;
		end

	/*	init : begin 
			continuar <= 0;
			pausa <= 0;
			error_full <= 0;
			idle <= 0;
		end
	*/
		error, rst : begin  
			continuar <= 0;
			pausa <= 0;
			error_full <= 1;
			idle <= 0;
		end

/*		rst :  begin 
			continuar <= 0;
			pausa <= 0;
			error_full <= 1;
			idle <= 0;
		end
		*/

	endcase
end
//*/
endmodule // fsm
`endif

