`timescale 1ns/1ps
module stimulus;

   integer 	  handle3;
   integer 	  desc3; 


   //Parameters
   parameter TARGET = "GENERIC"; //probably should be "SIM" or "XILINX"

   //Inputs 
   logic 	        clk;
   logic 	        rst;
   logic [3:0] 	    btn;
   logic [3:0] 	    sw;
   logic 	        phy_rx_clk;
   logic [3:0] 	    phy_rxd;
   logic 	        phy_rx_dv;
   logic 	        phy_rx_er;
   logic 	        phy_tx_clk;
   logic 	        phy_col;
   logic 	        phy_crs;
   logic 	        uart_rxd;

   //Outputs - may need to change outputs to better define sim
   logic 	        led0_r;
   logic 	        led0_g;
   logic 	        led0_b;
   logic 	        led1_r;
   logic 	        led1_g;
   logic 	        led1_b;
   logic 	        led2_r;
   logic 	        led2_g;
   logic 	        led2_b;
   logic 	        led3_r;
   logic 	        led3_g;
   logic 	        led3_b;
   logic 	        led4;
   logic 	        led5;
   logic 	        led6;
   logic 	        led7;
   logic [3:0] 	    phy_txd;
   logic 	        phy_tx_en;
   logic 	        phy_reset_n;
   logic 	        uart_txd;

   fpga_core #(
	       .TARGET(TARGET)
	       )
   dut (
	/*
	 * Clock: 125MHz
	 * Synchronous reset
	 */
	.clk(clk),
	.rst(rst),
      
	// GPIO

	.btn(btn),
	.sw(sw),
	.led0_r(led0_r),
	.led0_g(led0_g),
	.led0_b(led0_b),
	.led1_r(led1_r),
	.led1_g(led1_g),
	.led1_b(led1_b),
	.led2_r(led2_r),
	.led2_g(led2_g),
	.led2_b(led2_b),
	.led3_r(led3_r),
	.led3_g(led3_g),
	.led3_b(led3_b),
	.led4(led4),
	.led5(led5),
	.led6(led6),
	.led7(led7),

	/*
	 * Ethernet: 100BASE-T MII
	 */

	.phy_rx_clk(phy_rx_clk),
	.phy_rxd(phy_rxd),
	.phy_rx_dv(phy_rx_dv),
	.phy_rx_er(phy_rx_er),
	.phy_tx_clk(phy_tx_clk),
	.phy_txd(phy_txd),
	.phy_tx_en(phy_tx_en),
	.phy_col(phy_col),
	.phy_crs(phy_crs),
	.phy_reset_n(phy_reset_n),

	/*
	 * UART: 115200 bps, 8N1
	 */
	.uart_rxd(uart_rxd),
	.uart_txd(uart_txd)
	);

   // Clock generation
   initial begin
      clk = 1'b0;
      forever #4 clk = ~clk; // 125 MHz clock (8ns period)
   end

   initial begin
      handle3 = $fopen("ethernet.out");
      //$readmemh("d.tv", testvectors);	
      //vectornum = 0;
      //errors = 0;		
      desc3 = handle3;
   end

   // Monitor outputs
   initial begin
      $fdisplay(desc3, "Time: %0t | LED0: %b %b %b | LED1: %b %b %b | LED2: %b %b %b | LED3: %b %b %b | LED4: %b | LED5: %b | LED6: %b | LED7: %b",
                $time, led0_r, led0_g, led0_b, led1_r, led1_g, led1_b, led2_r, led2_g, led2_b, led3_r, led3_g, led3_b, led4, led5, led6, led7);
   end

endmodule

