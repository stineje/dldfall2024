`timescale 1ns/1ps
module stimulus;

   integer 	  handle3;
   integer 	  desc3; 


   //Parameters
   parameter TARGET = "GENERIC"; //probably should be "SIM" or "XILINX"

   //Inputs 
   logic 	  clk;
   logic 	  rst;
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
   //logic [47:0] tx_eth_dest_mac;

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
   logic 	  uart_txd;

//   logic [7:0] 	  data [0:7] = {8'h12, 8'h35, 8'h8a, 8'he8, 8'h3b, 8'h7c, 8'ha5, 8'had}; //how we will send data over

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
	//.tx_eth_dest_mac(tx_eth_dest_mac),
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
      //tx_eth_dest_mac = 48'h020000000000;
      //phy_rx_clk = 0;
      phy_rxd = 4'b0000;
      phy_rx_dv = 1'b0;
      phy_rx_er = 1'b0;
      //phy_tx_clk = 0;
      uart_rxd = 1'b1;
      phy_col = 1'b0;
      phy_crs = 1'b0;

      // Apply reset
      #20;
      rst = 1'b0;
      #20

      //start receiving data
      receive_frame();

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

   // adding task here to see if input data at least works
   task receive_frame;
      // Frame: `UUUUUUU\xd5\x02\x00\x00\x00\x00\x00ZQRSTU\x08\x00...` (similar to the cocotb frames sent)
      // Define your frame data here
      reg [7:0] frame_data [0:63]; // Adjust the size according to your frame length
      integer i;

      begin
         // Example frame data (Replace with actual data)
         frame_data[0] = 8'h55; // Start of preamble
         frame_data[1] = 8'h55; // Continue preamble
         frame_data[2] = 8'h55; // Continue preamble
         frame_data[3] = 8'h55; // Continue preamble
         frame_data[4] = 8'h55; // Continue preamble
         frame_data[5] = 8'h55; // Continue preamble
         frame_data[6] = 8'h55; // Continue preamble
         frame_data[7] = 8'hD5; // SFD
         frame_data[8] = 8'h02; //beginning of MAC destination
         frame_data[9] = 8'h00;
         frame_data[10] = 8'h00;
         frame_data[11] = 8'h00;
         frame_data[12] = 8'h00;
         frame_data[13] = 8'h00;
         frame_data[14] = 8'h5A; // Example data byte (Z) (beginning of MAC source)
         frame_data[15] = 8'h51; // Example data byte (Q)
         frame_data[16] = 8'h52; // Example data byte (R)
         frame_data[17] = 8'h53; // Example data byte (S)
         frame_data[18] = 8'h54; // Example data byte (T)
         frame_data[19] = 8'h55; // Example data byte (U)

         // Add more data bytes according to data that needs to be received

         // Start receiving data
         phy_rx_dv = 1'b1; // Enable receiving
         
         // Send each byte
         for (i = 0; i < 64; i = i + 1) begin
            #8; // Wait for one clock period (Adjust as needed)
            phy_rxd = frame_data[i][7:4]; // Send lower nibble
            #8; // Wait for next clock period
            phy_rxd = frame_data[i][3:0]; // Send upper nibble
         end

         //phy_rxd = 4'b1100; //value set for debugging
         // End transmission
         phy_rx_dv = 1'b0;
      end
   endtask

   // Monitor outputs
   initial begin
      $fdisplay(desc3, "Time: %0t | LED0: %b %b %b | LED1: %b %b %b | LED2: %b %b %b | LED3: %b %b %b | LED4: %b | LED5: %b | LED6: %b | LED7: %b",
                $time, led0_r, led0_g, led0_b, led1_r, led1_g, led1_b, led2_r, led2_g, led2_b, led3_r, led3_g, led3_b, led4, led5, led6, led7);
   end

endmodule

