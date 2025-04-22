
module mux_wb(
    input [1:0] sel,
    input [31:0] in1,in2,in3,
    output logic [31:0] mux_out
    );
    
    always_comb begin
        case (sel)
            2'b00: mux_out = in1;
            2'b01: mux_out = in2;
            2'b10: mux_out = in3;
            default: mux_out = 32'b0;
        endcase
    end
endmodule
