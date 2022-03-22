class u_seq_item extends riscv_seq_item;
  
    `uvm_object_utils(u_seq_item)

    function new (string name = "u_seq_item");
        super.new(name);
    endfunction

    constraint opcode{ 
        instr[6:0] inside{7'b0110111, 7'b0010111};
    }; 


    function void set_instr(string op = "random", bit [4:0] rd = instr[11:7], bit [20:0] imm = instr[31:12]); 
        case(op)
            "LUI": begin
                instr[6:0] = 7'b0110111;
            end
            "AUIPC": begin
                instr[6:0] = 7'b0010111;
            end
            "random": begin end
            default: begin  
                `uvm_fatal("Sequence Item u", "Operation not supported")
            end
        endcase
        
        instr[11:7] = rd; 
        instr[31:12] = imm; 
    
    endfunction


endclass: u_seq_item