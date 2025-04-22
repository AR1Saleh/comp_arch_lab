/*
module pc(
        input clk,rst_n,
        input [31:0]  pc_next,
        output logic [31:0] pc_current
    );
    logic flag = 1'b0;
    always @(posedge clk,negedge rst_n) begin
        if (~rst_n) begin
            pc_current <= 32'b0;
        end
        else begin
            if (!flag) begin 
                pc_current <= 32'b0;
                flag <= 1'b1; end
            else
                pc_current <= pc_next;
        end
    end
endmodule
*/

module pc(
        input clk,rst_n,
        input [31:0]  pc_next,
        output logic [31:0] pc_current
    );
    always @(posedge clk,negedge rst_n) begin
        if (~rst_n) begin
            pc_current <= 32'b0;
        end
        else begin
            pc_current <= pc_next;
        end
    end
endmodule
