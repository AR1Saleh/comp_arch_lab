module baud_rate_gen(
    input logic clk,          
    input logic rst,         
    output logic sample_enable // Sampling enable signal (16x baud rate)
);

    // clk = 16 MHz and baud rate = 115200:
    // divisor = (16,000,000) / (16 * 115200) = 8.681 = 8
    localparam DIVISOR = 8;
    logic [7:0] counter;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 8'b0;
            sample_enable <= 1'b0;
        end else begin
            if (counter == DIVISOR - 1) begin
                counter <= 8'b0;
                sample_enable <= 1'b1;
            end else begin
                counter <= counter + 1;
                sample_enable <= 1'b0;
            end
        end
    end

endmodule