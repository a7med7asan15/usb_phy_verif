     

class base_test extends uvm_test;
  
  `uvm_component_utils(base_test)
    
    d_env d_env_h;

    d_env_config env_cfg;

    riscv_config     riscv_cfg;

    
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      riscv_cfg = riscv_config::type_id::create("riscv_cfg");
      env_cfg = d_env_config::type_id::create("env_cfg");

        
      if(!uvm_config_db #(virtual riscv_if)::get(this, "", "riscv_vif", riscv_cfg.riscv_vif))
      begin
        `uvm_fatal(get_full_name(), "couldn't get virutal interface")
      end
      uvm_config_db #(riscv_config)::set(this, "*", "riscv_config",riscv_cfg);


      //pcie_rc_serial_0_config_policy::configure(pcie_rc_serial_0_cfg);
      env_cfg.riscv_cfg = riscv_cfg;


      d_env_h = d_env::type_id::create("d_env_h", this);
      d_env_h.cfg = env_cfg;
      
    endfunction
    
    task run_phase(uvm_phase phase);
      base_sequence sequ;
      sequ = base_sequence::type_id::create("sequ");
      
      phase.raise_objection(this);
      sequ.start(d_env_h.riscv_agent_0.seqr);
      repeat(2) begin
        @(posedge riscv_cfg.riscv_vif.clk); 
      end
      phase.drop_objection(this);
      $display("\nCOVERAGE :	%d",d_env_h.riscv_agent_0.cov.instructions.c_cross.get_coverage());


    endtask
      
  endclass: base_test
  