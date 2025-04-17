
module Registers(
        input clk,rst_n,wr_en,
        input [4:0] reg_addr1,reg_addr2,wr_addr,
        input [31:0] wr_data,
        output [31:0] reg_data1,reg_data2,x1,x10,x31
    );
    logic [31:0] regfile [31:0];
    int i;
   
    assign reg_data1 = regfile[reg_addr1];
    assign reg_data2 = regfile[reg_addr2];
   
    always @(negedge clk) begin
        regfile[0] <= 32'b0;
    end
   
    always @(negedge clk) begin
        if (!rst_n) begin
            for (i = 0; i<32; i++) begin
                regfile[i] <= 32'b0;
            end
        end
        else if (wr_en) begin
            regfile[wr_addr] <= wr_data;
        end 
    end

    assign x1 = regfile[1];
    assign x1 = regfile[10];
    assign x1 = regfile[31];
    
endmodule


