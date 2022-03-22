
interface riscv_if(input clk, input reset);  
  //timeunit 1ns;
  logic trap;
  logic [31:0] pc; //  program counter 32bit
  logic [31:0]instr; // instr 32bit  
  
  // clocking driver_cb @(posedge clk);
  //   output instr;
  //   input trap;
  //   input pc;
  // endclocking
  
  // clocking monitor_cb @(posedge clk);
  //   default input #2 output #2;
  //   input instr;
  //   input pc;
  //   input trap;
  // endclocking
  
  
  // modport DRIVER  (clocking driver_cb,input clk,reset);
  // modport MONITOR  (clocking monitor_cb,input clk,reset);

endinterface: riscv_if
    
    