//Memoria con contadores de transicion
//Definicion del numero de contadores de transiciones a usar
//NumPwrCntr debe tener el numero de contadores N, menos uno: NumPwrCntr = N - 1
//Ndir debe ser tal que (2^(Ndir+1) - 1) > NumPwrCntr. De lo contrario los "for" nunca se detienen.
`timescale 1ns/1ps
`define NumPwrCntr 4
`define Ndir 3
//N=12
module memTrans (dir, LE, dato);
  input [`Ndir:0] dir;
  input LE;
  inout [31:0] dato;
  reg [31:0] PwrCntr [`NumPwrCntr:0];

  //Control de E/S del puerto de datos
  assign dato = (LE)? PwrCntr[dir] : 32'bz;

  //Ciclo de escritura para la memoria
  always @(dir or negedge LE or dato)
    begin
      if (~LE) //escritura
        PwrCntr[dir] <= dato;
    end

endmodule
