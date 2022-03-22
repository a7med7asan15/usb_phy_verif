
class riscv_driver extends uvm_driver #(riscv_seq_item);
  
    `uvm_component_utils(riscv_driver)

    virtual riscv_if riscv_vif;
    riscv_seq_item item;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
      if( !uvm_config_db #(virtual riscv_if)::get(this, "", "riscv_vif", riscv_vif) )
        `uvm_fatal("", "uvm_config_db::get failed")
      //item = riscv_seq_item::type_id::create("item");
    endfunction 
   
        
    virtual task run_phase(uvm_phase phase);
        forever begin
          seq_item_port.get_next_item(item);
          drive();
          seq_item_port.item_done();
        end
    endtask
      
      
    virtual task drive();


        @(posedge riscv_vif.clk);
        @(riscv_vif.pc);
        riscv_vif.instr = item.instr;

    endtask
  
  endclass: riscv_driver
