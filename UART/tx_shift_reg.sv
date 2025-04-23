// Takes in 8 bit of data parallel data from fifo, attaches start and stop bit to it 
// transmits the content serially at baud rate

module tx_shift_register (
	input logic [7:0] data,
	input logic baud_tick,
	input logic clk,rst,data_valid,
	output logic sr_out,
	output logic busy
);
	logic [9:0] reg_out;
	logic [3:0] count;
	always_ff @(posedge baud_tick or posedge rst) begin
        if (rst) begin
            reg_out <= 10'b1111111111;  // Idle state
            count <= 4'd0;
            busy <= 1'b0;
            sr_out <= 1'b1;  // Idle high
        end else begin
            if (count == 4'd0) begin
                if (data_valid) begin
                    reg_out <= {1'b1, data, 1'b0};  // [stop, data, start]
                    count <= 4'd1;  // Start shifting
                    busy <= 1'b1;
                end else begin
                    sr_out <= 1'b1;  // Idle high
                    busy <= 1'b0;
                end
            end else begin
                reg_out <= {1'b1, reg_out[9:1]};  // Shift right
                sr_out <= reg_out[0];  // Output LSB
                count <= (count == 4'd10) ? 4'd0 : count + 1;
                busy <= (count < 4'd10);  // Busy until stop bit sent
            end
        end
    end
endmodule
