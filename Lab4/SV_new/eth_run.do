# Copyright 1991-2016 Mentor Graphics Corporation
# 
# Modification by Oklahoma State University
# Use with Testbench 
# James Stine, 2008
# Go Cowboys!!!!!!
#
# All Rights Reserved.
#
# THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
# WHICH IS THE PROPERTY OF MENTOR GRAPHICS CORPORATION
# OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.

# Use this run.do file to run this example.
# Either bring up ModelSim and type the following at the "ModelSim>" prompt:
#     do run.do
# or, to run from a shell, type the following at the shell prompt:
#     vsim -do eth_run.do -c
# (omit the "-c" to see the GUI while running from the shell)

onbreak {resume}

# create library
if [file exists work] {
    vdel -all
}
vlib work

# compile source files

vlog ../Arty/fpga/rtl/fpga_core.v
#vlog ../../verilog-ethernet/rtl/*.v
#vlog ../../verilog-ethernet/lib/axis/rtl/*.v
vlog eth_tb.sv

vlog ../src/eth_mac_mii_fifo.v
vlog ../src/eth_mac_mii.v
vlog ../src/ssio_sdr_in.v
vlog ../src/mii_phy_if.v
vlog ../src/eth_mac_1g.v
vlog ../src/axis_gmii_rx.v
vlog ../src/axis_gmii_tx.v
vlog ../src/lfsr.v
vlog ../src/eth_axis_rx.v 
vlog ../src/eth_axis_tx.v
vlog ../src/udp_complete.v 
vlog ../src/udp_checksum_gen.v
vlog ../src/udp.v
vlog ../src/udp_ip_rx.v
vlog ../src/udp_ip_tx.v
vlog ../src/ip_complete.v 
vlog ../src/ip.v 
vlog ../src/ip_eth_rx.v
vlog ../src/ip_eth_tx.v 
vlog ../src/ip_arb_mux.v  
vlog ../src/arp.v
vlog ../src/arp_cache.v
vlog ../src/arp_eth_rx.v
vlog ../src/arp_eth_tx.v
vlog ../src/eth_arb_mux.v
vlog ../src/arbiter.v
vlog ../src/priority_encoder.v
vlog ../src/axis_fifo.v
vlog ../src/axis_async_fifo.v
vlog ../src/axis_async_fifo_adapter.v
vlog ../src/mac_ctrl_tx.v
vlog ../src/mac_ctrl_rx.v
vlog ../src/mac_pause_ctrl_tx.v
vlog ../src/mac_pause_ctrl_rx.v




# start and run simulation
vsim -voptargs=+acc work.stimulus

view list
view wave

-- display input and output signals as hexidecimal values
# Diplays All Signals recursively
#add wave -hex -r /stimulus/*

#Misc
#add wave -noupdate -divider -height 32 "Misc"
#add wave -hex -r /stimulus/dut/eth_mac_inst/tx_fifo/fifo_inst/*
#add wave -hex -r /stimulus/dut/eth_mac_inst/rx_fifo/fifo_inst/* //both tx and rx instantiations
#add wave -hex -r /stimulus/dut/eth_axis_tx_inst/*
#add wave -hex /stimulus/dut/tx_eth_dest_mac
#add wave -hex /stimulus/dut/tx_eth_src_mac
#add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/eth_mac_1g_inst/MAC_CTRL_ENABLE
#add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/eth_mac_1g_inst/mac_ctrl/tx_mcf_eth_dst
#add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/eth_mac_1g_inst/mac_ctrl/mac_pause_ctrl_tx_inst/*
#add wave -hex /stimulus/dut/udp_complete_inst/ip_complete_inst/eth_arb_mux_inst/*
#add wave -hex /stimulus/dut/udp_complete_inst/ip_complete_inst/*
#add wave -hex /stimulus/dut/udp_complete_inst/ip_complete_inst/arp_inst/*

#path to tx_eth variables to see if they changed at all during testing
add wave -hex /stimulus/dut/tx_eth_dest_mac
add wave -hex /stimulus/dut/tx_eth_src_mac

#Analyzing the path from received data to PHY/MAC in order to find where data set
#add wave -hex /stimulus/dut/phy_rxd
#add wave -hex /stimulus/dut/eth_mac_inst/mii_rxd
#add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/mii_rxd
#add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/mii_phy_if_inst/phy_mii_rxd
#add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/mii_phy_if_inst/rx_ssio_sdr_inst/input_d
#add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/mii_phy_if_inst/rx_ssio_sdr_inst/output_q
#add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/mii_phy_if_inst/mac_mii_rxd
#add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/mac_mii_rxd
#add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/eth_mac_1g_inst/gmii_rxd
#add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/eth_mac_1g_inst/axis_gmii_rx_inst/gmii_rxd
#add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/eth_mac_1g_inst/axis_gmii_rx_inst/gmii_rxd_d*
# gap between steps here...
#add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/eth_mac_1g_inst/rx_axis_tdata_int
#data seems to have made it to rx_axis_tdata_int - need to find how transmitted out

#analyszing path being transmitted out
add wave -hex /stimulus/phy_txd
#add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/eth_mac_1g_inst/cfg_tx_enable
#add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/eth_mac_1g_inst/cfg_tx_pfc_en
#add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/eth_mac_1g_inst/cfg_tx_pfc_eth_src
#add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/eth_mac_1g_inst/cfg_tx_lfc_eth_src
#add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/eth_mac_1g_inst/mac_ctrl/mac_pause_ctrl_tx_inst/mcf_eth_src
#add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/eth_mac_1g_inst/mac_ctrl/mac_ctrl_tx_inst/mcf_eth_src


add wave -hex /stimulus/dut/eth_mac_inst/tx_fifo/fifo_inst/m_axis_tdata
add wave -hex /stimulus/dut/eth_mac_inst/tx_fifo/m_axis_tdata
add wave -hex /stimulus/dut/eth_mac_inst/tx_fifo_axis_tdata
add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/tx_axis_tdata
add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/eth_mac_1g_inst/tx_axis_tdata
add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/eth_mac_1g_inst/mac_ctrl/mac_ctrl_tx_inst/s_axis_tdata
add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/eth_mac_1g_inst/mac_ctrl/mac_ctrl_tx_inst/m_axis_tdata
add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/eth_mac_1g_inst/tx_axis_tdata_int
add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/eth_mac_1g_inst/axis_gmii_tx_inst/s_axis_tdata
add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/eth_mac_1g_inst/gmii_txd
add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/mac_mii_txd
add wave -hex /stimulus/dut/eth_mac_inst/eth_mac_1g_mii_inst/mii_phy_if_inst/phy_mii_txd 




#Inputs 
add wave -noupdate -divider -height 32 "Inputs"
add wave -hex /stimulus/clk
add wave -hex /stimulus/rst
add wave -hex /stimulus/btn
add wave -hex /stimulus/sw
add wave -hex /stimulus/phy_rx_clk
add wave -hex /stimulus/phy_rxd
add wave -hex /stimulus/phy_rx_dv
add wave -hex /stimulus/phy_rx_er
add wave -hex /stimulus/phy_tx_clk
add wave -hex /stimulus/phy_col
add wave -hex /stimulus/phy_crs
add wave -hex /stimulus/uart_rxd

#Outputs
add wave -noupdate -divider -height 32 "Outputs"
add wave -color yellow -hex /stimulus/led0_r
add wave -color yellow -hex /stimulus/led0_g
add wave -color yellow -hex /stimulus/led0_b
add wave -color yellow -hex /stimulus/led1_r
add wave -color yellow -hex /stimulus/led1_g
add wave -color yellow -hex /stimulus/led1_b
add wave -color yellow -hex /stimulus/led2_r
add wave -color yellow -hex /stimulus/led2_g
add wave -color yellow -hex /stimulus/led2_b
add wave -color yellow -hex /stimulus/led3_r
add wave -color yellow -hex /stimulus/led3_g
add wave -color yellow -hex /stimulus/led3_b
add wave -color yellow -hex /stimulus/led4
add wave -color yellow -hex /stimulus/led5
add wave -color yellow -hex /stimulus/led6
add wave -color yellow -hex /stimulus/led7
add wave -color yellow -hex /stimulus/phy_txd
add wave -color yellow -hex /stimulus/phy_tx_en
add wave -color yellow -hex /stimulus/phy_reset_n
add wave -color yellow -hex /stimulus/uart_txd

#add wave -hex /stimulus/rx_clk
#add wave -hex /stimulus/rx_rst
#add wave -hex /stimulus/tx_clk
#add wave -hex /stimulus/tx_rst
#add wave -hex /stimulus/tx_axis_tdata
#add wave -hex /stimulus/tx_axis_tvalid 
#add wave -hex /stimulus/tx_axis_tlast 
#add wave -hex /stimulus/tx_axis_tuser 
#add wave -hex /stimulus/gmii_rxd 
#add wave -hex /stimulus/gmii_rx_dv 
#add wave -hex /stimulus/gmii_rx_er 
#add wave -hex /stimulus/tx_ptp_ts 
#add wave -hex /stimulus/rx_ptp_ts 
#add wave -hex /stimulus/rx_clk_enable 
#add wave -hex /stimulus/tx_clk_enable 
#add wave -hex /stimulus/rx_mii_select 
#add wave -hex /stimulus/tx_mii_select 
#add wave -hex /stimulus/ifg_delay 
#add wave -noupdate -divider -height 32 "Outputs"
#add wave -hex /stimulus/tx_axis_tready
#add wave -hex /stimulus/rx_axis_tdata
#add wave -hex /stimulus/rx_axis_tvalid
#add wave -hex /stimulus/rx_axis_tlast
#add wave -hex /stimulus/rx_axis_tuser
#add wave -hex /stimulus/gmii_txd
#add wave -hex /stimulus/gmii_tx_en
#add wave -hex /stimulus/gmii_tx_er
#add wave -hex /stimulus/tx_axis_ptp_ts
#add wave -hex /stimulus/tx_axis_ptp_ts_tag
#add wave -hex /stimulus/tx_axis_ptp_ts_valid
#add wave -hex /stimulus/tx_start_packet
#add wave -hex /stimulus/tx_error_underflow
#add wave -hex /stimulus/rx_start_packet
#add wave -hex /stimulus/rx_error_bad_frame
#add wave -hex /stimulus/rx_error_bad_fcs
#add wave -noupdate -divider -height 32 "Status"
#add wave -hex /stimulus/stat_tx_mcf
#add wave -hex /stimulus/stat_rx_mcf
#add wave -hex /stimulus/stat_tx_lfc_pkt
#add wave -hex /stimulus/stat_tx_lfc_xon
#add wave -hex /stimulus/stat_tx_lfc_xoff
#add wave -hex /stimulus/stat_tx_lfc_paused
#add wave -hex /stimulus/stat_tx_pfc_pkt
#add wave -hex /stimulus/stat_tx_pfc_xon
#add wave -hex /stimulus/stat_tx_pfc_xoff
#add wave -hex /stimulus/stat_tx_pfc_paused
#add wave -hex /stimulus/stat_rx_lfc_pkt
#add wave -hex /stimulus/stat_rx_lfc_xon
#add wave -hex /stimulus/stat_rx_lfc_xoff
#add wave -hex /stimulus/stat_rx_lfc_paused
#add wave -hex /stimulus/stat_rx_pfc_pkt
#add wave -hex /stimulus/stat_rx_pfc_xon
#add wave -hex /stimulus/stat_rx_pfc_xoff
#add wave -hex /stimulus/stat_rx_pfc_paused   
#add wave -noupdate -divider -height 32 "Configuration"
#add wave -hex /stimulus/cfg_ifg
#add wave -hex /stimulus/cfg_tx_enable
#add wave -hex /stimulus/cfg_rx_enable
#add wave -hex /stimulus/cfg_mcf_rx_eth_dst_mcast
#add wave -hex /stimulus/cfg_mcf_rx_check_eth_dst_mcast
#add wave -hex /stimulus/cfg_mcf_rx_eth_dst_ucast
#add wave -hex /stimulus/cfg_mcf_rx_check_eth_dst_ucast
#add wave -hex /stimulus/cfg_mcf_rx_eth_src
#add wave -hex /stimulus/cfg_mcf_rx_check_eth_src
#add wave -hex /stimulus/cfg_mcf_rx_eth_type
#add wave -hex /stimulus/cfg_mcf_rx_opcode_lfc
#add wave -hex /stimulus/cfg_mcf_rx_check_opcode_lfc
#add wave -hex /stimulus/cfg_mcf_rx_opcode_pfc
#add wave -hex /stimulus/cfg_mcf_rx_check_opcode_pfc
#add wave -hex /stimulus/cfg_mcf_rx_forward
#add wave -hex /stimulus/cfg_mcf_rx_enable
#add wave -hex /stimulus/cfg_tx_lfc_eth_dst
#add wave -hex /stimulus/cfg_tx_lfc_eth_src
#add wave -hex /stimulus/cfg_tx_lfc_eth_type
#add wave -hex /stimulus/cfg_tx_lfc_opcode
#add wave -hex /stimulus/cfg_tx_lfc_en
#add wave -hex /stimulus/cfg_tx_lfc_quanta
#add wave -hex /stimulus/cfg_tx_lfc_refresh
#add wave -hex /stimulus/cfg_tx_pfc_eth_dst
#add wave -hex /stimulus/cfg_tx_pfc_eth_src
#add wave -hex /stimulus/cfg_tx_pfc_eth_type
#add wave -hex /stimulus/cfg_tx_pfc_opcode
#add wave -hex /stimulus/cfg_tx_pfc_en
#add wave -hex /stimulus/cfg_tx_pfc_quanta
#add wave -hex /stimulus/cfg_tx_pfc_refresh
#add wave -hex /stimulus/cfg_rx_lfc_opcode
#add wave -hex /stimulus/cfg_rx_lfc_en
#add wave -hex /stimulus/cfg_rx_pfc_opcode
#add wave -hex /stimulus/cfg_rx_pfc_enq
#add wave -noupdate -divider -height 32 "Priority Flow Control (PFC) (IEEE 802.3 annex 31D PFC)
#add wave -hex /stimulus/tx_pfc_req   
#add wave -hex /stimulus/tx_pfc_resend   
#add wave -hex /stimulus/rx_pfc_en   
#add wave -hex /stimulus/rx_pfc_req   
#add wave -hex /stimulus/rx_pfc_ack   

#add list -hex /stimulus/-r /tb/*
#add log -r /*

-- Set Wave Output Items 
TreeUpdate [SetDefaultTree]
WaveRestoreZoom {0 ps} {75 ns}
configure wave -namecolwidth 300
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2

-- Run the Simulation
run 480ns


