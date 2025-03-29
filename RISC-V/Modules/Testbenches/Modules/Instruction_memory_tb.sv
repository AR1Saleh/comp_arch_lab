class baz;
    rand int x;
    
    constraint x_constraint {
        x >= 0;
        x <= 31;
        x % 4 == 0;
    }

endclass

module Instruction_memory_tb;

localparam period = 10;
logic [31:0] instr;
logic [31:0] addr;

Instruction_memory uut(
    .addr(addr),
    .instr(instr)
);

task test_select1;
    baz b;
    b = new();
    b.randomize();
    addr = b.x;
endtask

initial begin

    $writememh("output.txt", uut.mem);

    addr = 32'b0;
    #period;
    $display("addr = %d, instr = %h",addr,instr);

    repeat (5) begin
        test_select1();
        #period;
        $display("addr = %d, addr_shifted = %d, instr = %h",addr,addr >> 2,instr);
    end

end

endmodule

