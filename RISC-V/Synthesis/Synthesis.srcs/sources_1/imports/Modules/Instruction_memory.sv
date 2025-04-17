module Instruction_memory(
    input  logic [31:0] addr,
    output logic [31:0] instr
);

    // 19-word instruction ROM (addresses 0..18)
    logic [31:0] mem [18:0] = '{
        //  0
        32'h00a00093,
        //  1
        32'h00102023,
        //  2
        32'h00002103,
        //  3
        32'h00100093,
        //  4
        32'h00500113,
        //  5
        32'h00000013,
        //  6
        32'h002081b3,
        //  7
        32'h00100093,
        //  8
        32'h00500113,
        //  9
        32'h002081b3,
        // 10
        32'h00100093,
        // 11
        32'h00100113,
        // 12
        32'h00208463,
        // 13
        32'h00108093,
        // 14
        32'h00108093,
        // 15
        32'h00100093,
        // 16
        32'h00102023,
        // 17
        32'h00002103,
        // 18
        32'h00110193
    };

    // byte-address ? word index
    assign instr = mem[addr >> 2];

endmodule
