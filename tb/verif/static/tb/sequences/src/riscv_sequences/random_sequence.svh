


class random_sequence extends base_sequence;
  
    `uvm_object_utils(random_sequence)
    
    //riscv_seq_item item;

    rand int rand_instr; 

    constraint types{
        rand_instr inside {[0:5]}; 
    }; 
    
    
    function new (string name = "random_sequence");
        super.new(name); 
    endfunction
    
      
    
    task body();

        
    `uvm_info(get_full_name(), "Random Sequence Running", UVM_HIGH);
    
      repeat (50) begin	

        if(!this.randomize()) 
            `uvm_fatal("Sequence","Randomization of rand instr Failed");


        if(rand_instr == 0 ) begin 
            item = b_seq_item::type_id::create("item");
        end
        else if(rand_instr == 1 ) begin 
            item = i_seq_item::type_id::create("item");
        end
        else if(rand_instr == 2 ) begin 
            item = j_seq_item::type_id::create("item");
        end
        else if(rand_instr == 3 ) begin 
            item = r_seq_item::type_id::create("item");
        end
        else if(rand_instr == 4 ) begin 
            item = s_seq_item::type_id::create("item");
        end
        else if(rand_instr == 5 ) begin 
            item = u_seq_item::type_id::create("item");
        end 
        else begin
            `uvm_fatal("Sequence","Something is wrong"); 
        end

        

        start_item(item);
        if(!item.randomize()) begin
            `uvm_fatal("Sequence","Randomization of Sequence Failed"); 
        end  
        finish_item(item);

        $display("Instruction is %d", rand_instr); 

      end
      
    endtask 
  
  endclass: random_sequence      