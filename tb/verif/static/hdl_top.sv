module hdl_top;
    import uvm_pkg::*;
    import top_params_pkg::*;
    wire                                      clk;
    wire                                      reset;
    
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


    utmi_intf utmi_vif (
        .clk(clk), 
        .reset(reset)
    );

    
    clk_gen clk_gen
    (
        .CLK(clk)
    );
    reset_gen reset_gen
    (
        .RESET(reset),
        .CLK_IN(clk)
    );

    initial begin
        uvm_config_db #(virtual utmi_intf)::set(null, "*","utmi_vif", utmi_vif);
        uvm_config_db #(virtual sram_intf)::set(null, "*","sram_vif", sram_vif);
        uvm_config_db #(virtual wb_intf)::set(null, "*","wb_vif", wb_vif);
    end 

endmodule: hdl_top
