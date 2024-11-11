`timescale 1ns / 1ps
module tb ();

   logic [15:0] A;
   logic 	init;
   logic 	en1;
   logic 	reset;
   logic [15:0] Z;
   
   logic 	clk;
   
  // instantiate device under test
   datapath dut (A, init, en1, reset, clk, Z);

   initial 
     begin	
	clk = 1'b1;
	forever #10 clk = ~clk;
     end

   initial
     begin
	#0  reset = 1'b1;
	#0  init = 1'b1;
	#0  en1 = 1'b0;
	#0  A = 16'h3010;
	#51 reset = 1'b0;
	#5  en1 = 1'b1;
	#10 init = 1'b0;
	#85 en1 = 1'b0;
	
	
     end

   
endmodule
