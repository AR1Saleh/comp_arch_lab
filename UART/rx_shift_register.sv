//This shift register will serially accept the data, store it in a buffer
//and put it in a rx fifo. it will recieve bits with clk, but the incoming bits
//will be sampled with baud_ticks
//==============================================================================
// rx_shift_register.sv
// UART RX shift register—samples serial data, extracts bytes,
// detects framing and break errors, and pulses valid flags.
// Compatible with a following rx_fifo to buffer received data + flags.
//==============================================================================

module rx_shift_register #(
    // number of ticks per bit (must match tx side bitrate)
    parameter int BREAK_LIMIT = 10    // bit-times to detect break condition
)(
    input  logic       clk,          // system clock
    input  logic       rst_n,        // active-low async reset
    input  logic       baud_tick,    // high one cycle per bit-time
    input  logic       sr_in,        // serial RX input

    output logic [7:0] data,         // received data byte
    output logic       data_valid,   // pulses when 'data' is ready
    output logic       frame_error,  // high if stop bit was invalid
    output logic       break_error,  // high while line held low for BREAK_LIMIT
    output logic       break_valid   // pulses when break_error first asserted
);

  // shift register for incoming bits: [7:0]
  logic [7:0] shift_reg;
  // bit counter: 0 = idle, 1..8 data bits, 9 stop bit sample, 10 end
  logic [3:0] count;
  // break detection counter
  logic [$clog2(BREAK_LIMIT+1)-1:0] break_count;

  // sequential sampling & state machine
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      count        <= 4'd0;
      shift_reg    <= '0;
      data         <= '0;
      data_valid   <= 1'b0;
      frame_error  <= 1'b0;
      break_count  <= '0;
      break_error  <= 1'b0;
      break_valid  <= 1'b0;
    end else if (baud_tick) begin
      // default: clear data_valid and break_valid
      data_valid  <= 1'b0;
      break_valid <= 1'b0;

      if (count == 4'd0) begin
        // --- Idle state -----------------------------------------------------
        // Break detection: line held low when idle
        if (!sr_in) begin
          break_count <= break_count + 1;
          if (break_count + 1 == BREAK_LIMIT) begin
            break_error <= 1'b1;
            break_valid <= 1'b1;
          end
        end else begin
          break_count <= '0;
          break_error <= 1'b0;
        end

        // Detect start bit (falling edge)
        if (!sr_in) begin
          count       <= 4'd1;
          shift_reg   <= '0;
          frame_error <= 1'b0;
        end

      end else begin
        // --- Receiving state ------------------------------------------------
        if (count >= 4'd1 && count <= 4'd8) begin
          // sample data bits LSB first
          shift_reg[count-1] <= sr_in;
        end else if (count == 4'd9) begin
          // sample stop bit: should be high
          if (!sr_in) frame_error <= 1'b1;
        end

        // advance or finish
        if (count == 4'd10) begin
          // end of frame
          data       <= shift_reg;
          data_valid <= 1'b1;
          count      <= 4'd0;
        end else begin
          count <= count + 1;
        end
      end
    end
  end
endmodule
