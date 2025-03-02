module riscv_tb;

  bit         clk, rst_n;
  
  initial begin
    $readmemh("instructions.txt" , dut.Instr_Mem.mem);

    reset_seq; 
    
    //monitor;
    //$writememh("check.txt" , dut.Instr_Mem.mem);

    repeat(20) @(posedge clk); 

    $writememh("output.txt" , dut.Reg.regfile);

    $stop;
  end
  
  // Monitor task: prints out selected register values on every posedge clk.
  task automatic monitor;
    begin
      #10;
      $display("x3: %d", dut.Reg.regfile[3]);
      $display("\n");
      $stop;
    end
  endtask
  
  // Task to load instructions from file "instructions.txt"
  /*task automatic load_instr;
    int fid, status;
    logic [31:0] instruction;

    begin

      fid = $fopen("C:\Users\HP\Desktop\instructions.txt", "rt");

      if (fid == 0) begin
        $error("Error: Unable to open file.");
      end

      waddr = 0;
      wr_en = 1'b1;
      
      while (!$feof(fid)) begin
        status = $fscanf(fid, "%h\n", instruction);
        $display("Instruction: %h", instruction);
        @(posedge clk);
        instr <= instruction;
        waddr <= waddr + 1;
      end
      
      $fclose(fid);

    end

  endtask
  */

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
