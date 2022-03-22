
class riscv_monitor extends uvm_monitor;
  
  `uvm_component_utils(riscv_monitor)
  
  uvm_analysis_port #(riscv_seq_item) m_port;
  
  
  riscv_seq_item seq;
  virtual riscv_if riscv_vif;
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
    m_port = new("m_port",this);
  endfunction : new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual riscv_if)::get(this,"","riscv_vif",riscv_vif))
      `uvm_error("", "uvm_config_db::get failed") 
    seq = r_seq_item::type_id::create("seq") ;
  endfunction: build_phase
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      seq = riscv_seq_item::type_id::create("seq") ;

      //@(posedge riscv_vif.clk);
        
 
      @(riscv_vif.pc);
      @(negedge riscv_vif.clk);
      seq.instr = riscv_vif.instr;  
      m_port.write(seq);      

    end
  endtask : run_phase
endclass : riscv_monitor
      
    