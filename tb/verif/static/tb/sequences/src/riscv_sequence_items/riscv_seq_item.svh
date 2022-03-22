

class riscv_seq_item extends uvm_sequence_item;
  
  `uvm_object_utils(riscv_seq_item)


  rand bit [31:0] instr;


  // Memory constraint 
  // Any branch cannot get overflow 
  
  function new (string name = "riscv_seq_item");
      super.new(name);
    endfunction
  
  
  virtual function void set_instr_b(bit [31:0] input_instr); 
    instr = input_instr; 
  endfunction

  
  extern virtual function string print_trans(integer print_style);

   
endclass: riscv_seq_item



function string riscv_seq_item::print_trans(integer print_style);
  string s, m, i, k, instr_name; 
   

  if(print_style == 0) begin 
    s = {s, $sformatf("\n0x%h", instr)};  

  end 
  else if(print_style == 1) begin 
    s = {s, $sformatf("\n%b", instr)};

  end 
  else if(print_style == 2) begin 
    case(instr[6:0]) inside
      7'b0110111, 7'b0010111, 7'b1101111: begin  // LUI, AUIPC, JAL
        m = $sformatf("\n|              Imm             |  rd   |  opcode    |"); 
        i = $sformatf("\n|   %b_%b_%b_%b_%b   | %b |  %b   |", instr[31:28], instr[27:24], instr[23:20], instr[19:16], instr[15:12], instr[11:7] ,instr[6:0]); 
      end
      7'b1100111, 7'b0000011, 7'b0010011: begin // JALR, Load, I type
        m = $sformatf("\n|       Imm      |  rs1  |  R  |  rd   |  opcode    |"); 
        i = $sformatf("\n| %b_%b_%b | %b | %b | %b |  %b   |", instr[31:28], instr[27:24], instr[23:21], instr[20:15], instr[14:12], instr[11:7] ,instr[6:0]); 
      end
      7'b0100011, 7'b0110011, 7'b1100011: begin // S Type, R Type, B Type
        if(instr[6:0] == 7'b0110011) begin 
          k ="rd ";
        end else begin 
          k ="imm";
        end
        
        m = $sformatf("\n|    R7    |  rs2  |  rs1  |  R3 |  %s  |  opcode  |", k); 
        i = $sformatf("\n| %b_%b | %b | %b | %b | %b |  %b |", instr[31:28], instr[27:24], instr[23:20], instr[19:15], instr[14:12], instr[11:7], instr[6:0]);
      end
      default: begin `uvm_fatal("Sequence Item","Instruction is not supported"); end
    endcase

    s = {s, $sformatf("\n|---------------------------------------------------|")};
    s = {s, m};
    s = {s, i};
    s = {s, $sformatf("\n|---------------------------------------------------|")};

  end 
  else if(print_style==3) begin 
    case(instr[6:0]) inside
      7'b1101111, 7'b0010111, 7'b0110111: begin 
        case(instr[6:0])
          7'b0110111 : instr_name = "LUI";
          7'b0010111 : instr_name = "AUIPC";
          7'b1101111 : instr_name = "JAL";
        endcase
        s = {s, $sformatf("\n %s", instr_name)};
        s = {s, $sformatf(" Rd[0x%h]", instr[11:7])};
        s = {s, $sformatf(" 0x%h", instr[31:12])};
      end
      7'b1100111 :  begin 
        instr_name = "JALR";
        s = {s, $sformatf("\n %s", instr_name)};
        s = {s, $sformatf(" Rd[0x%h]", instr[11:7])};
        s = {s, $sformatf(" Rs1[0x%h]", instr[19:15])};
        s = {s, $sformatf(" 0x%h", instr[31:20])};
      end
      7'b1100011 : begin
        case(instr[14:12]) 
          3'b000 : instr_name = "BEQ";
          3'b001 : instr_name = "BNE";
          3'b100 : instr_name = "BLT";
          3'b101 : instr_name = "BGE";
          3'b110 : instr_name = "BLTU";
          3'b111 : instr_name = "BGEU";
        endcase
        s = {s, $sformatf("\n %s", instr_name)};
        s = {s, $sformatf(" Rs1[0x%h]", instr[19:15])};
        s = {s, $sformatf(" Rs2m[0x%h]", instr[24:20]+{instr[31:25], instr[11:7]})};
      end
      7'b0000011 : begin
        case(instr[14:12]) 
          3'b000 : instr_name = "LB";
          3'b001 : instr_name = "LH";
          3'b010 : instr_name = "LW";
          3'b100 : instr_name = "LBU";
          3'b101 : instr_name = "LHU";
        endcase
        s = {s, $sformatf("\n %s", instr_name)};
        s = {s, $sformatf(" Rd[0x%h]", instr[11:7])};
        s = {s, $sformatf(" Rs1[0x%h]", instr[19:15])};
        s = {s, $sformatf(" 0x%h", instr[31:20])};
      end
      7'b0100011 : begin
        case(instr[14:12]) 
          3'b000 : instr_name = "SB";
          3'b001 : instr_name = "SH";
          3'b010 : instr_name = "SW";
        endcase
        s = {s, $sformatf("\n %s", instr_name)};
        s = {s, $sformatf(" Rs1[0x%h]", instr[19:15])};
        s = {s, $sformatf(" Rs2m[0x%h]", instr[24:20]+{instr[31:25], instr[11:7]})};
      end
      7'b0010011 : begin 
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
        s = {s, $sformatf("\n %s", instr_name)};
        s = {s, $sformatf(" Rd[0x%h]", instr[11:7])};
        s = {s, $sformatf(" Rs1[0x%h]", instr[19:15])};
        s = {s, $sformatf(" 0x%h", instr[31:20])};
      end
      7'b0110011 : begin
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
        s = {s, $sformatf("\n %s", instr_name)};
        s = {s, $sformatf(" Rd[0x%h]", instr[11:7])};
        s = {s, $sformatf(" Rs1[0x%h]", instr[19:15])};
        s = {s, $sformatf(" Rs2[0x%h]", instr[24:20])};
      end
      default: begin `uvm_fatal("Sequence Item","Instruction is not supported"); end
    endcase
  end 
  else begin 
    `uvm_fatal("Sequence Item","Printing input is not correct"); 
  end

  return s; 
endfunction: print_trans


    