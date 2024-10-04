module fpga_eth #
(   
    parameter logic [31:0] timeout = 32'd4,
    parameter logic [31:0] delay = 32'd2
)
(
    /*
     * Clock: 125MHz
     * Synchronous reset
     */
    input  logic       CLK100MHZ, //may need to change this as input
    input  logic       rst,

    /*
     * GPIO
//     */
//    input  logic [3:0] btn,
//    input  logic [3:0] sw,
//    output logic       led0_r,
//    output logic       led0_g,
//    output logic       led0_b,
//    output logic       led1_r,
//    output logic       led1_g,
//    output logic       led1_b,
//    output logic       led2_r,
//    output logic       led2_g,
//    output logic       led2_b,
//    output logic       led3_r,
//    output logic       led3_g,
//    output logic       led3_b,
//    output logic       led4,
//    output logic       led5,
//    output logic       led6,
//    output logic       led7,

    /*
     * Ethernet: 100BASE-T MII
     */

//    input  logic       phy_rx_clk, //Clock signal for receiving data.
//    input  logic [3:0] phy_rxd, //4-bit data input from the physical layer.
    input  logic       phy_rx_dv, //Data Valid signal, indicating when phy_rxd holds valid data
//    input  logic       phy_rx_er, //Error signal indicating if there is an error in the received data.
    
//    input  logic       phy_tx_clk, //Clock signal for transmitting data
    output logic [3:0] phy_txd, //4-bit data output to the physical layer.
    output logic       phy_tx_en //Transmit Enable signal, indicating when to send data on 'phy_txd'
  //  input  logic       phy_col, // Collision signal, often used in Ethernet to indicate data collisions on the network
  //  input  logic       phy_crs, //Carrier Sense signal, indicating that the network medium is active
   // output logic       phy_reset_n //Reset signal, active low, used to reset the PHY (physical layer) device.

   // input logic         phy_tx_ready //added this for some control

    /*
     * UART: 115200 bps, 8N1
     */
//    input  logic       uart_rxd, // UART receive data input
//    output logic       uart_txd // UART transmit data output
);

    //localparam TotalFrameLengthBits = 2*48+17+16+187+(3*P.XLEN) + MAX_CSRS*(P.XLEN+12);
    localparam TotalFrameLengthBits = 512;
    localparam TotalFrameLengthBytes = TotalFrameLengthBits / 8;
    
    logic clk;

    logic phy_tx_last;
    logic [31:0] phy_tx_data;
    logic valid;
    
    logic [9:0]              WordCount;
    logic [11:0]             BytesInFrame;
    logic                    TransReady;
    logic                    BurstDone;
    logic                    WordCountReset;
    logic                    WordCountEnable;
    logic [47:0]             SrcMac, DstMac;
    logic [15:0]             EthType, Length;
    logic [31:0]             Tag;
    logic [TotalFrameLengthBits-1:0] TotalFrame;
    logic [31:0] TotalFrameWords [TotalFrameLengthBytes/4-1:0]; // this maybe should just be 32 bits
    logic [7:0] TotalFrameBytes [TotalFrameLengthBytes-1:0]; //left size is the size of each element within the array
    logic [3:0] TotalFrameNibs [TotalFrameLengthBytes*2-1:0];
    logic [95:0] Data;

    //logic [187+(3*P.XLEN) + MAX_CSRS*(P.XLEN+12)-1:0] rvviDelay;

    typedef enum {STATE_RST, STATE_COUNT, STATE_RDY, STATE_WAIT, STATE_TRANS, STATE_TRANS_INSERT_DELAY} statetype;
    statetype CurrState, NextState;
    
    logic [31:0] 	    RstCount;
    logic [31:0] 	    FrameCount;
    logic 		    RstCountRst, RstCountEn, CountFlag, DelayFlag;
    
   
    assign clk = CLK100MHZ; 
    assign valid = phy_rx_dv;


    always_ff @(posedge clk) begin
        if(rst) CurrState <= STATE_RST; //may need to flip reset state
        else               CurrState <= NextState;
    end

    always_comb begin
        case(CurrState)
            STATE_RST: NextState = STATE_COUNT;
            STATE_COUNT: if (CountFlag) NextState = STATE_RDY;
                        else           NextState = STATE_COUNT;
            STATE_RDY: if (TransReady & valid) NextState = STATE_TRANS;
            else if(~TransReady & valid) NextState = STATE_WAIT;
            else                        NextState = STATE_RDY;
            STATE_WAIT: if(TransReady)  NextState = STATE_TRANS;
                        else            NextState = STATE_WAIT;
            STATE_TRANS: if(BurstDone & TransReady) NextState = STATE_TRANS_INSERT_DELAY;
                        else          NextState = STATE_TRANS;
            STATE_TRANS_INSERT_DELAY: if(DelayFlag) NextState = STATE_RDY;
                                    else          NextState = STATE_TRANS_INSERT_DELAY;
            default: NextState = STATE_RDY;
        endcase
    end

    assign Stall = CurrState != STATE_RDY;
    assign TransReady = 1'b1; //may change since not definite
    assign WordCountEnable = (CurrState == STATE_RDY & valid) | (CurrState == STATE_TRANS & TransReady);
    assign WordCountReset = CurrState == STATE_RDY;

    assign RstCountEn = CurrState == STATE_COUNT | CurrState == STATE_TRANS_INSERT_DELAY;
    assign RstCountRst = CurrState == STATE_RST | CurrState == STATE_TRANS;

    // have to count at least 250 ms after reset pulled to wait for the phy to actually be ready
    // at 20MHz 250 ms is 250e-3 / (1/20e6) = 5,000,000.
    counter #(32) rstcounter(clk, RstCountRst, RstCountEn, RstCount);
    assign CountFlag = RstCount == timeout;
    assign DelayFlag = RstCount == delay;

    //counter #(32) framecounter(phy_tx_clk, ~phy_reset_n, (phy_tx_ready & phy_tx_last), FrameCount); //Doesnt seem to be used anywhere

    //may need to store delay?
    //flopenr #(187+(3*P.XLEN) + MAX_CSRS*(P.XLEN+12)) rvvireg(m_axi_aclk, ~m_axi_aresetn, valid, rvvi, rvviDelay);

    counter #(10) WordCounter(clk, WordCountReset, WordCountEnable, WordCount);
    // *** BUG BytesInFrame will eventually depend on the length of the data stored into the ethernet frame
    // for now this will be exactly 608 bits (76 bytes, 19 words) + the ethernet frame overhead and 2-byte padding = 92-bytes
    assign BytesInFrame = 12'd2 + 12'd76 + 12'd6 + 12'd6 + 12'd2; //understand the values here, only need min 64 bytes
    //assign BurstDone = WordCount == (BytesInFrame[11:2] - 1'b1); //change this to accomodate "nibbles in frame", so doesnt reset
    assign BurstDone = 1'b0;

    genvar index;
    for (index = 0; index < TotalFrameLengthBytes/4; index++) begin 
        assign TotalFrameWords[index] = TotalFrame[(index*32)+32-1 : (index*32)];
    end

    genvar index2;
    for (index2 = 0; index2 < TotalFrameLengthBytes; index2++) begin 
        assign TotalFrameBytes[index2] = TotalFrame[(index2*8)+8-1 : (index2*8)];
    end

    genvar index3;
    for (index3 = 0; index3 < TotalFrameLengthBytes*2; index3++) begin 
        assign TotalFrameNibs[index3] = TotalFrame[(index3*4)+4-1 : (index3*4)];
    end

    //Data = 1'b1;
    assign Data = 96'h00_68_65_6C_6C_6F_20_77_6F_72_6C_64; //ASCII for "Hello World"

    assign Length = {4'b0, BytesInFrame};
    //assign TotalFrame = {16'h0000, EthType, DstMac, SrcMac, Data}; //type should come after dest/source
    assign TotalFrame = {56'h55_55_55_55_55_55_55, 8'hAB, DstMac, SrcMac, EthType, Data};

//    // *** fix me later
//    assign DstMac = 48'h8F54_0000_1654; // made something up
    assign DstMac = 48'h1098_1973_6759;
    assign SrcMac = 48'h4502_4444_6843;
    assign Tag = 32'b0;
    //assign EthType = 16'h005c; //may need to change this
    assign EthType = 16'h0800;

    assign phy_tx_data = TotalFrameWords[(TotalFrameLengthBytes/4) - WordCount[4:0]]; //reversed this in order to get transmission in proper order
    //assign phy_txd = TotalFrameBytes[TotalFrameLengthBytes - WordCount[4:0]]; //may have to create "nibble counter" in order to send over nibbles at a time 
    assign phy_txd = TotalFrameNibs[(TotalFrameLengthBytes*2) - WordCount[9:0]];
    //assign phy_txd = '1;
    assign phy_tx_last = BurstDone & (CurrState == STATE_TRANS);
    assign phy_tx_dv = (CurrState == STATE_TRANS);
    assign phy_tx_en = 1'b1;
  
endmodule
 