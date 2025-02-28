module riscv_tb;

  bit         clk, rst_n, wr_en;
  logic [31:0] instr, waddr;
  
  initial begin
    reset_seq; 
    fork
        $readmemh("instructions.txt" , dut.Instr_Mem.mem); 
        $writememh("out.txt" , dut.Reg.regfile);
        monitor;
    join
    $stop;
  end
  
  // Monitor task: prints out selected register values on every posedge clk.
  task automatic monitor;
    begin
      #10;
      //$display("x1: %d", dut.Reg.regfile[1]);
      //$display("x2: %d", dut.Reg.regfile[2]);
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
      #50;
      rst_n = 1;   
    end
  endtask
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  riscv dut(.*);
  

endmodule
