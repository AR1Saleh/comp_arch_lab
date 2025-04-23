
module baud_gen #(
    parameter DVSR = 326 
)(
    input  logic clk,
    input  logic rst,
    output logic tick
);

logic [15:0] r_reg, r_next;  // Bit width depends on how big DVSR is

always_ff @(posedge clk or posedge rst) begin
    if (rst)
        r_reg <= 0;
    else
        r_reg <= r_next;
end

assign r_next = (r_reg == DVSR) ? 0 : r_reg + 1;

assign tick = (r_reg == DVSR);

endmodule
