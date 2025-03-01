module UARTDR_Rx(
    input logic clk,
    input logic rst,
    input logic in_ready, //fifo not full
    input logic readreg_empty,
    input logic break_error,
    input logic framing_error,
    input logic overflow_error,
    input logic [7:0] sr_out,
    output logic [7:0] fifo_out,
    output logic out_ready, //fifo not empty
    output logic fifo_full
);

logic [10:0] fifo [3:0];
logic [1:0] write_ptr;
logic [1:0] read_ptr;
logic [2:0] count;

assign fifo_out = fifo[read_ptr];
assign fifo_full = (count == 4);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        write_ptr <= 2'b00;
        count <= 3'b000;
        for (int i = 0; i < 4; i++) begin
            fifo[i] <= 8'h00; //fifo is now empty
        end
    end else if (in_ready && (count < 4)) begin
        fifo[write_ptr] <= {overflow_error, framing_error, break_error, sr_out};
        write_ptr <= write_ptr + 1;
        count <= count + 1;
    end
end

assign out_ready = (count > 0) && readreg_empty;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        read_ptr <= 2'b00;
    end else if (out_ready) begin
        read_ptr <= read_ptr + 1;
        count <= count - 1;
    end
end

endmodule