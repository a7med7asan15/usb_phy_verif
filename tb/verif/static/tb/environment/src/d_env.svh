
class d_env extends uvm_env;

  `uvm_component_utils(d_env)

  d_env_config cfg;
    
  riscv_agent      riscv_agent_0;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if ( cfg == null )
    begin
        if ( !uvm_config_db #(d_env_config)::get(this, "", "d_env_config", cfg) )
        begin
            `uvm_fatal("build_phase", "Unable to find the d_env config object in the uvm_config_db")
        end
    end

    riscv_agent_0 = riscv_agent::type_id::create("riscv_agent_0", this); 
    //riscv_agent_0.set_config(cfg.riscv_cfg);     
  endfunction: build_phase

  
endclass: d_env

//--------------------------------------------------------------------