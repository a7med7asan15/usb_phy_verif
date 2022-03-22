

class riscv_agent extends uvm_agent;

    `uvm_component_utils(riscv_agent)
  	    
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    riscv_config     riscv_cfg;
    
    riscv_coverage	cov;
    riscv_scoreboard sc;

    riscv_sequencer seqr;
    riscv_driver    driver;
  	riscv_monitor	monitor;
 
    

    

    virtual function void build_phase(uvm_phase phase);

      if(!uvm_config_db #(riscv_config)::get(this, "", "riscv_config", riscv_cfg)) begin
        `uvm_fatal(get_full_name(), "Can't get config for agent");
      end 
      
      monitor = riscv_monitor::type_id::create("monitor", this);
      seqr = riscv_sequencer::type_id::create("seqr", this); 
      driver = riscv_driver::type_id::create("driver", this);
      cov = riscv_coverage::type_id::create("cov", this);    
      sc = riscv_scoreboard::type_id::create("sc", this);

    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
      driver.seq_item_port.connect( seqr.seq_item_export );
      monitor.m_port.connect(cov.sb_port);
      monitor.m_port.connect(sc.sc_port);
    
    endfunction: connect_phase
    
  endclass: riscv_agent
    