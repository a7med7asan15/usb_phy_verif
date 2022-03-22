class r_seq_item extends riscv_seq_item;
  
    `uvm_object_utils(r_seq_item)

    function new (string name = "r_seq_item");
        super.new(name);
    endfunction

    constraint opcode{ 
        instr[6:0] inside{7'b0110011};  // R Type
    }; 

    constraint funct7{
        (instr[6:0] == 7'b0110011) -> (instr[31:25] inside {7'b0000000});
        ((instr[6:0] == 7'b0110011) & instr[14:12] inside {3'b000, 3'b101} ) -> (instr[31:25] inside {7'b0000000, 7'b0100000});      
    };


    function void set_instr(string op = "random", bit [4:0] rd = instr[11:7], bit [4:0] rs1 = instr[19:15], bit [4:0] rs2 = instr[24:20]); 
        case(op)
            "ADD": begin
                instr[14:12] = 3'b000;
                instr[31:25] = 7'b0000000;
            end
            "SUB": begin
                instr[14:12] = 3'b000;
                instr[31:25] = 7'b0100000;
            end
            "SLL": begin
                instr[14:12] = 3'b001;
                instr[31:25] = 7'b0000000;
            end
            "SLT": begin
                instr[14:12] = 3'b010;
                instr[31:25] = 7'b0000000;
            end
            "SLTU": begin
                instr[14:12] = 3'b011;
                instr[31:25] = 7'b0000000;
            end
            "XOR": begin
                instr[14:12] = 3'b100;
                instr[31:25] = 7'b0000000;
            end
            "SRL": begin
                instr[14:12] = 3'b101;
                instr[31:25] = 7'b0000000;
            end
            "SRA": begin
                instr[14:12] = 3'b101;
                instr[31:25] = 7'b0100000;
            end
            "OR": begin
                instr[14:12] = 3'b110;
                instr[31:25] = 7'b0000000;
            end
            "AND": begin
                instr[14:12] = 3'b111;
                instr[31:25] = 7'b0000000;
            end
            "random": begin end
            default: begin  
                `uvm_fatal("Sequence Item r", "Operation not supported")
            end
        endcase
 
        instr[11:7] = rd; 
        instr[19:15] = rs1; 
        instr[24:20] = rs2; 
    
    endfunction


endclass: r_seq_item