module IR_dff(
    output logic [31:0] out,
    input logic clk,
    input logic rst,
    input logic br_taken,
    input logic [31:0] in
);

    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            out <= 32'b0;
        else if (br_taken)
            // Inject a NOP: addi x0, x0, 0
            out <= 32'b000000000000_00000_000_00000_0010011;
        else
            out <= in;
    end
endmodule
