//==============================================================================
// rx_fifo.sv
// Circular FIFO (RX side) stores received bytes + error flags
// DEPTH entries of {break_error, frame_error, data[7:0]}
//==============================================================================
module rx_fifo #(
    parameter int DATA_WIDTH = 8,
    parameter int DEPTH      = 64
)(
    input  logic                   clk,
    input  logic                   rst_n,

    // write-side: from RX shift register
    input  logic [DATA_WIDTH-1:0]  data_in,
    input  logic                   frame_error_in,
    input  logic                   break_error_in,
    input  logic                   wr_en,        // e.g., data_valid || break_valid

    // read-side: to LSU / processor
    input  logic                   rd_en,
    output logic [DATA_WIDTH-1:0]  data_out,
    output logic                   frame_error_out,
    output logic                   break_error_out,
    output logic                   empty,
    output logic                   full,
    output logic                   data_valid    // pulses when an entry dequeued
);

  // pointer widths
  localparam int PTR_W = $clog2(DEPTH);

  // each entry packs: [{break,frame}, data]
  logic [DATA_WIDTH+1:0] mem [0:DEPTH-1];
  logic [PTR_W-1:0]     wr_ptr, rd_ptr;
  logic [$clog2(DEPTH+1)-1:0] count;

  // sequential logic
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wr_ptr <= '0;
      rd_ptr <= '0;
      count  <= '0;
    end else begin
      // write
      if (wr_en && !full) begin
        mem[wr_ptr] <= {break_error_in, frame_error_in, data_in};
        wr_ptr      <= wr_ptr + 1;
      end
      // read pointer
      if (rd_en && !empty) begin
        rd_ptr <= rd_ptr + 1;
      end
      // update count
      count <= count + (wr_en && !full) - (rd_en && !empty);
    end
  end

  // combinational outputs
  assign empty            = (count == 0);
  assign full             = (count == DEPTH);
  assign data_out         = mem[rd_ptr][DATA_WIDTH-1:0];
  assign frame_error_out  = mem[rd_ptr][DATA_WIDTH];
  assign break_error_out  = mem[rd_ptr][DATA_WIDTH+1];
  assign data_valid       = (rd_en && !empty);

endmodule
