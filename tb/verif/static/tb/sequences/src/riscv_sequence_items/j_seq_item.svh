class j_seq_item extends riscv_seq_item;
  
    `uvm_object_utils(j_seq_item)

    function new (string name = "j_seq_item");
        super.new(name);
    endfunction

    constraint opcode{ 
        instr[6:0] inside{7'b1101111, 7'b1100111};
    }; 

    constraint funct3{
        (instr[6:0] == 7'b1100111) -> (instr[14:12] inside {3'b000});
    };


    function void set_instr(string op = "random", bit [4:0] rd = instr[11:7], bit [20:0] imm = instr[31:12]); 
        case(op)
            "JAL": begin
                instr[6:0] = 7'b1101111;
            end
            "JALR": begin
                instr[6:0] = 7'b1100111;
                instr[14:12] = 3'b000;
            end
            "random": begin end
            default: begin  
                `uvm_fatal("Sequence Item j", "Operation not supported")
            end
        endcase
 
                
        instr[11:7] = rd; 
        instr[31:12] = {imm[20], imm[10:1], imm[11], imm[19:12]}; 
    
    endfunction


endclass: j_seq_item