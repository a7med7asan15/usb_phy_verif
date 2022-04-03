`include "../../../rtl/utmi/usbf_defines.v"

module tb; 
    parameter	SSRAM_HADR = `USBF_SSRAM_HADR;
    reg		                clk_i;
    reg		                rst_i;
    reg	 [`USBF_UFC_HADR:0]	wb_addr_i;
    reg	 [31:0]	            wb_data_i;
    wire [31:0]	            wb_data_o;
    wire		            wb_ack_o;
    reg		                wb_we_i;
    reg		                wb_stb_i;
    reg		                wb_cyc_i;
    wire		            inta_o;
    wire		            intb_o;
    wire [15:0]	            dma_req_o;
    reg	 [15:0]	            dma_ack_i;
    wire		            susp_o;
    reg		                resume_req_i;
    
    reg		                phy_clk_pad_i;
    wire		            phy_rst_pad_o;
    
    wire [7:0]	            DataOut_pad_o;
    wire		            TxValid_pad_o;
    reg		                TxReady_pad_i;
    
    reg	 [7:0]	            DataIn_pad_i;
    reg		                RxValid_pad_i;
    reg		                RxActive_pad_i;
    reg		                RxError_pad_i;
    
    wire		            XcvSelect_pad_o;
    wire		            TermSel_pad_o;
    wire		            SuspendM_pad_o;
    reg  [1:0]	            LineState_pad_i;
    wire [1:0]	            OpMode_pad_o;
    reg		                usb_vbus_pad_i;
    wire		            VControl_Load_pad_o;
    wire [3:0]	            VControl_pad_o;
    reg	 [7:0]	            VStatus_pad_i;  
    wire [SSRAM_HADR:0]	    sram_adr_o;
    reg	 [31:0]	            sram_data_i;
    wire [31:0]	            sram_data_o;
    wire		            sram_re_o;
    wire		            sram_we_o;
    


usbf_top dut(
    .clk_i(), 
    .rst_i(), 
    .wb_addr_i(), 
    .wb_data_i(), 
    .wb_data_o(),
    .wb_ack_o(), 
    .wb_we_i(),
    .wb_stb_i(), 
    .wb_cyc_i(), 
    .inta_o(), 
    .intb_o(),
    .dma_req_o(), 
    .dma_ack_i(), 
    .susp_o(), 
    .resume_req_i(),
    .phy_clk_pad_i(), 
    .phy_rst_pad_o(),
    .DataOut_pad_o(), 
    .TxValid_pad_o(), 
    .TxReady_pad_i(),
    .RxValid_pad_i(), 
    .RxActive_pad_i(),
    .RxError_pad_i(),
    .DataIn_pad_i(), 
    .XcvSelect_pad_o(), 
    .TermSel_pad_o(),
    .SuspendM_pad_o(), 
    .LineState_pad_i(),
    .OpMode_pad_o(), 
    .usb_vbus_pad_i(),
    .VControl_Load_pad_o(), 
    .VControl_pad_o(), 
    .VStatus_pad_i(),
    .sram_adr_o(), 
    .sram_data_i(), 
    .sram_data_o(), 
    .sram_re_o(), 
    .sram_we_o()
); 

initial begin 

end 


initial begin 

end 



endmodule