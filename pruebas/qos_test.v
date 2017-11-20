`timescale 1ns/1ps

`define isTest 1

`include "includes.v"

`include "../bloques/qos/qos.v"
`include "../build/qos-sintetizado.v"
`include "../testers/qosTester.v"

module qos_test #(
  parameter QUEUE_QUANTITY = 4, // se utilizan 4 filas fifo
  parameter DATA_BITS = 8,      // Los datos son de 8 bits
  parameter BUF_WIDTH = 3,      // Los datos son de 8 bits
  parameter MAX_WEIGHT = 64,    // El peso máximo es de 64 = 2^6
  parameter TABLE_SIZE = 8      // Tamaño de la tabla de arbitraje
)();

qos qos(
);

qosSynth qosSynth(
);

always # 5 clk = ~clk;

initial
begin
  $dumpfile("gtkws/qos_test.vcd");
  $dumpvars();
end


task push;
input [(DATA_WIDTH-1):0] data;
   if( buf_full )
            $display("---Cannot push: Buffer Full---");
        else
        begin
           $display("Pushed ",data );
					 buf_in = data;
					 wr_en = 1;
                @(posedge clk);
                #1 wr_en = 0;
        end
endtask

task pop;
output [(DATA_WIDTH-1):0] data;

   if( buf_empty )
            $display("---Cannot Pop: Buffer Empty---");
   else
        begin

     rd_en = 1;
          @(posedge clk);

          #1 rd_en = 0;
          data = buf_out;
           $display("-------------------------------Poped ", data);

        end
endtask

endmodule
