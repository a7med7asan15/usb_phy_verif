class d_env_config extends uvm_object;
    `uvm_object_utils(d_env_config)
    // Handles for vip config for each of the instances
    
    riscv_config riscv_cfg;
    function new
    (
        string name = "d_env_config"
    );
        super.new(name);
    endfunction
    
    extern function void initialize;
    
endclass: d_env_config

function void d_env_config::initialize;
endfunction: initialize