class b_seq_item extends riscv_seq_item;
  
    `uvm_object_utils(b_seq_item)

    function new (string name = "b_seq_item");
        super.new(name);
    endfunction

    constraint opcode{ 
        instr[6:0] inside {7'b1100011};
    }; 

    constraint funct3{
        (instr[6:0] == 7'b1100011) -> (instr[14:12] inside {3'b000, 3'b001, 3'b100, 3'b101, 3'b110, 3'b111});
    };


    function void set_instr(string op = "random", bit [12:0] imm = {instr[31:25],instr[11:7],1'b0}, bit [4:0] rs1 = instr[19:15], bit [4:0] rs2 = instr[24:20]);  
        case(op)
            "BEQ": begin
                instr[14:12] = 3'b000;
            end
            "BNE": begin
                instr[14:12] = 3'b001;
            end
            "BLT": begin
                instr[14:12] = 3'b100;
            end
            "BGE": begin
                instr[14:12] = 3'b101;
            end
            "BLTU": begin
                instr[14:12] = 3'b110;
            end
            "BGEU": begin
                instr[14:12] = 3'b111;
            end
            "random": begin end
            default: begin  
                `uvm_fatal("Sequence Item b", "Operation not supported")
            end
        endcase
 
        instr[11:7] = {imm[4:1], imm[11]}; 
        instr[19:15] = rs1; 
        instr[24:20] = rs2; 
        instr[31:25] = {imm[12], imm[10:5]}; 
    
    endfunction


endclass: b_seq_item