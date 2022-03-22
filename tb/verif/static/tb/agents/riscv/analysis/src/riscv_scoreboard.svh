

class riscv_scoreboard extends uvm_subscriber#(riscv_seq_item);
  
    `uvm_component_utils(riscv_scoreboard) 

    uvm_analysis_imp #(riscv_seq_item, riscv_scoreboard) sc_port;
  
      
    function new(string name, uvm_component parent);
        super.new(name, parent);
    sc_port = new("sc_port",this);

    endfunction : new 
      
    
    virtual function void write(input riscv_seq_item t);    
        $display("-----------------------------");


        `uvm_info("SCOREBOARD",t.print_trans(0), UVM_HIGH)
        
     
    endfunction 

    
    
    
  
  endclass: riscv_scoreboard
  