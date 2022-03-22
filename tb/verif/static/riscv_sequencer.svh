      
class riscv_sequencer extends uvm_sequencer #(riscv_seq_item);
    
  	`uvm_component_utils(riscv_sequencer)
        
	function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  
endclass: riscv_sequencer
