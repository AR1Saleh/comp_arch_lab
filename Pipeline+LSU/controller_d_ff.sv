
module controller_d_ff(
    output logic out,
    input logic clk,rst,in
);
    always @(posedge clk or negedge rst) begin
        if (~rst) out <= 1'b0;
        else out <= in;
    end
endmodule
