
module d_ff(
    output logic [31:0]out,
    input logic clk,rst, [31:0]in
    );
    
    always @(posedge clk or negedge rst) begin
        if (~rst) out <= 32'b0;
        else out <= in;
    end
    
endmodule

