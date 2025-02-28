module registers_tb;
bit                 clk,
                    rst_n;

logic               wr_en;

logic   [4:0]       reg_addr1,
                    reg_addr2,
                    wr_addr;
                    
logic   [31:0]      wr_data,
                    reg_data1,
                    reg_data2;                  


initial begin
    reset_seq;
    readwrite;
end
  
task automatic readwrite;
    for (i = 0; i < 32; i++) begin
        @(posedge clk) begin
            wr_data             <= #1 $random;
            wr_addr             <= #1 i;
            wr_en               <= #1 1; 
        end
    end
    for (i = 0; i < 16; i++) begin
        @(posedge clk) begin
            reg_addr1           <= #1 31-i;
            reg_addr2           <= #1 i;
        end
    end
endtask

task automatic reset_seq;
    rst_n              = 1;
    #50
    rst_n              = 0;
    #100
    rst_n              = 1;
endtask

// Clock generation
initial begin
    clk = 0;
    forever begin
        clk = #10 ~clk;
    end
end

Registers dut(.*);  

endmodule