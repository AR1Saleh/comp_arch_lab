
module controller(
    input logic clk,
    input logic fifo_full_rx,
    input logic fifo_full_tx,
    input logic out_ready_rx,
    output logic readreg_empty,
    output logic overflow_error,
    output logic framing_error,
    output logic break_error,
    output logic in_ready_tx
    );
endmodule
