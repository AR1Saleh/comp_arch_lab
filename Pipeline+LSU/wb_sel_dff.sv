
module wb_sel_dff(    
    output logic [1:0]out,
    input logic clk,rst,[1:0]in
);
    always @(posedge clk or negedge rst) begin
        if (~rst) out <= 2'b0;
        else out <= in;
    end

endmodule
