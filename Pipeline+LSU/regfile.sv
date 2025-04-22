
module regfile(
        input clk,rst_n,wr_en,
        input [4:0] reg_addr1,reg_addr2,wr_addr,
        input [31:0] wr_data,
        output [31:0] reg_data1,reg_data2
    );
    reg [31:0] regfile [31:0];
    int i;
   
   initial begin
        //regfile[1] = 32'd11;
        //regfile[2] = 32'd9;
        //regfile[3] = 32'd1;
        //regfile[4] = 32'd2;
        //regfile[5] = 32'd6;
        //regfile[7] = 32'd1;
        //regfile[12] = 32'd11;
   end

    assign reg_data1 = regfile[reg_addr1];
    assign reg_data2 = regfile[reg_addr2];
   
   always @(negedge clk) begin
        regfile[0] <= 32'b0;
   end
   
    always @(negedge clk, negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i<32; i++) begin
                regfile[i] <= 32'b0;
            end
        end
        else if (wr_en) begin
            regfile[wr_addr] <= wr_data;
        end 
    end
endmodule

