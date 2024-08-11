//
// Secure Hash Standard (SHA-256)
//

module top #(parameter MSG_SIZE = 24,
	     parameter PADDED_SIZE = 512)
   (input logic [MSG_SIZE-1:0] message,
    output logic [255:0] hashed);

   logic [PADDED_SIZE-1:0] padded;
   
   
endmodule // sha_256

module sha_padder #(parameter MSG_SIZE = 24,	     
		    parameter PADDED_SIZE = 512) 
   (input logic [MSG_SIZE-1:0] message,
    output logic [PADDED_SIZE-1:0] padded);


endmodule // sha_padder

module sha256 #(parameter PADDED_SIZE = 512)
   (input logic [PADDED_SIZE-1:0] padded,
    output logic [255:0] hashed);   

   logic [255:0] H = {32'h6a09e667, 32'hbb67ae85,
		      32'h3c6ef372, 32'ha54ff53a, 32'h510e527f, 32'h9b05688c,
		      32'h1f83d9ab, 32'h5be0cd19};   
	
   logic [2047:0] K = {32'h428a2f98, 32'h71374491, 32'hb5c0fbcf,
		       32'he9b5dba5, 32'h3956c25b, 32'h59f111f1, 32'h923f82a4,
		       32'hab1c5ed5, 32'hd807aa98, 32'h12835b01, 32'h243185be,
		       32'h550c7dc3, 32'h72be5d74, 32'h80deb1fe, 32'h9bdc06a7,
		       32'hc19bf174, 32'he49b69c1, 32'hefbe4786, 32'h0fc19dc6,
		       32'h240ca1cc, 32'h2de92c6f, 32'h4a7484aa, 32'h5cb0a9dc,
		       32'h76f988da, 32'h983e5152, 32'ha831c66d, 32'hb00327c8,
		       32'hbf597fc7, 32'hc6e00bf3, 32'hd5a79147, 32'h06ca6351,
		       32'h14292967, 32'h27b70a85, 32'h2e1b2138, 32'h4d2c6dfc,
		       32'h53380d13, 32'h650a7354, 32'h766a0abb, 32'h81c2c92e,
		       32'h92722c85, 32'ha2bfe8a1, 32'ha81a664b, 32'hc24b8b70,
		       32'hc76c51a3, 32'hd192e819, 32'hd6990624, 32'hf40e3585,
		       32'h106aa070, 32'h19a4c116, 32'h1e376c08, 32'h2748774c,
		       32'h34b0bcb5, 32'h391c0cb3, 32'h4ed8aa4a, 32'h5b9cca4f,
		       32'h682e6ff3, 32'h748f82ee, 32'h78a5636f, 32'h84c87814,
		       32'h8cc70208, 32'h90befffa, 32'ha4506ceb, 32'hbef9a3f7,
		       32'hc67178f2};

   // Definie your intermediate variables here (forgetting them assumes variables are 1-bit)
   logic [31:0]   a, b, c, d, e, f, g, h;
   logic [31:0]   a63_out, b63_out, c63_out, d63_out, e63_out, f63_out, g63_out, h63_out;
   logic [31:0]   h0, h1, h2, h3, h4, h5, h6, h7;

   // Initialize a through h
   
   // 64 hash computations   
   main_comp mc01 ( ); // add arguments within parenthesis
   main_comp mc02 ( ); // add arguments within parenthesis
   main_comp mc03 ( ); // add arguments within parenthesis
   main_comp mc04 ( ); // add arguments within parenthesis
   main_comp mc05 ( ); // add arguments within parenthesis
   main_comp mc06 ( ); // add arguments within parenthesis
   main_comp mc07 ( ); // add arguments within parenthesis
   main_comp mc08 ( ); // add arguments within parenthesis
   main_comp mc09 ( ); // add arguments within parenthesis
   
   main_comp mc10 ( ); // add arguments within parenthesis
   main_comp mc11 ( ); // add arguments within parenthesis   
   main_comp mc12 ( ); // add arguments within parenthesis   
   main_comp mc13 ( ); // add arguments within parenthesis
   main_comp mc14 ( ); // add arguments within parenthesis
   main_comp mc15 ( ); // add arguments within parenthesis
   main_comp mc16 ( ); // add arguments within parenthesis
   main_comp mc17 ( ); // add arguments within parenthesis
   main_comp mc18 ( ); // add arguments within parenthesis
   main_comp mc19 ( ); // add arguments within parenthesis

   main_comp mc20 ( ); // add arguments within parenthesis
   main_comp mc21 ( ); // add arguments within parenthesis   
   main_comp mc22 ( ); // add arguments within parenthesis   
   main_comp mc23 ( ); // add arguments within parenthesis
   main_comp mc24 ( ); // add arguments within parenthesis
   main_comp mc25 ( ); // add arguments within parenthesis
   main_comp mc26 ( ); // add arguments within parenthesis
   main_comp mc27 ( ); // add arguments within parenthesis
   main_comp mc28 ( ); // add arguments within parenthesis
   main_comp mc29 ( ); // add arguments within parenthesis

   main_comp mc30 ( ); // add arguments within parenthesis
   main_comp mc31 ( ); // add arguments within parenthesis   
   main_comp mc32 ( ); // add arguments within parenthesis   
   main_comp mc33 ( ); // add arguments within parenthesis
   main_comp mc34 ( ); // add arguments within parenthesis
   main_comp mc35 ( ); // add arguments within parenthesis
   main_comp mc36 ( ); // add arguments within parenthesis
   main_comp mc37 ( ); // add arguments within parenthesis
   main_comp mc38 ( ); // add arguments within parenthesis
   main_comp mc39 ( ); // add arguments within parenthesis

   main_comp mc40 ( ); // add arguments within parenthesis
   main_comp mc41 ( ); // add arguments within parenthesis   
   main_comp mc42 ( ); // add arguments within parenthesis   
   main_comp mc43 ( ); // add arguments within parenthesis
   main_comp mc44 ( ); // add arguments within parenthesis
   main_comp mc45 ( ); // add arguments within parenthesis
   main_comp mc46 ( ); // add arguments within parenthesis
   main_comp mc47 ( ); // add arguments within parenthesis
   main_comp mc48 ( ); // add arguments within parenthesis
   main_comp mc49 ( ); // add arguments within parenthesis

   main_comp mc50 ( ); // add arguments within parenthesis
   main_comp mc51 ( ); // add arguments within parenthesis   
   main_comp mc52 ( ); // add arguments within parenthesis   
   main_comp mc53 ( ); // add arguments within parenthesis
   main_comp mc54 ( ); // add arguments within parenthesis
   main_comp mc55 ( ); // add arguments within parenthesis
   main_comp mc56 ( ); // add arguments within parenthesis
   main_comp mc57 ( ); // add arguments within parenthesis
   main_comp mc58 ( ); // add arguments within parenthesis
   main_comp mc59 ( ); // add arguments within parenthesis

   main_comp mc60 ( ); // add arguments within parenthesis
   main_comp mc61 ( ); // add arguments within parenthesis   
   main_comp mc62 ( ); // add arguments within parenthesis   
   main_comp mc63 ( ); // add arguments within parenthesis
   main_comp mc64 ( ); // add arguments within parenthesis

   intermediate_hash ih1 (a63_out, b63_out, c63_out, d63_out,
			  e63_out, f63_out, g63_out, h63_out,
			  a, b, c, d, e, f, g, h,
			  h0, h1, h2, h3, h4, h5, h6, h7);
   // Final output
   assign hashed = {};

endmodule // sha_main

module prepare (input logic [31:0] M0, M1, M2, M3,
		input logic [31:0]  M4, M5, M6, M7,
		input logic [31:0]  M8, M9, M10, M11,
		input logic [31:0]  M12, M13, M14, M15,
		output logic [31:0] W0, W1, W2, W3, W4, 
		output logic [31:0] W5, W6, W7, W8, W9,
		output logic [31:0] W10, W11, W12, W13, W14, 
		output logic [31:0] W15, W16, W17, W18, W19,
		output logic [31:0] W20, W21, W22, W23, W24, 
		output logic [31:0] W25, W26, W27, W28, W29,
		output logic [31:0] W30, W31, W32, W33, W34, 
		output logic [31:0] W35, W36, W37, W38, W39,
		output logic [31:0] W40, W41, W42, W43, W44, 
		output logic [31:0] W45, W46, W47, W48, W49,
		output logic [31:0] W50, W51, W52, W53, W54, 
		output logic [31:0] W55, W56, W57, W58, W59,
		output logic [31:0] W60, W61, W62, W63);

endmodule // prepare


module main_comp (input logic [31:0] a_in, b_in, c_in, d_in, e_in, f_in, g_in, h_in,
		  input logic [31:0] K_in, W_in,
		  output logic [31:0] a_out, b_out, c_out, d_out, e_out, f_out, g_out,
		  output logic [31:0] h_out);


endmodule // main_comp

module intermediate_hash (input logic [31:0] a_in, b_in, c_in, d_in, e_in, f_in, g_in, h_in,
			  input logic [31:0]  h0_in, h1_in, h2_in, h3_in, h4_in, h5_in, h6_in, h7_in, 
			  output logic [31:0] h0_out, h1_out, h2_out, h3_out, h4_out, h5_out, h6_out, h7_out);

   assign h0_out = a_in + h0_in;
   assign h1_out = b_in + h1_in;
   assign h2_out = c_in + h2_in;
   assign h3_out = d_in + h3_in;
   assign h4_out = e_in + h4_in;
   assign h5_out = f_in + h5_in;
   assign h6_out = g_in + h6_in;
   assign h7_out = h_in + h7_in;
   
endmodule
			  
module majority (input logic [31:0] x, y, z, output logic [31:0] maj);


endmodule // majority

module choice (input logic [31:0] x, y, z, output logic [31:0] ch);


endmodule // choice

module Sigma0 (input logic [31:0] x, output logic [31:0] Sig0);


endmodule // Sigma0

module sigma0 (input logic [31:0] x, output logic [31:0] sig0);


endmodule // sigma0

module Sigma1 (input logic [31:0] x, output logic [31:0] Sig1);


endmodule // Sigma1

module sigma1 (input logic [31:0] x, output logic [31:0] sig1);


endmodule // sigma1

     
   

