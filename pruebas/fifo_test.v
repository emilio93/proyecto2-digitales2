`timescale 1ns/1ps
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
parameter BUF_WIDTH3 =3;//fifo 8posiciones de memoria
parameter BUF_WIDTH4 =4;//fifo 16posiciones de memoria
reg clk, rst, wr_en, rd_en ;
reg[3:0] buf_in;
reg[3:0] tempdata;
wire buf_full, buf_empty, almost_full, almost_empty;
wire buf_fullSynth, buf_emptySynth, almost_fullSynth, almost_emptySynth;
wire [3:0] buf_out, buf_outSynth;
wire [BUF_WIDTH3 :0] fifo_counter, fifo_counterSynth;

fifo #(.BUF_WIDTH(BUF_WIDTH3)) ff(
	.buf_in(buf_in), .buf_out(buf_out),//datos entrada y salida
	.clk(clk), .rst(rst), .wr_en(wr_en), .rd_en(rd_en),//señales de control
	.buf_empty(buf_empty), .buf_full(buf_full),//banderas de estado del fifo
	.almost_full(almost_full), .almost_empty(almost_empty),
	.fifo_counter(fifo_counter) //contador de datos en fifo
	);

fifoSynth ffSynth(
	.buf_in(buf_in), .buf_out(buf_outSynth),
	.clk(clk), .rst(rst), .wr_en(wr_en), .rd_en(rd_en),
	.buf_empty(buf_emptySynth), .buf_full(buf_fullSynth),
	.almost_full(almost_fullSynth), .almost_empty(almost_emptySynth),
	.fifo_counter(fifo_counterSynth)
	);

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
        push(2);
        push(3);
        push(4);
        push(5);
        push(6);
        push(7);
        push(8);
        push(9);
        push(10);
        push(11);
        push(12);
        push(13);

        pop(tempdata);
        push(tempdata);
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
        push(14);
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
input [3:0] data;
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
output [3:0] data;

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
