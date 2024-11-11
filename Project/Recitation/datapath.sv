module datapath (input logic [15:0] A, 
		 input logic 	     init, en1, reset, clk,
		 output logic [15:0] Z);

   logic [15:0] 		     Sum;
   logic [15:0] 		     M;   
   
   mux2 #(16) sel (A, Z, init, M);
   assign Sum = M + 16'h2A;
   flopenr #(16) reg1 (clk, reset, en1, Sum, Z);

endmodule // datapath

   
   
