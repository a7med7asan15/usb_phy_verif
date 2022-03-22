class s_seq_item extends riscv_seq_item;
  
    `uvm_object_utils(s_seq_item)

    function new (string name = "s_seq_item");
        super.new(name);
    endfunction

    constraint opcode{ 
        instr[6:0] inside{7'b0100011};
    }; 

    constraint funct3{
        (instr[6:0] == 7'b0100011) -> (instr[14:12] inside {3'b000, 3'b001, 3'b010});
    };

    function void set_instr(string op = "random", bit [11:0] imm = {instr[31:25],instr[11:7]}, bit [4:0] rs1 = instr[19:15], bit [4:0] rs2 = instr[24:20]); 
        case(op)
            "SB": begin
                instr[14:12] = 3'b000;
            end
            "SH": begin
                instr[14:12] = 3'b001;
            end
            "SW": begin
                instr[14:12] = 3'b010;
            end
            "random": begin end
            default: begin  
                `uvm_fatal("Sequence Item s", "Operation not supported")
            end
        endcase

        instr[11:7] = imm[4:0]; 
        instr[19:15] = rs1; 
        instr[24:20] = rs2; 
        instr[31:25] = imm[11:5]; 

 
        
    
    endfunction


endclass: s_seq_item