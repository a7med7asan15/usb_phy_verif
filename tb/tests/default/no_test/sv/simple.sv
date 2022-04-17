`include "../../../../../rtl/utmi/usbf_defines.v"

`timescale 1ns/1ns
module tb; 
    // This USB core works as a slave device only
    parameter	SSRAM_HADR = `USBF_SSRAM_HADR;
    reg		                clk_i;
    reg		                rst_i;
    reg	 [`USBF_UFC_HADR:0]	wb_addr_i; // Input Address
    reg	 [31:0]	            wb_data_i; // Input Data
    wire [31:0]	            wb_data_o; // Output Data
    wire		            wb_ack_o; // Acknowledgment Output. Indicates a normal Cycle termination.
    reg		                wb_we_i;  // Indicates a Write Cycle when asserted high.
    reg		                wb_stb_i; // Indicates the beginning of a valid transfer cycle for this core
    reg		                wb_cyc_i; // Encapsulates an valid transfer cycle
    wire		            inta_o;
    wire		            intb_o;
    wire [15:0]	            dma_req_o;
    reg	 [15:0]	            dma_ack_i; // DMA Acknowledgement For each endpoint one line. Unused endpoints will ignore their DMA_ACK line
    wire		            susp_o;
    reg		                resume_req_i; // Resume Request (Connect to 0 (zero) when not used.)
    
    reg		                phy_clk_pad_i; // clk 
    wire		            phy_rst_pad_o; // Reset Out
    wire [7:0]	            DataOut_pad_o; // Data out 
    wire		            TxValid_pad_o; // Transmit Valid 
    reg		                TxReady_pad_i; // Transmit Ready 
    reg	 [7:0]	            DataIn_pad_i;  // Data In 
    reg		                RxValid_pad_i; // Receive Valid 
    reg		                RxActive_pad_i; // Receiver Active 
    reg		                RxError_pad_i;  // Receive Error 
    wire		            XcvSelect_pad_o; // Full speed 1, High speed 0 
    wire		            TermSel_pad_o; // Full speed 1, High speed 0 termination
    wire		            SuspendM_pad_o; // Places PHY into suspend mode
    reg  [1:0]	            LineState_pad_i; // Line State
    wire [1:0]	            OpMode_pad_o; // Operation Mode Select
    reg		                usb_vbus_pad_i; // Always 1
    wire		            VControl_Load_pad_o; //O Vendor Control Load
    wire [3:0]	            VControl_pad_o; // Vendor Control data
    reg	 [7:0]	            VStatus_pad_i;  // Vendor Status data
    wire [SSRAM_HADR:0]	    sram_adr_o; // SRAM Address lines
    reg	 [31:0]	            sram_data_i; // Input Data
    wire [31:0]	            sram_data_o; // Output Data
    wire		            sram_re_o; //read enable 
    wire		            sram_we_o; // write enable 
    


usbf_top dut(
    .clk_i(clk_i), 
    .rst_i(rst_i), 
    .wb_addr_i(wb_addr_i), 
    .wb_data_i(wb_data_i), 
    .wb_data_o(wb_data_o),
    .wb_ack_o(wb_ack_o), 
    .wb_we_i(wb_we_i),
    .wb_stb_i(wb_stb_i), 
    .wb_cyc_i(wb_cyc_i), 
    .inta_o(inta_o), 
    .intb_o(intb_o),
    .dma_req_o(dma_req_o), 
    .dma_ack_i(dma_ack_i), 
    .susp_o(susp_o), 
    .resume_req_i(resume_req_i),
    .phy_clk_pad_i(phy_clk_pad_i), 
    .phy_rst_pad_o(phy_rst_pad_o),
    .DataOut_pad_o(DataOut_pad_o), 
    .TxValid_pad_o(TxValid_pad_o), 
    .TxReady_pad_i(TxReady_pad_i),
    .RxValid_pad_i(RxValid_pad_i), 
    .RxActive_pad_i(RxActive_pad_i),
    .RxError_pad_i(RxError_pad_i),
    .DataIn_pad_i(DataIn_pad_i), 
    .XcvSelect_pad_o(XcvSelect_pad_o), 
    .TermSel_pad_o(TermSel_pad_o),
    .SuspendM_pad_o(SuspendM_pad_o), 
    .LineState_pad_i(LineState_pad_i),
    .OpMode_pad_o(OpMode_pad_o), 
    .usb_vbus_pad_i(usb_vbus_pad_i),
    .VControl_Load_pad_o(VControl_Load_pad_o), 
    .VControl_pad_o(VControl_pad_o), 
    .VStatus_pad_i(VStatus_pad_i),
    .sram_adr_o(sram_adr_o), 
    .sram_data_i(sram_data_i), 
    .sram_data_o(sram_data_o), 
    .sram_re_o(sram_re_o), 
    .sram_we_o(sram_we_o)
); 

initial begin 
    clk_i = 0; 
    forever #1 clk_i = ~clk_i;
end 

initial begin 
    phy_clk_pad_i = 0; 
    forever #1 phy_clk_pad_i = ~phy_clk_pad_i;
end 


initial begin 
    rst_i = 0; 
    #5 rst_i = 1; 
end 



endmodule