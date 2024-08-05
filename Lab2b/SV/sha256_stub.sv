/*
 Secure Hash Standard (SHA-256)
 */

module sha_256	#(parameter MSG_SIZE = 24,
		  parameter PADDED_SIZE = 512)
   (input logic [MSG_SIZE-1:0] message,
    input logic 	 clk, rst,
    output logic [255:0] hashed,
    output logic 	 done);

	logic[PADDED_SIZE-1:0] padded;

	sha_padder #(.MSG_SIZE(MSG_SIZE), .PADDED_SIZE(PADDED_SIZE)) padder (.message(message), .padded(padded));
	sha_main #(.PADDED_SIZE(PADDED_SIZE)) loop (.padded(padded), .hashed(hashed), .clk(clk), .rst(rst), .done(done));
   
endmodule // sha_256

module sha_padder	#(parameter MSG_SIZE = 24,		// size of full message
			  parameter PADDED_SIZE = 512) 
   (input logic [MSG_SIZE-1:0] message,
    output logic [PADDED_SIZE-1:0] padded);


endmodule // sha_padder

module sha_main	#(parameter PADDED_SIZE = 512)
   (input logic [PADDED_SIZE-1:0] padded,
    output logic [255:0] hashed,
    output logic 	 done);


endmodule // sha_main

