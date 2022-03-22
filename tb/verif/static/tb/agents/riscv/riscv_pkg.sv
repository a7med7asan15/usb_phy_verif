package riscv_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import top_params_pkg::*;
    import seq_pkg::*;
    import analysis_pkg::*;

    `include "../parameters/riscv_config.svh"
    `include "src/riscv_driver.svh"
    `include "src/riscv_monitor.svh"
    `include "src/riscv_agent.svh"
    
endpackage: riscv_pkg
