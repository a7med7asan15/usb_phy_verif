

class riscv_scoreboard extends uvm_subscriber#(riscv_seq_item);
  
  `uvm_component_utils(riscv_scoreboard) 
  
  reg [31:0] stack[31:0];
  reg [31:0] mem[(2**25) - 1:0],	csr[4095:0];
  reg [31:0] dat;
  reg [31:0] pc, rd1, next_pc, reg_rd_dat, m_addr, m_dat, m_addr_obs, m_dat_obs, rd_dat, op1, op2, se_b;
  reg bflag = 0, m_flag = 0;
  uvm_analysis_imp #(riscv_seq_item, riscv_scoreboard) sc_port;

    
  	function new(string name, uvm_component parent);
       super.new(name, parent);
      sc_port = new("sc_port",this);
  
  	endfunction : new 
    
  
  function void write(input riscv_seq_item t);
    if(t.reset) begin
      stack[0] = 32'b0;
    
      
          
      if (bflag) begin		// 	Branch Check
        if (t.pc === next_pc)	begin 
          $display("\n\n//	 -----------------------------------------	Start Branch TEST	7-------------------------------------------   //\n");
          `uvm_info("score", "It does get printed", UVM_HIGH)
          `uvm_info(get_full_name(), $sformatf("PC STATUS :	 --------- PASS ---------	Expected :	%h		Observed :	%h", next_pc, t.pc), UVM_HIGH); 
          $display("\n//	 -----------------------------------------	End Branch TEST	-------------------------------------------   //\n\n");

        end 
        else begin
          $display("\n\n//	 -----------------------------------------	Start Branch TEST	6-------------------------------------------   //\n");
          `uvm_info("score", "It does get printed2", UVM_HIGH)
          `uvm_error(get_full_name(), $sformatf("PC STATUS :	 (!) ----------------FAIL 	Expected :	%h		Observed :	%h", next_pc, t.pc)); 
          $display("\n//	 -----------------------------------------	End Branch TEST	-------------------------------------------   //\n\n");

        end 
        bflag = 0;
      end

          
        
      if (m_flag) begin		// LOAD STORE Check
        uvm_config_db #(reg[31:0])::get(uvm_root::get(),"*","m_addr", m_addr_obs);   
        uvm_config_db #(reg[31:0])::get(uvm_root::get(),"*","m_dat", m_dat_obs);
        if ((m_dat === m_dat_obs) & (m_addr === m_addr_obs)) begin
          $display("\n\n//	 -----------------------------------------	Start Load Store TEST	-------------------------------------------   //\n");
          `uvm_info(get_full_name(), $sformatf("MEM STATUS :	 --------- PASS ---------	Expected :	[%h] , %h,		Observed :	[%h] , %h", m_addr, m_dat, m_addr_obs, m_dat_obs), UVM_HIGH);  
          $display("\n//	 -----------------------------------------	End Load Store TEST	-------------------------------------------   //\n\n");
        end 
        else begin
          $display("\n\n//	 -----------------------------------------	Start Load Store TEST	-------------------------------------------   //\n");
            `uvm_error(get_full_name(), $sformatf("MEM STATUS :	 (!) ----------------FAIL 	Expected :	[%h] , %h,		Observed :	[%h] , %h", m_addr, m_dat, m_addr_obs, m_dat_obs)); 
          $display("\n//	 -----------------------------------------	End Load Store TEST	-------------------------------------------   //\n\n");

        end 
        m_flag = 0; 

        end         
              
          
          
      case(t.instr[6:0]) 
          7'b0110111: begin	// LUI
            stack[t.instr[11:7]] = {t.instr[31:12], 12'b0};
            end
          
          7'b0010111: 	begin//	AUIPC
            stack[t.instr[11:7]] = {t.instr[31:12], 12'b0} + t.pc;
          end
            
            
          7'b1101111: 	begin//	JAL
            stack[t.instr[11:7]] = 32'd4 + t.pc;
            next_pc = (t.pc + $signed({{12{t.instr[31]}},t.instr[19:12], t.instr[20], t.instr[30:21],1'b0})); 
            bflag = 1;
          end
          
          7'b1100111: 	begin//	JALR
            next_pc = ($signed({{21{t.instr[31]}},t.instr[30:20]}) + $signed(stack[t.instr[19:15]])) & 32'hfffffffe;
            stack[t.instr[11:7]] = 32'd4 + t.pc;
            bflag = 1;
          end 
          
          7'b1100011: 	begin
            bflag = 1;
            op1 = stack[t.instr[19:15]];
            op2 = stack[t.instr[24:20]];
            se_b = $signed({{20{t.instr[31]}},t.instr[7],t.instr[30:25],t.instr[11:8],1'b0});          
    //          `uvm_info("SCOREBOARD", "op1 = %h, op2 = %h, Imm = %h",op1, op2, se_b);		  
            case(t.instr[14:12])
              3'b000	:	begin	//	BEQ
                if(op1 == op2) 	next_pc = se_b + t.pc;
                else 	next_pc = t.pc + 32'd4;
              end
              
              3'b001	:	begin	//	BNE
                if(op1 == op2) 	next_pc = t.pc + 32'd4;
                else 	next_pc = se_b + t.pc;
              end 
              
              3'b100	:	begin	//	BLT
                if($signed(op1) < $signed(op2))	next_pc = se_b + t.pc;
                else next_pc = t.pc + 32'd4;
              end
              
              3'b101	:	begin	//	BGE
                if ($signed(op1) > $signed(op2)) next_pc = se_b + t.pc;
                else next_pc = t.pc + 32'd4;
              end
              
              3'b110	:	begin	//	BLTU 
                if(op1 < op2) next_pc = se_b + t.pc;
                else next_pc = t.pc + 32'd4;
              end 
              
              3'b111	:	begin	//	BGEU
                if(op1 > op2) 	next_pc = se_b + t.pc;
                else 	next_pc = t.pc + 32'd4;
              end
            endcase     
          end
        
          
          7'b0000011 : begin	//	LOAD
            m_flag = 1;
            if (t.instr[14])	m_addr = (stack[t.instr[19:15]] + {{21{t.instr[31]}},t.instr[30:20]}) << 2;
            else 	m_addr = ($signed(stack[t.instr[19:15]]) + $signed({{21{t.instr[31]}},t.instr[30:20]})) << 2;
            case(t.instr[14:12])
              3'b000 : 	stack[t.instr[11:7]] = (mem[m_addr]) & 32'h000000ff;
              3'b001 : 	stack[t.instr[11:7]] = (mem[m_addr]) & 32'h0000ffff;
              3'b010 : 	stack[t.instr[11:7]] = (mem[m_addr]);
              3'b100 : 	stack[t.instr[11:7]] = (mem[m_addr]) & 32'h000000ff;
              3'b101 : 	stack[t.instr[11:7]] = (mem[m_addr]) & 32'h0000ffff;         
            endcase 
            if (t.instr[11:7] == 5'b00000)	begin
              stack[t.instr[11:7]] = 32'b0;
            end
            m_dat =  stack[t.instr[11:7]];
          end
          
        
        7'b0100011 : begin	//	STORE
            m_flag = 1;
            m_addr = (stack[t.instr[19:15]] + {{21{t.instr[31]}},t.instr[30:25],t.instr[11:7]}) << 2;
            case(t.instr[14:12])
              3'b000 : 	m_dat = stack[t.instr[24:20]] & 32'h000000ff;
              3'b001 : 	m_dat = stack[t.instr[24:20]] & 32'h0000ffff;
              3'b010 : 	m_dat = stack[t.instr[24:20]];
            endcase
            mem[m_addr] = m_dat ;
          end
                  
          
        7'b0010011: begin	// I
            case(t.instr[14:12])
              3'b000	:	stack[t.instr[11:7]] = $signed(stack[t.instr[19:15]]) + $signed({{21{t.instr[31]}},t.instr[30:20]});
              3'b010	:	stack[t.instr[11:7]] = ($signed(stack[t.instr[19:15]]) < $signed({{21{t.instr[31]}},t.instr[30:20]})) ? 32'b1 : 32'b0;
              3'b011	:	stack[t.instr[11:7]] = (stack[t.instr[19:15]] < {{21{t.instr[31]}},t.instr[30:20]}) ? 32'b1 : 32'b0;
              3'b100	:	stack[t.instr[11:7]] = stack[t.instr[19:15]] ^ {{21{t.instr[31]}},t.instr[30:20]};
              3'b110	:	stack[t.instr[11:7]] = stack[t.instr[19:15]] | {{21{t.instr[31]}},t.instr[30:20]};
              3'b111	:	stack[t.instr[11:7]] = stack[t.instr[19:15]] & {{21{t.instr[31]}},t.instr[30:20]};
              3'b001	:	stack[t.instr[11:7]] = stack[t.instr[19:15]] << t.instr[24:20];
              3'b101	:	begin
                            stack[t.instr[11:7]] = stack[t.instr[19:15]] >> t.instr[24:20];;
                            if(t.instr[30])	stack[t.instr[11:7]][31] = stack[t.instr[19:15]][31];
                        end
            endcase
            if (t.instr[11:7] == 5'b00000) begin
              stack[t.instr[11:7]] = 32'b0;
            end
    //       `uvm_info(get_full_name(), "reg[%d] <- %h = %h %h",t.instr[11:7],stack[t.instr[11:7]],  stack[t.instr[19:15]] , {{21{t.instr[31]}},t.instr[30:20]});
        end 

          
          
        7'b0110011:	begin	//	R
            case(t.instr[14:12])
              3'b000	:	begin
                if (t.instr[30] == 1'b1) begin 
                  stack[t.instr[11:7]] = $signed(stack[t.instr[19:15]]) - $signed(stack[t.instr[24:20]]);
                end
                else begin 
                  stack[t.instr[11:7]] = $signed(stack[t.instr[19:15]]) + $signed(stack[t.instr[24:20]]);
                end
              end
              3'b010	:	stack[t.instr[11:7]] = $signed(stack[t.instr[19:15]]) < $signed(stack[t.instr[24:20]]) ? 32'b1 : 32'b0;
              3'b011	:	stack[t.instr[11:7]] = stack[t.instr[19:15]] < stack[t.instr[24:20]] ? 32'b1 : 32'b0;
              3'b100	:	stack[t.instr[11:7]] = $signed(stack[t.instr[19:15]]) ^ $signed(stack[t.instr[24:20]]);
              3'b110	:	stack[t.instr[11:7]] = $signed(stack[t.instr[19:15]]) | $signed(stack[t.instr[24:20]]);
              3'b111	:	stack[t.instr[11:7]] = $signed(stack[t.instr[19:15]]) & $signed(stack[t.instr[24:20]]);
              3'b001	:	stack[t.instr[11:7]] = stack[t.instr[19:15]] << stack[t.instr[24:20]][4:0];
              3'b101	:	begin
                stack[t.instr[11:7]] = stack[t.instr[19:15]] >> stack[t.instr[24:20]][4:0];
                if(t.instr[30])	begin 
                  stack[t.instr[11:7]][31] = stack[t.instr[19:15]][31];  
                end
              end   
            endcase 
            if (t.instr[11:7] == 5'b00000) begin
              stack[t.instr[11:7]] = 32'b0;
            end
    //       `uvm_info(get_full_name(), "%h = %h %h",stack[t.instr[11:7]],  stack[t.instr[19:15]] , stack[t.instr[24:20]]);
          end
                  
            
        7'b1110011 : begin	//	CSR	
            case(t.instr[14:12]) 
              3'b000	:	begin	//	ECALL EBREAK
                csr[12'h341] = t.pc;
              end
              3'b001	:	begin	//	CSRRW
                if(t.instr[11:7] != 5'b00000) begin
                  stack[t.instr[11:7]] = csr[t.instr[31:20]];
                end
                csr[t.instr[31:20]] = stack[t.instr[19:15]];
              end
              3'b010	:	begin	//	CSRRS
                if(t.instr[11:7] != 5'b00000) begin
                  stack[t.instr[11:7]] = csr[t.instr[31:20]];
                end
                csr[t.instr[31:20]] = stack[t.instr[19:15]] | csr[t.instr[31:20]];
              end
              3'b011	:	begin	//	CSRRC
                if(t.instr[11:7] != 5'b00000) begin
                  stack[t.instr[11:7]] = csr[t.instr[31:20]];
                end
                csr[t.instr[31:20]] = ~stack[t.instr[19:15]] & csr[t.instr[31:20]];
              end
              3'b101	:	begin	//	CSRRWI
                if(t.instr[11:7] != 5'b00000) begin 
                  stack[t.instr[11:7]] = csr[t.instr[31:20]];
                end 
                csr[t.instr[31:20]] = {27'b0,t.instr[19:15]};
              end
              3'b110	:	begin	//	CSRRSI
                if(t.instr[11:7] != 5'b00000) begin 
                  stack[t.instr[11:7]] = csr[t.instr[31:20]];
                end 
                csr[t.instr[31:20]] = {27'b0,t.instr[19:15]} | csr[t.instr[31:20]];
              end
              3'b111	:	begin	//	CSRRCI
                if(t.instr[11:7] != 5'b00000) begin
                  stack[t.instr[11:7]] = csr[t.instr[31:20]];
                end 
                csr[t.instr[31:20]] = ~{27'b0,t.instr[19:15]} & csr[t.instr[31:20]];
              end
            endcase
        end 
          
      endcase  
      
      if ((t.instr[6:0] == 7'b0010011)  & (t.instr[31:20]== 12'b0) & (t.instr[14:12] == 3'b0)) begin 
        uvm_config_db #(reg[31:0])::get(uvm_root::get(),"*","rd1", reg_rd_dat);
        if (t.instr[11:7] == 32'b0) begin 
          $display("\n\n//	 -----------------------------------------	Start REG TEST 13	-------------------------------------------   //\n"); 
        end
        if (stack[t.instr[11:7]] === reg_rd_dat) 	begin
          $display("\n\n//	 -----------------------------------------	Start REG TEST 12	-------------------------------------------   //\n"); 
          `uvm_info(get_full_name(), $sformatf("REG x%d STATUS :	 --------- PASS ---------	Expected :	%h		Observed :	%h", t.instr[11:7], stack[t.instr[11:7]], reg_rd_dat), UVM_HIGH);
          $display("\n//	 -----------------------------------------	End REG TEST	-------------------------------------------   //\n\n");

        end 
        else begin	
          $display("\n\n//	 -----------------------------------------	Start REG TEST	8 -------------------------------------------   //\n"); 
          `uvm_error(get_full_name(), $sformatf("REG x%d STATUS :	 (!) ----------------FAIL 	Expected :	%h		Observed :	%h", t.instr[11:7], stack[t.instr[11:7]], reg_rd_dat));
          $display("\n//	 -----------------------------------------	End REG TEST	-------------------------------------------   //\n\n");

        end
      end
      else if ((t.instr[6:0] == 7'b0010011) | (t.instr[6:0] == 7'b0110011)) begin 
        uvm_config_db #(reg[31:0])::get(uvm_root::get(),"*","reg_rd_dat", reg_rd_dat);
        `uvm_info("SCOREBOARD", $psprintf("	%s", t.convert2string()), UVM_HIGH); 

        if (stack[t.instr[11:7]] === reg_rd_dat) 	begin
          $display("\n\n//	 -----------------------------------------	Start I/R TEST	-------------------------------------------   //\n");
          `uvm_info(get_full_name(), $sformatf("I/R x%d STATUS :	 --------- PASS ---------	Expected :	%h		Observed :	%h", t.instr[11:7], stack[t.instr[11:7]], reg_rd_dat), UVM_HIGH);
          $display("\n//	 -----------------------------------------	End I/R TEST	-------------------------------------------   //\n\n");
        end 
        else begin	
          $display("\n\n//	 -----------------------------------------	Start I/R TEST	-------------------------------------------   //\n");
          `uvm_error(get_full_name(), $sformatf("I/R x%d STATUS :	 (!) ----------------FAIL 	Expected :	%h		Observed :	%h", t.instr[11:7], stack[t.instr[11:7]], reg_rd_dat));
          $display("\n//	 -----------------------------------------	End I/R TEST	-------------------------------------------   //\n\n");

        end
      end
      
      else begin	
        `uvm_info("SCOREBOARD", $psprintf("	%s", t.convert2string()), UVM_HIGH);
      end
 
      
    end
  endfunction 
  

endclass: riscv_scoreboard
