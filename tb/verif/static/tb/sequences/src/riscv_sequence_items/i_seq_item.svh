class i_seq_item extends riscv_seq_item;
  
    `uvm_object_utils(i_seq_item)

    function new (string name = "i_seq_item");
        super.new(name);
    endfunction
    
    constraint opcode{ 
        instr[6:0] inside{7'b0000011, 7'b0010011};  
    }; 

    constraint funct3{
        (instr[6:0] == 7'b0000011) -> (instr[14:12] inside {3'b000, 3'b001, 3'b010, 3'b100, 3'b101});
        (instr[6:0] == 7'b0010011) -> (instr[14:12] inside {3'b000, 3'b010, 3'b011, 3'b100, 3'b110, 3'b111, 3'b001, 3'b101});
    }; 

    constraint funct7{
        ((instr[6:0] == 7'b0010011) & (instr[14:12] == 3'b001)) -> (instr[31:25] inside {7'b0000000});
        ((instr[6:0] == 7'b0010011) & (instr[14:12] == 3'b101)) -> (instr[31:25] inside {7'b0000000, 7'b0100000}); 
    };


    // Constraint memory on immediate

    function void set_instr(string op = "random", bit [4:0] rd = instr[11:7], bit [4:0] rs1 = instr[19:15], bit [11:0] imm = instr[31:20]); 
        case(op)
            "LB": begin
                instr[6:0] = 7'b0000011;
                instr[14:12] = 3'b000;
            end
            "LH": begin
                instr[6:0] = 7'b0000011;
                instr[14:12] = 3'b001;
            end
            "LW": begin
                instr[6:0] = 7'b0000011;
                instr[14:12] = 3'b010;
            end
            "LBU": begin
                instr[6:0] = 7'b0000011;
                instr[14:12] = 3'b100;
            end
            "LHU": begin
                instr[6:0] = 7'b0000011;
                instr[14:12] = 3'b101;
            end
            "ADDI": begin
                instr[6:0] = 7'b0010011;
                instr[14:12] = 3'b000;
            end
            "SLTI": begin
                instr[6:0] = 7'b0010011;
                instr[14:12] = 3'b010;
            end
            "SLTIU": begin
                instr[6:0] = 7'b0010011;
                instr[14:12] = 3'b011;
            end
            "XORI": begin
                instr[6:0] = 7'b0010011;
                instr[14:12] = 3'b100;
            end
            "ORI": begin
                instr[6:0] = 7'b0010011;
                instr[14:12] = 3'b110;
            end
            "ANDI": begin
                instr[6:0] = 7'b0010011;
                instr[14:12] = 3'b111;
            end
            "SLLI": begin
                instr[6:0] = 7'b0010011;
                instr[14:12] = 3'b001;
                instr[31:25] = 7'b0000000;
            end
            "SRLI": begin
                instr[6:0] = 7'b0010011;
                instr[14:12] = 3'b101;
                instr[31:25] = 7'b0000000;
            end
            "SRAI": begin
                instr[6:0] = 7'b0010011;
                instr[14:12] = 3'b101;
                instr[31:25] = 7'b0100000;
            end
            "random": begin end
            default: begin  
                `uvm_fatal("Sequence Item i", "Operation not supported")
            end
        endcase
 
        instr[11:7] = rd; 
        instr[19:15] = rs1; 
        instr[31:20] = imm; 
    
    endfunction


endclass: i_seq_item