
module mux(
        input sel,
        input [31:0] in1,in2,
        output logic [31:0] mux_out
    );
    always_comb begin 
        mux_out = sel ? in2 : in1;
    end
endmodule
