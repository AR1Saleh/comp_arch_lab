module shift_reg_Tx(
    input logic [7:0] sr_in,
    input logic fifo_out_ready,
    output logic sr_out,
    output logic sr_empty,
    input logic clk, rst
);
logic [7:0] baud_counter;
logic baud_en;
logic [7:0] baud_divisor;

logic [9:0] sr_reg;

assign sr_empty = (sr_reg == 10'b1111111111);
assign sr_out = sr_reg[0];

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        sr_reg <= 10'b1111111111;
        
        baud_counter <= 8'b0;
        baud_en <= 1'b0;
        baud_divisor <= 8'd139;
    
    end else begin
        if (fifo_out_ready && sr_empty) begin
            sr_reg <= {1'b1, sr_in, 1'b0};
        end else if (!sr_empty && baud_en) begin
            sr_reg <= {1'b1, sr_reg[9:1]};
        end
    end
end

always_ff @(posedge clk) begin
    if (baud_counter == baud_divisor -1) begin
        baud_counter <= 8'b0;
        baud_en <= 1'b1;
    end
    else begin
        baud_counter <= baud_counter + 1;
        baud_en <= 1'b0;
    end
end

endmodule