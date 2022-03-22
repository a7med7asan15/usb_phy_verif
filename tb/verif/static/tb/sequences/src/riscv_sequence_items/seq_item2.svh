class riscv_seq_item extends uvm_sequence_item;
  
  `uvm_object_utils(riscv_seq_item)
  
  logic [31:0]pc; 
  rand bit [31:0] instr;
  string instr_name;
  reg reset;

  
  
  function new (string name = "riscv_seq_item");
      super.new(name);
  endfunction
  
  
  // Opcode: instr[6:0]
  // Funct3: instr[14:12]
  // Funct7: instr[31:25]


  // constraint memory


  virtual function string convert2string;
    case(instr[6:0])
      7'b0110111 : instr_name = "LUI";
      7'b0010111 : instr_name = "AUIPC";
      7'b1101111 : instr_name = "JAL";
      7'b1100111 : instr_name = "JALR";
      7'b1100011 : 
        case(instr[14:12]) 
          3'b000 : instr_name = "BEQ";
          3'b001 : instr_name = "BNE";
          3'b100 : instr_name = "BLT";
          3'b101 : instr_name = "BGE";
          3'b110 : instr_name = "BLTU";
          3'b111 : instr_name = "BGEU";
        endcase
      7'b0000011 : 
        case(instr[14:12]) 
          3'b000 : instr_name = "LB";
          3'b001 : instr_name = "LH";
          3'b010 : instr_name = "LW";
          3'b100 : instr_name = "LBU";
          3'b101 : instr_name = "LHU";
        endcase
      7'b0100011 : 
        case(instr[14:12]) 
          3'b000 : instr_name = "SB";
          3'b001 : instr_name = "SH";
          3'b010 : instr_name = "SW";
        endcase
      7'b0010011 : 
        case(instr[14:12]) 
          3'b000 : instr_name = "ADDI";
          3'b010 : instr_name = "SLTI";
          3'b011 : instr_name = "SLTIU";
          3'b100 : instr_name = "XORI";
          3'b110 : instr_name = "ORI";
          3'b111 : instr_name = "ANDI";
          3'b001 : instr_name = "SLLI";
          3'b101 : instr_name = instr[30] ? "SRAI" : "SRLI";
        endcase
      7'b0110011 : 
        case(instr[14:12]) 
          3'b000 : instr_name = instr[30] ? "SUB" : "ADD";
          3'b010 : instr_name = "SLT";
          3'b011 : instr_name = "SLTU";
          3'b100 : instr_name = "XOR";
          3'b110 : instr_name = "OR";
          3'b111 : instr_name = "AND";
          3'b001 : instr_name = "SLL";
          3'b101 : instr_name = instr[30] ? "SRA" : "SRL";
        endcase
      //7'b0001111 : instr_name = instr[12] ? "FENCE.I" : "FENCE";
      // 7'b1110011 : 
      //   case(instr[14:12]) 
      //     3'b000 : instr_name = instr[20] ? "EBREAK" : "ECALL";
      //     3'b010 : instr_name = "CSRRS";
      //     3'b011 : instr_name = "CSRRC";
      //     3'b110 : instr_name = "CSRRSI";
      //     3'b111 : instr_name = "CSRRCI";
      //     3'b001 : instr_name = "CSRRW";
      //     3'b101 : instr_name = "CSRRWI";
      //   endcase
    endcase
    return $psprintf("INSTRUCTION = %h,  INSTRUCTION TYPE = %s, rd = %d",  instr, instr_name, instr[11:7]);
  endfunction: convert2string
     
endclass: riscv_seq_item

    