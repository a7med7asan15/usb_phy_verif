module hdl_top;
    import uvm_pkg::*;
    import top_params_pkg::*;
    wire                                      clk;
    wire                                      reset;
    
    riscv_wrapper dut(
        .clk(riscv_vif.clk),
        .reset(riscv_vif.reset),
        .trap(riscv_vif.trap),
        .pc(riscv_vif.pc),
        .instr(riscv_vif.instr)
    );

    riscv_if riscv_vif (
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
        uvm_config_db #(virtual riscv_if)::set(null, "*","riscv_vif", riscv_vif);
    end 

endmodule: hdl_top
