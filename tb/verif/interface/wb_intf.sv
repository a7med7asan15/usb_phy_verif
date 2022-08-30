//  Interface: usbf_intf
//
interface wb_intf(
    input clk_i, rst_i
    );
    logic [17:0] wb_addr_i; 
    logic wb_data_i; 
    logic wb_data_o; 
    logic wb_we_i, wb_ack_o, wb_stb_i, wb_cyc_i; 
    

    
endinterface: wb_intf