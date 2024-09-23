`timescale 1ns/1ps
module stimulus;

   integer 	  handle3;
   integer 	  desc3; 


   //Parameters
   parameter TARGET = "GENERIC"; //probably should be "SIM" or "XILINX"

   //Inputs 
   logic 	  clk;
   logic 	  rst;
   logic valid;
   logic [3:0] 	  btn;
   logic [3:0] 	  sw;
   logic 	  phy_rx_clk;
   logic [3:0] 	  phy_rxd;
   logic 	  phy_rx_dv;
   logic 	  phy_rx_er;
   logic 	  phy_tx_clk;
   logic 	  phy_col;
   logic 	  phy_crs;
   logic 	  uart_rxd;
   logic      phy_tx_ready;

   //Outputs - may need to change outputs to better define sim
   logic 	  led0_r;
   logic 	  led0_g;
   logic 	  led0_b;
   logic 	  led1_r;
   logic 	  led1_g;
   logic 	  led1_b;
   logic 	  led2_r;
   logic 	  led2_g;
   logic 	  led2_b;
   logic 	  led3_r;
   logic 	  led3_g;
   logic 	  led3_b;
   logic 	  led4;
   logic 	  led5;
   logic 	  led6;
   logic 	  led7;
   logic [3:0] 	  phy_txd;
   logic 	  phy_tx_en;
   logic 	  phy_reset_n;
    logic       phy_tx_last;

   logic 	  uart_txd;

   fpga_eth 
   //took out the constant parameters bc they were throwing issues
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
	//.tx_eth_dest_mac(tx_eth_dest_mac),
   .valid(valid),
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
    .phy_tx_ready(phy_tx_ready),
    .phy_tx_last(phy_tx_last),

	/*
	 * UART: 115200 bps, 8N1
	 */
	.uart_rxd(uart_rxd),
	.uart_txd(uart_txd)
	);

   // Clock generation
   initial begin
      clk = 1'b0;
      forever #5 clk = ~clk; // 100 MHz clock (8ns period)
   end

   initial begin
      phy_rx_clk = 1'b0;
      forever #4 phy_rx_clk = ~phy_rx_clk; // 125 MHz clock (8ns period)
   end

   initial begin
      phy_tx_clk = 1'b0;
      forever #4 phy_tx_clk = ~phy_tx_clk; // 125 MHz clock (8ns period)
   end

   initial begin
      handle3 = $fopen("ethernet.out");
      //$readmemh("d.tv", testvectors);	
      //vectornum = 0;
      //errors = 0;		
      desc3 = handle3;
   end

   // Test stimulus
   initial begin
      // Initialize inputs
      rst = 1;
      btn = 4'b0000;
      sw = 4'b0000;
      //phy_rxd = 4'b0000;
      phy_rx_dv = 1'b1;
      phy_tx_ready = 1'b1;
      phy_rx_er = 1'b0;
      uart_rxd = 1'b1;
      phy_col = 1'b0;
      phy_crs = 1'b0;

      // Apply reset
      #20;
      rst = 1'b0;
      #20

      //start receiving data
      //receive_frame();

      // Apply stimulus here
      // Example: Set buttons and switches
      //#10;
      //btn = 4'b0001;
      //sw = 4'b0010;

      // Example: Stimulate Ethernet interface
      // #10;
      // phy_rx_dv = 1;
      // phy_rxd = 4'b1100;

      // Example: Apply UART signal
      // #10;
      // uart_rxd = 1; //probably unneeded

      // Release reset and check functionality
      #100;
      rst = 1;
      #10;
      rst = 0;

      // Wait for simulation to finish
      //#1000;
      $finish;
   end
endmodule