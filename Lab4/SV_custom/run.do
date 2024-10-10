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

vlog fpga_eth.sv
vlog tb.sv
vlog src/counter.sv
vlog src/flopenr.sv

# start and run simulation
vsim -voptargs=+acc work.stimulus

view list
view wave

-- display input and output signals as hexidecimal values
# Diplays All Signals recursively
#add wave -hex -r /stimulus/*

#tracking back the header info, could on

#Misc
add wave -hex /stimulus/dut/WordCount
add wave -hex /stimulus/dut/TotalFrameWords
add wave -hex /stimulus/dut/TotalFrameBytes
add wave -hex /stimulus/dut/TotalFrameNibs
add wave -hex /stimulus/dut/TotalFrame
add wave -hex /stimulus/dut/TotalFrameLengthBytes
add wave -hex /stimulus/dut/phy_txd
add wave -hex /stimulus/dut/valid
add wave -hex /stimulus/dut/rst
#add wave -hex /stimulus/dut/phy_tx_data
#add wave -hex /stimulus/dut/phy_tx_clk
#add wave -hex /stimulus/dut/CountFlag
add wave -hex /stimulus/dut/WordCountEnable
add wave -hex /stimulus/dut/WordCountReset
#add wave -hex /stimulus/dut/RstCount
#add wave -hex /stimulus/dut/timeout
#add wave -hex /stimulus/dut/delay

#Inputs 
#add wave -noupdate -divider -height 32 "Inputs"
add wave -hex /stimulus/clk
#add wave -hex /stimulus/rst
#add wave -hex /stimulus/btn
#add wave -hex /stimulus/sw
#add wave -hex /stimulus/phy_rx_clk
#add wave -hex /stimulus/phy_rxd
#add wave -hex /stimulus/phy_rx_dv
#add wave -hex /stimulus/phy_rx_er
#add wave -hex /stimulus/phy_tx_clk
#add wave -hex /stimulus/phy_col
#add wave -hex /stimulus/phy_crs
#add wave -hex /stimulus/uart_rxd

#Outputs
#add wave -noupdate -divider -height 32 "Outputs"
#add wave -color yellow -hex /stimulus/led0_r
#add wave -color yellow -hex /stimulus/led0_g
#add wave -color yellow -hex /stimulus/led0_b
#add wave -color yellow -hex /stimulus/led1_r
#add wave -color yellow -hex /stimulus/led1_g
#add wave -color yellow -hex /stimulus/led1_b
#add wave -color yellow -hex /stimulus/led2_r
#add wave -color yellow -hex /stimulus/led2_g
#add wave -color yellow -hex /stimulus/led2_b
#add wave -color yellow -hex /stimulus/led3_r
#add wave -color yellow -hex /stimulus/led3_g
#add wave -color yellow -hex /stimulus/led3_b
#add wave -color yellow -hex /stimulus/led4
#add wave -color yellow -hex /stimulus/led5
#add wave -color yellow -hex /stimulus/led6
#add wave -color yellow -hex /stimulus/led7
#add wave -color yellow -hex /stimulus/phy_tx_data
#add wave -color yellow -hex /stimulus/phy_txd
#add wave -color yellow -hex /stimulus/phy_tx_en
#add wave -color yellow -hex /stimulus/phy_reset_n
#add wave -color yellow -hex /stimulus/uart_txd

#all signals
#add wave -color green -hex -r /stimulus/dut/*
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
run 600ns