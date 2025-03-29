module riscv_tb;

  bit         clk, rst_n;
  
  initial begin
    $readmemh("instructions.txt" , dut.Instr_Mem.mem);

    reset_seq; 

    repeat(20) @(posedge clk) begin
        $display("x10: %d\n", dut.Reg.regfile[10]);
        $display("x11: %d\n", dut.Reg.regfile[11]);
        $display("x12: %d\n", dut.Reg.regfile[12]);
    end; 

    $writememh("output.txt" , dut.Reg.regfile);

    $stop;
  end
  
  // Reset task: uses active-low reset behavior.
  task automatic reset_seq;
    begin
      rst_n = 0;  
      #20;
      rst_n = 1;   
    end
  endtask
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  riscv dut(.*);
  

endmodule
