`timescale 1ns/1ps
//para estaciar se usar el siguiente orden
//fifo #(.BUF_WIDTH(4)) instancia_fifo1 (asignacion de puertos .clk(clk1),... ) ;
module fifo #(parameter BUF_WIDTH = 3)//cantidad de bits de direccionamiento a/y posiciones de memoria del fifo
 (
  output reg buf_empty, buf_full, almost_full, almost_empty, //banderas de estatus
  output reg [3:0] buf_out,//port to output the data using pop.
  output reg [BUF_WIDTH :0] fifo_counter, // number of data pushed in to buffer
  input clk, rst, wr_en, rd_en, // reset, system clock, write enable and read enable.
  input [3:0] buf_in//data input to be pushed to buffer
);
//Parametros y varibles internas
// BUF_SIZE = 16 -> BUF_WIDTH = 4, no. of bits to be used in pointer
parameter BUF_SIZE = ( 1<<BUF_WIDTH ); // 1 << 3 = 100 binario = 8 decimal, 8 posiciones de memoria
reg [(BUF_WIDTH-1):0]  rd_ptr, wr_ptr; // pointer to read and write addresses
reg [3:0] buf_mem [(BUF_SIZE-1) : 0]; // Memoria: 4bits * (BUF_SIZE-1)posiciones

//banderas segun conteo de datos en el fifo
always @(fifo_counter)
begin
   buf_empty = (fifo_counter==0);
   buf_full = (fifo_counter== BUF_SIZE);

end

//conteo de datos en el fifo ingresados o sacados
always @(posedge clk or posedge rst)
begin
   if( rst )
       fifo_counter <= 0;

   else if( (!buf_full && wr_en) && ( !buf_empty && rd_en ) )
       fifo_counter <= fifo_counter;

   else if( !buf_full && wr_en )
       fifo_counter <= fifo_counter + 1;

   else if( !buf_empty && rd_en )
       fifo_counter <= fifo_counter - 1;

   else
      fifo_counter <= fifo_counter;
end

//pop, leer datos desde el fifo
always @( posedge clk or posedge rst)
begin
   if( rst )
      buf_out <= 0;
   else
   begin
      if( rd_en && !buf_empty )
         buf_out <= buf_mem[rd_ptr];

      else
         buf_out <= buf_out;

   end
end

//push, escribir datos en el fifo
always @(posedge clk)
begin

   if( wr_en && !buf_full )
      buf_mem[ wr_ptr ] <= buf_in;

   else
      buf_mem[ wr_ptr ] <= buf_mem[ wr_ptr ];
end

//control de punteros de lectura y escritura
always@(posedge clk or posedge rst)
begin
   if( rst )
   begin
      wr_ptr <= 0;
      rd_ptr <= 0;
   end
   else
   begin
      if( !buf_full && wr_en )    wr_ptr <= wr_ptr + 1;
          else  wr_ptr <= wr_ptr;

      if( !buf_empty && rd_en )   rd_ptr <= rd_ptr + 1;
      else rd_ptr <= rd_ptr;
   end

end
endmodule
