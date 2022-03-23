


class base_sequence extends uvm_sequence#(riscv_seq_item);
  
    `uvm_object_utils(base_sequence)
    
    riscv_seq_item item;
    
    
    function new (string name = "base_sequence");
        super.new(name); 
    endfunction
    
      
    
    virtual task body();

  
      repeat(20) begin	
        item = r_seq_item::type_id::create("item");

        start_item(item);
        if(!item.randomize()) begin
            `uvm_fatal("Sequence","Randomization of Sequence Failed"); 
        end  
        finish_item(item);

      end
   

      

    
      
    endtask 
  
  endclass: base_sequence      