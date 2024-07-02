`timescale 1ns/1ps
module stimulus;

   // Parameters
   parameter DATA_WIDTH = 8;
   parameter ENABLE_PADDING = 1;
   parameter MIN_FRAME_LENGTH = 64;
   parameter TX_PTP_TS_ENABLE = 0;
   parameter TX_PTP_TS_WIDTH = 96;
   parameter TX_PTP_TAG_ENABLE = TX_PTP_TS_ENABLE;
   parameter TX_PTP_TAG_WIDTH = 16;
   parameter RX_PTP_TS_ENABLE = 0;
   parameter RX_PTP_TS_WIDTH = 96;
   parameter TX_USER_WIDTH = (TX_PTP_TAG_ENABLE ? TX_PTP_TAG_WIDTH : 0) + 1;
   parameter RX_USER_WIDTH = (RX_PTP_TS_ENABLE ? RX_PTP_TS_WIDTH : 0) + 1;
   
   // Inputs (20)
   logic 		        rx_clk;
   logic 		        rx_rst;
   logic 		        tx_clk;
   logic 		        tx_rst;
   logic [DATA_WIDTH-1:0]       tx_axis_tdata = 0;
   logic 		        tx_axis_tvalid = 0;
   logic 		        tx_axis_tlast = 0;
   logic [TX_USER_WIDTH-1:0]    tx_axis_tuser = 0;
   logic [DATA_WIDTH-1:0]       gmii_rxd = 0;
   logic 		        gmii_rx_dv = 0;
   logic 		        gmii_rx_er = 0;
   logic [TX_PTP_TS_WIDTH-1:0]  tx_ptp_ts = 0;
   logic [RX_PTP_TS_WIDTH-1:0]  rx_ptp_ts = 0;
   logic 		        rx_clk_enable = 1;
   logic 		        tx_clk_enable = 1;
   logic 		        rx_mii_select = 0;
   logic 		        tx_mii_select = 0;
   logic [7:0] 		        ifg_delay = 0;
   
   // Outputs (15)
   logic 		        tx_axis_tready;
   logic [DATA_WIDTH-1:0]       rx_axis_tdata;
   logic 		        rx_axis_tvalid;
   logic 		        rx_axis_tlast;
   logic [RX_USER_WIDTH-1:0]    rx_axis_tuser;
   logic [DATA_WIDTH-1:0]       gmii_txd;
   logic 		        gmii_tx_en;
   logic 		        gmii_tx_er;
   logic [TX_PTP_TS_WIDTH-1:0]  tx_axis_ptp_ts;
   logic [TX_PTP_TAG_WIDTH-1:0] tx_axis_ptp_ts_tag;
   logic 			tx_axis_ptp_ts_valid;
   logic 			tx_start_packet;
   logic 			tx_error_underflow;
   logic 			rx_start_packet;
   logic 			rx_error_bad_frame;
   logic 			rx_error_bad_fcs;

   // Status
   logic 			stat_tx_mcf;
   logic 			stat_rx_mcf;
   logic 			stat_tx_lfc_pkt;
   logic 			stat_tx_lfc_xon;
   logic 			stat_tx_lfc_xoff;
   logic 			stat_tx_lfc_paused;
   logic 			stat_tx_pfc_pkt;
   logic [7:0] 			stat_tx_pfc_xon;
   logic [7:0] 			stat_tx_pfc_xoff;
   logic [7:0] 			stat_tx_pfc_paused;
   logic 			stat_rx_lfc_pkt;
   logic 			stat_rx_lfc_xon;
   logic 			stat_rx_lfc_xoff;
   logic 			stat_rx_lfc_paused;
   logic 			stat_rx_pfc_pkt;
   logic [7:0] 			stat_rx_pfc_xon;
   logic [7:0] 			stat_rx_pfc_xoff;
   logic [7:0] 			stat_rx_pfc_paused;   
   
   // Configuration
   logic [7:0] 			cfg_ifg;
   logic 			cfg_tx_enable;
   logic 			cfg_rx_enable;
   logic [47:0] 		cfg_mcf_rx_eth_dst_mcast;
   logic 			cfg_mcf_rx_check_eth_dst_mcast;
   logic [47:0] 		cfg_mcf_rx_eth_dst_ucast;
   logic 			cfg_mcf_rx_check_eth_dst_ucast;
   logic [47:0] 		cfg_mcf_rx_eth_src;
   logic 			cfg_mcf_rx_check_eth_src;
   logic [15:0] 		cfg_mcf_rx_eth_type;
   logic [15:0] 		cfg_mcf_rx_opcode_lfc;
   logic 			cfg_mcf_rx_check_opcode_lfc;
   logic [15:0] 		cfg_mcf_rx_opcode_pfc;
   logic 			cfg_mcf_rx_check_opcode_pfc;
   logic 			cfg_mcf_rx_forward;
   logic 			cfg_mcf_rx_enable;
   logic [47:0] 		cfg_tx_lfc_eth_dst;
   logic [47:0] 		cfg_tx_lfc_eth_src;
   logic [15:0] 		cfg_tx_lfc_eth_type;
   logic [15:0] 		cfg_tx_lfc_opcode;
   logic 			cfg_tx_lfc_en;
   logic [15:0] 		cfg_tx_lfc_quanta;
   logic [15:0] 		cfg_tx_lfc_refresh;
   logic [47:0] 		cfg_tx_pfc_eth_dst;
   logic [47:0] 		cfg_tx_pfc_eth_src;
   logic [15:0] 		cfg_tx_pfc_eth_type;
   logic [15:0] 		cfg_tx_pfc_opcode;
   logic 			cfg_tx_pfc_en;
   logic [8*16-1:0] 		cfg_tx_pfc_quanta;
   logic [8*16-1:0] 		cfg_tx_pfc_refresh;
   logic [15:0] 		cfg_rx_lfc_opcode;
   logic 			cfg_rx_lfc_en;
   logic [15:0] 		cfg_rx_pfc_opcode;
   logic 			cfg_rx_pfc_enq;

   // Priority Flow Control (PFC) (IEEE 802.3 annex 31D PFC)
   logic [7:0] 			tx_pfc_req;   
   logic 			tx_pfc_resend;   
   logic [7:0] 			rx_pfc_en;   
   logic [7:0] 			rx_pfc_req;   
   logic [7:0] 			rx_pfc_ack;   
				
   logic 			clk;
   logic [31:0] 		errors;
   logic [31:0] 		vectornum;
   logic [63:0] 		result;
   logic [7:0] 			op;   
   logic [199:0] 		testvectors[511:0];
   
   
   integer 			handle3;
   integer 			desc3;
   integer 			i;  
   integer 			j;

   eth_mac_1g #(
		.DATA_WIDTH(DATA_WIDTH),
		.ENABLE_PADDING(ENABLE_PADDING),
		.MIN_FRAME_LENGTH(MIN_FRAME_LENGTH),
		//.TX_PTP_TS_ENABLE(TX_PTP_TS_ENABLE),
		//.TX_PTP_TS_WIDTH(TX_PTP_TS_WIDTH),
		//.TX_PTP_TAG_ENABLE(TX_PTP_TAG_ENABLE),
		//.TX_PTP_TAG_WIDTH(TX_PTP_TAG_WIDTH),
		//.RX_PTP_TS_ENABLE(RX_PTP_TS_ENABLE),
		//.RX_PTP_TS_WIDTH(RX_PTP_TS_WIDTH),
		.TX_USER_WIDTH(TX_USER_WIDTH),
		.RX_USER_WIDTH(RX_USER_WIDTH)
		)
   UUT (.rx_clk(rx_clk),
	.rx_rst(rx_rst),
	.tx_clk(tx_clk),
	.tx_rst(tx_rst),
	.tx_axis_tdata(tx_axis_tdata),
	.tx_axis_tvalid(tx_axis_tvalid),
	.tx_axis_tready(tx_axis_tready),
	.tx_axis_tlast(tx_axis_tlast),
	.tx_axis_tuser(tx_axis_tuser),
	.rx_axis_tdata(rx_axis_tdata),
	.rx_axis_tvalid(rx_axis_tvalid),
	.rx_axis_tlast(rx_axis_tlast),
	.rx_axis_tuser(rx_axis_tuser),
	.gmii_rxd(gmii_rxd),
	.gmii_rx_dv(gmii_rx_dv),
	.gmii_rx_er(gmii_rx_er),
	.gmii_txd(gmii_txd),
	.gmii_tx_en(gmii_tx_en),
	.gmii_tx_er(gmii_tx_er),
	.tx_ptp_ts(tx_ptp_ts),
	.rx_ptp_ts(rx_ptp_ts),
	.tx_axis_ptp_ts(tx_axis_ptp_ts),
	.tx_axis_ptp_ts_tag(tx_axis_ptp_ts_tag),
	.tx_axis_ptp_ts_valid(tx_axis_ptp_ts_valid),
	.rx_clk_enable(rx_clk_enable),
	.tx_clk_enable(tx_clk_enable),
	.rx_mii_select(rx_mii_select),
	.tx_mii_select(tx_mii_select),
	.tx_start_packet(tx_start_packet),
	.tx_error_underflow(tx_error_underflow),
	.rx_start_packet(rx_start_packet),
	.rx_error_bad_frame(rx_error_bad_frame),
	.rx_error_bad_fcs(rx_error_bad_fcs),
	//.ifg_delay(ifg_delay)
	.cfg_rx_pfc_en(cfg_rx_pfc_en),
	.cfg_rx_pfc_opcode(cfg_rx_pfc_opcode),
	.cfg_rx_lfc_en(cfg_rx_lfc_en),
	.cfg_rx_lfc_opcode(cfg_rx_lfc_opcode),
	.cfg_tx_pfc_refresh(cfg_tx_pfc_refresh),
	.cfg_tx_pfc_quanta(cfg_tx_pfc_quanta),
	.cfg_tx_pfc_en(cfg_tx_pfc_en),
	.cfg_tx_pfc_opcode(cfg_tx_pfc_opcode),
	.cfg_tx_pfc_eth_type(cfg_tx_pfc_eth_type),
	.cfg_tx_pfc_eth_src(cfg_tx_pfc_eth_src),
	.cfg_tx_pfc_eth_dst(cfg_tx_pfc_eth_dst),
	.cfg_tx_lfc_refresh(cfg_tx_lfc_refresh),
	.cfg_tx_lfc_quanta(cfg_tx_lfc_quanta),
	.cfg_tx_lfc_en(cfg_tx_lfc_en),
	.cfg_tx_lfc_opcode(cfg_tx_lfc_opcode),
	.cfg_tx_lfc_eth_type(cfg_tx_lfc_eth_type),
	.cfg_tx_lfc_eth_src(cfg_tx_lfc_eth_src),
	.cfg_tx_lfc_eth_dst(cfg_tx_lfc_eth_dst),
	.cfg_mcf_rx_enable(cfg_mcf_rx_enable),
	.cfg_mcf_rx_forward(cfg_mcf_rx_forward),
	.cfg_mcf_rx_check_opcode_pfc(cfg_mcf_rx_check_opcode_pfc),
	.cfg_mcf_rx_opcode_pfc(cfg_mcf_rx_opcode_pfc),
	.cfg_mcf_rx_check_opcode_lfc(cfg_mcf_rx_check_opcode_lfc),
	.cfg_mcf_rx_opcode_lfc(cfg_mcf_rx_opcode_lfc),
	.cfg_mcf_rx_eth_type(cfg_mcf_rx_eth_type),
	.cfg_mcf_rx_check_eth_src(cfg_mcf_rx_check_eth_src),
	.cfg_mcf_rx_eth_src(cfg_mcf_rx_eth_src),
	.cfg_mcf_rx_check_eth_dst_ucast(cfg_mcf_rx_check_eth_dst_ucast),
	.cfg_mcf_rx_eth_dst_ucast(cfg_mcf_rx_eth_dst_ucast),
	.cfg_mcf_rx_check_eth_dst_mcast(cfg_mcf_rx_check_eth_dst_mcast),
	.cfg_mcf_rx_eth_dst_mcast(cfg_mcf_rx_eth_dst_mcast),
	.cfg_rx_enable(cfg_rx_enable),
	.cfg_tx_enable(cfg_tx_enable),
	.cfg_ifg(cfg_ifg),
	.stat_rx_pfc_paused(stat_rx_pfc_paused),
	.stat_rx_pfc_xoff(stat_rx_pfc_xoff),
	.stat_rx_pfc_xon(stat_rx_pfc_xon),
	.stat_rx_pfc_pkt(stat_rx_pfc_pkt),
	.stat_rx_lfc_paused(stat_rx_lfc_paused),
	.stat_rx_lfc_xoff(stat_rx_lfc_xoff),
	.stat_rx_lfc_xon(stat_rx_lfc_xon),
	.stat_rx_lfc_pkt(stat_rx_lfc_pkt),
	.stat_tx_pfc_paused(stat_tx_pfc_paused),
	.stat_tx_pfc_xoff(stat_tx_pfc_xoff),
	.stat_tx_pfc_xon(stat_tx_pfc_xon),
	.stat_tx_pfc_pkt(stat_tx_pfc_pkt),
	.stat_tx_lfc_paused(stat_tx_lfc_paused),
	.stat_tx_lfc_xoff(stat_tx_lfc_xoff),
	.stat_tx_lfc_xon(stat_tx_lfc_xon),
	.stat_tx_lfc_pkt(stat_tx_lfc_pkt),
	.stat_rx_mcf(stat_rx_mcf),
	.stat_tx_mcf(stat_tx_mcf),
	.tx_pause_ack(tx_pause_ack),
	.tx_pause_req(tx_pause_req),
	.tx_lfc_pause_en(tx_lfc_pause_en),
	.rx_pfc_ack(rx_pfc_ack),
	.rx_pfc_req(rx_pfc_req),
	.rx_pfc_en(rx_pfc_en),
	.tx_pfc_resend(tx_pfc_resend),
	.tx_pfc_req(tx_pfc_req),
	.rx_lfc_ack(rx_lfc_ack),
	.rx_lfc_req(rx_lfc_req),
	.rx_lfc_en(rx_lfc_en),
	.tx_lfc_resend(tx_lfc_resend),
	.tx_lfc_req(tx_lfc_req)	
	);


   

   // 1 ns clock
   initial 
     begin	
	rx_clk = 1'b1;
	forever #5 rx_clk = ~rx_clk;
     end

   initial 
     begin	
	tx_clk = 1'b1;	
	forever #5 tx_clk = ~tx_clk;	
     end

   initial
     begin
	handle3 = $fopen("ethernet.out");
	//$readmemh("d.tv", testvectors);	
	vectornum = 0;
	errors = 0;		
	desc3 = handle3;
     end

   initial
     begin
	#0 tx_rst = 1'b1;	
	#0 rx_rst = 1'b1;
	#142 rx_rst = 1'b0;
     end
	  


endmodule // stimulus
