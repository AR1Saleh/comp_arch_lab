
module Instruction_memory(
    input logic     [31:0]  addr,
    output logic    [31:0]  instr
);

    logic [31:0] mem [63:0]; 
    /*
    initial begin
        mem[0] = 32'h02500193;
        mem[1] = 32'h02000513;
        mem[2] = 32'h00a1f0b3;
        mem[3] = 32'h00a52023;
        mem[4] = 32'h00452503;
        mem[5] = 32'hfea3cce3;
        mem[6] = 32'h00a1e2b3;
        mem[7] = 32'h40a1d2b3;
    end
    */
    assign instr = mem[addr >> 2];

endmodule

