module Instruction_memory(
    input  logic [31:0] addr,
    output logic [31:0] instr
);

    // 64-word instruction ROM, first 10 entries are your hardwired instructions,
    // all others default to 0. Synthesizable in typical FPGA flows.
    logic [31:0] mem [9:0] = '{
        // Index 0
        32'h00100093,
        // Index 1
        32'h00102023,
        // Index 2
        32'h00002f83,
        // Index 3
        32'h00108a63,
        // Index 4
        32'h00108093,
        // Index 5
        32'h00108093,
        // Index 6
        32'h00108093,
        // Index 7
        32'h00108093,
        // Index 8
        32'h00002503,
        // Index 9
        32'h00108093
    };

    // Right-shift by 2 to index words in a byte-addressed scheme
    assign instr = mem[addr >> 2];

endmodule


