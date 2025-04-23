//The LSU will write into this fifo, and the tx shift register will load from this fifo
//Its a 64 bit circular fifo

//==============================================================================
// tx_fifo.sv
// 64-byte circular FIFO (TX side) for UART
// Fully compatible with a UART TX shift register that asserts 'busy'
//==============================================================================
module tx_fifo #(
    parameter int DATA_WIDTH = 8,       // width of each entry
    parameter int DEPTH      = 64       // number of entries (must be power of 2)
)(
    input  logic                   clk,       // system clock
    input  logic                   rst_n,     // active-low async reset

    // write-side interface (from LSU)
    input  logic [DATA_WIDTH-1:0]  buff_in,   // data to enqueue
    input  logic                   wr_en,     // enqueue strobe, asserted by the LSU 
    output logic                   full,      // high when FIFO is full

    // read-side interface (to UART TX shift register)
    input  logic                   tx_busy,   // high while shift register is transmitting
    output logic [DATA_WIDTH-1:0]  buff_out,  // data being dequeued
    output logic                   empty,     // high when FIFO is empty
    output logic                   data_valid // pulses when buff_out is valid
);

  //------------------------------------------------------------------------------
  // Local parameters and signals
  //------------------------------------------------------------------------------
  localparam int PTR_W = $clog2(DEPTH);

  // storage array
  logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

  // write & read pointers
  logic [PTR_W-1:0] wr_ptr, rd_ptr;

  // occupancy counter: 0 .. DEPTH
  logic [$clog2(DEPTH+1)-1:0] count;

  // internal read-enable: when not busy and not empty
  logic rd_en;
  assign rd_en = (!tx_busy) && (!empty);

  //------------------------------------------------------------------------------
  // Sequential logic: pointers, storage writes, and count update
  //------------------------------------------------------------------------------
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wr_ptr <= '0;
      rd_ptr <= '0;
      count  <= '0;
    end else begin
      // enqueue
      if (wr_en && !full) begin
        mem[wr_ptr] <= buff_in;
        wr_ptr      <= wr_ptr + 1;
      end

      // dequeue
      if (rd_en && !empty) begin
        rd_ptr <= rd_ptr + 1;
      end

      // update occupancy: +1 for write, -1 for read
      count <= count + (wr_en && !full) - (rd_en && !empty);
    end
  end

  //------------------------------------------------------------------------------
  // Combinational outputs
  //------------------------------------------------------------------------------
  assign empty      = (count == 0);
  assign full       = (count == DEPTH);
  assign buff_out   = mem[rd_ptr];
  assign data_valid = (rd_en && !empty);

endmodule
