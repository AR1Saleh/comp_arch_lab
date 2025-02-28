module register(
    input logic clk,
    input logic reset,
    input logic [7:0] data_in,
    output logic [7:0] data_out
);
    // Declare an 8-bit register
    logic [7:0] my_register;

    // Example of using the register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            my_register <= 8'b0;  // Reset the register to 0
        end else begin
            my_register <= data_in;  // Load input data into the register
        end
    end

    // Assign the register value to the output
    assign data_out = my_register;

endmodule