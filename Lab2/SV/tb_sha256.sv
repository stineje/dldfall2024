`timescale 1ns/1ps
module stimulus;

   logic [127:0] message;   
   logic [255:0] hashed;

   logic 	 clk;
   logic [31:0]  errors;
   logic [31:0]  vectornum;
   logic [63:0]  result;
   logic [7:0] 	 op;   
   logic [199:0] testvectors[511:0];
     
   
   integer 	 handle3;
   integer 	 desc3;
   integer 	 i;  
   integer       j;

   sha_256 #(128, 512) dut (message, hashed);

   // 1 ns clock
   initial 
     begin	
	clk = 1'b1;
	forever #5 clk = ~clk;
     end

   initial
     begin
	handle3 = $fopen("sha256.out");
	vectornum = 0;
	errors = 0;		
	desc3 = handle3;
     end

   initial
     begin
	#0 message = 128'h48656c6c6f2c205348412d32353621;

     end
   

endmodule // stimulus
