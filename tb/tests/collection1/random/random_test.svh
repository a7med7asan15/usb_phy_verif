     

class random_test extends base_test;
  
  `uvm_component_utils(random_test)
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);


      super.build_phase(phase);
      set_type_override_by_type(base_sequence::get_type(), random_sequence::get_type()); 

    endfunction

      
  endclass: random_test
  