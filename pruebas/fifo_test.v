`timescale 1ns/1ps
`define BUF_WIDTH 3

//liberia de celdas cmos
`ifndef cmos_cells
	`include "../lib/cmos_cells.v"
`endif
//include de design under test(DUT), units under test(UUT)
`ifndef fifo
  `include "../bloques/FIFO/fifo.v"
`endif
`ifndef fifoSynth
  `include "../build/fifo-sintetizado.v"
`endif

module fifo_test();
reg clk, rst, wr_en, rd_en ;
reg[7:0] buf_in;
reg[7:0] tempdata;
wire buf_full, buf_fullSynth, buf_empty, buf_emptySynth;
wire [7:0] buf_out, buf_outSynth;
wire [`BUF_WIDTH :0] fifo_counter, fifo_counterSynth;

fifo ff( .clk(clk), .rst(rst), .buf_in(buf_in), .buf_out(buf_out),
         .wr_en(wr_en), .rd_en(rd_en), .buf_empty(buf_empty),
         .buf_full(buf_full), .fifo_counter(fifo_counter) );

fifoSynth ffSynth( .clk(clk), .rst(rst), .buf_in(buf_in), .buf_out(buf_outSynth),
         .wr_en(wr_en), .rd_en(rd_en), .buf_empty(buf_emptySynth),
         .buf_full(buf_fullSynth), .fifo_counter(fifo_counterSynth) );

initial
begin
  $dumpfile("gtkws/fifo_test.vcd");
  $dumpvars();
   clk = 0;
   rst = 1;
        rd_en = 0;
        wr_en = 0;
        tempdata = 0;
        buf_in = 0;


        #15 rst = 0;

        push(1);
        fork
           push(2);
           pop(tempdata);
        join              //push and pop together
        push(10);
        push(20);
        push(30);
        push(40);
        push(50);
        push(60);
        push(70);
        push(80);
        push(90);
        push(100);
        push(110);
        push(120);
        push(130);

        pop(tempdata);
        push(tempdata);
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
        push(140);
        pop(tempdata);
        push(tempdata);//
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
        push(5);
        pop(tempdata);
        #15 $finish;
end

always
   #5 clk = ~clk;

task push;
input[7:0] data;


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
output [7:0] data;

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
