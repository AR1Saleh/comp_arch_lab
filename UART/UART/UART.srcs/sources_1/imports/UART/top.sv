
module top(
    input logic clk,
    input logic rst
    );
 
 
 wire in_ready_tx;
 wire sr_empty_tx;
 wire sr_out_tx;
 wire [7:0] uartdr_in;
 wire [7:0] uartdr_out;
 wire fifo_full_tx;
 wire fifo_out_ready_tx;
 wire in_ready_rx;
 wire readreg_empty;
 wire break_error;
 wire framing_error;
 wire overflow_error;
 wire [7:0] sr_out_rx;
 wire [7:0] fifo_out_rx;
 wire out_ready_rx;
 wire fifo_full_rx;
 wire sample_enable;
 wire [7:0] read_reg_out;
 wire [7:0] write_reg_in;
 
 
 register write_reg(.clk(clk),.reset(rst),.data_in(write_reg_in),.data_out(uartdr_in));
 UARTDR_Tx UARTDR_Tx(.clk(clk),.rst(rst),.in_ready(in_ready_tx),.sr_empty(sr_empty_tx),.in(uartdr_in),.out(uartdr_out),.out_ready(fifo_out_ready_tx),.fifo_full(fifo_full_tx)); 
 shift_reg_Tx shift_reg_Tx(.clk(clk),.rst(rst),.sr_empty(sr_empty_tx),.sr_out(sr_out_tx),.fifo_out_ready(fifo_out_ready_tx),.sr_in(uartdr_out));  
 shift_reg_Rx shift_reg_Rx(.clk(clk),.rst(rst),.rx_in(sr_out_tx),.sample_enable(sample_enable),.rx_data(sr_out_rx),.data_ready(in_ready_rx));
 UARTDR_Rx UARTDR_Rx(.clk(clk),.rst(rst),.in_ready(in_ready_rx),.readreg_empty(readreg_empty),.sr_out(sr_out_rx),.fifo_out(fifo_out_rx),.out_ready(out_ready_rx),.fifo_full(fifo_full_rx));
 baud_rate_gen baud_rate_gen(.clk(clk),.rst(rst),.sample_enable(sample_enable));
 register read_reg(.clk(clk),.reset(rst),.data_in(fifo_out_rx),.data_out(read_reg_out));
 
endmodule
