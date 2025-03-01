module shift_reg_Rx(
    input logic rx_in,               // Serial input data
    input logic sample_enable,       // Sampling enable signal (e.g., from a baud rate generator)
    output logic [7:0] rx_data,      // Parallel output data
    output logic data_ready,         // Signal indicating data is ready
    input logic clk, rst             // Clock and reset
);

logic [9:0] sr_reg;                  // 10-bit shift register (1 start bit, 8 data bits, 1 stop bit)
logic [3:0] bit_count;               // Counter to track the number of bits received

// Assign outputs
assign rx_data = sr_reg[8:1];        // Extract the 8 data bits
assign data_ready = (bit_count == 4'd10); // Data is ready when all 10 bits are received

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the shift register and bit counter
        sr_reg <= 10'b0;
        bit_count <= 4'b0;
    end else if (sample_enable) begin
        if (bit_count == 4'd0) begin
            // Wait for start bit (falling edge of rx_in)
            if (rx_in == 1'b0) begin
                bit_count <= bit_count + 1; // Start bit detected
            end
            else bit_count <= 4'b0;
        end else if (bit_count < 4'd10) begin
            // Shift in the next bit
            sr_reg <= {rx_in, sr_reg[9:1]}; // Shift right and insert new bit at MSB
            bit_count <= bit_count + 1;
        end else begin
            // Reset after 10 bits are received
            bit_count <= 4'b0;
        end
    end
end

endmodule