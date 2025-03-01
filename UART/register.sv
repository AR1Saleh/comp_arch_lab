
module register (
    input logic clk,          // Clock signal
    input logic reset,        // Reset signal (active-high)
    input logic enable,       // Enable signal (active-high)
    input logic [7:0] data_in,// 8-bit input data
    output logic [7:0] data_out// 8-bit output data
);

    // Declare the 8-bit register
    logic [7:0] my_register;

    // Update the register on clock edge or reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            my_register <= 8'b0;         // Reset to 0
        end else if (enable) begin        // Check if enable is active
            my_register <= data_in;       // Load data_in into the register
        end
        // If enable is 0, retain current value (no action needed)
    end
    // Assign register value to output
    assign data_out = my_register;

endmodule