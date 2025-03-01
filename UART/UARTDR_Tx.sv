module UARTDR_Tx(
    input logic clk,
    input logic rst,
    input logic in_ready,
    input logic sr_empty,
    input logic [7:0] in,
    output logic [7:0] out,
    output logic out_ready,
    output logic fifo_full
);

logic [7:0] fifo [3:0];
logic [1:0] write_ptr;
logic [1:0] read_ptr;
logic [2:0] count;

assign out = fifo[read_ptr];
assign fifo_full = (count == 4);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        write_ptr <= 2'b00;
        count <= 3'b000;
    end else if (in_ready && (count < 4)) begin
        fifo[write_ptr] <= in;
        write_ptr <= write_ptr + 1;
        count <= count + 1;
    end
end

assign out_ready = (count > 0) && sr_empty;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        read_ptr <= 2'b00;
    end else if (out_ready) begin
        read_ptr <= read_ptr + 1;
        count <= count - 1;
    end
end

endmodule