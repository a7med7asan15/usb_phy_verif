
class riscv_coverage extends uvm_subscriber#(riscv_seq_item);
  
  `uvm_component_utils(riscv_coverage)

  uvm_analysis_imp #(riscv_seq_item, riscv_coverage) sb_port;


  	
  riscv_seq_item trans;
  
   covergroup instructions;
      c_instr : coverpoint trans.instr[6:0] {
        bins LUI = {7'b0110111};
        bins AUIPC = {7'b0010111};
        bins JAL = {7'b1101111};
        bins JALR = {7'b1100111};
        bins BRANCH = {7'b1100011};
        bins LOAD = {7'b0000011};
        bins STORE = {7'b0100011};
        bins ITYPE = {7'b0010011};
        bins RTYPE = {7'b0110011};
        // bins FENCE = {7'b0001111};
        // bins CSR = {7'b1110011};
      }
     c_funct : coverpoint trans.instr[14:12];
     c_cross : cross c_instr, c_funct;
    endgroup
  
 
     
  	function new(string name, uvm_component parent);
       super.new(name, parent);
      	instructions = new();
       	sb_port = new("sb_port",this);
  	endfunction : new
    
  
  	function void write(input riscv_seq_item t);
      trans = t;
      instructions.sample();
  	endfunction 
  

endclass: riscv_coverage
       