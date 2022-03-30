class riscv_config extends uvm_object;

  `uvm_object_utils(riscv_config);

  virtual riscv_if riscv_vif;
  
  function new (string name = "riscv_config");
    super.new(name);
  endfunction : new

endclass: riscv_config