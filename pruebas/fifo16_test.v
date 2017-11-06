`timescale 1ns/1ps
//liberia de celdas cmos
`ifndef cmos_cells
	`include "../lib/cmos_cells.v"
`endif
//include de design under test(DUT), units under test(UUT)
`ifndef fifo16
  `include "../bloques/fifo/fifo16.v"
`endif
`ifndef fifo16Synth
  `include "../build/fifo16-sintetizado.v"
`endif

module fifo16_test #(parameter BUF_WIDTH = 4, parameter DATA_WIDTH = 4) ();
reg clk, rst, wr_en, rd_en ;
reg[(DATA_WIDTH-1):0] buf_in;
reg[(DATA_WIDTH-1):0] tempdata;
wire buf_full, buf_empty, almost_full, almost_empty;
wire buf_fullSynth, buf_emptySynth, almost_fullSynth, almost_emptySynth;
wire [(DATA_WIDTH-1):0] buf_out, buf_outSynth;
wire [BUF_WIDTH :0] fifo_counter, fifo_counterSynth;

fifo16 #(.BUF_WIDTH(BUF_WIDTH), .DATA_WIDTH(DATA_WIDTH)) ff16(
	.buf_in(buf_in), .buf_out(buf_out),//datos entrada y salida
	.clk(clk), .rst(rst), .wr_en(wr_en), .rd_en(rd_en),//señales de control
	.buf_empty(buf_empty), .buf_full(buf_full),//banderas de estado del fifo
	.almost_full(almost_full), .almost_empty(almost_empty),
	.fifo_counter(fifo_counter) //contador de datos en fifo
	);

fifo16Synth ff16Synth(
	.buf_in(buf_in), .buf_out(buf_outSynth),
	.clk(clk), .rst(rst), .wr_en(wr_en), .rd_en(rd_en),
	.buf_empty(buf_emptySynth), .buf_full(buf_fullSynth),
	.almost_full(almost_fullSynth), .almost_empty(almost_emptySynth),
	.fifo_counter(fifo_counterSynth)
	);

initial
begin
  $dumpfile("gtkws/fifo16_test.vcd");
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
				push(14);
				push(15);
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
