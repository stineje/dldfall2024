`timescale 1ns/1ps
module stimulus;

   parameter MSG_SIZE = 96;   

   logic [MSG_SIZE-1:0] message;   
   logic [255:0] hashed;

   logic 	 clk;
   logic [31:0]  errors;
   logic [31:0]  vectornum;
   logic [63:0]  result;
   // Size of [351:0] is size of vector in file: 96 + 256 = 352 bits
   logic [351:0] testvectors[511:0];
   
   integer 	 handle3;
   integer 	 desc3;
   integer 	 i;  
   integer       j;

   // Instantiate DUT
   top #(MSG_SIZE, 512) dut (message, hashed);

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

    // apply test vectors on rising edge of clk
   always @(posedge clk)
     begin
        #1; {message, result} = testvectors[vectornum];
     end  

   // check results on falling edge of clk
   always @(negedge clk)
     begin
	if (result != hashed)
          errors = errors + 1;
        $fdisplay(desc3, "%h %h || %h || %b", 
                  message, hashed, result, (result == hashed));
	vectornum = vectornum + 1;
	if (testvectors[vectornum] === 352'bx) 
          begin 
             $display("%d tests completed with %d errors", 
                      vectornum, errors);
             $finish;
          end
     end   

endmodule // stimulus
