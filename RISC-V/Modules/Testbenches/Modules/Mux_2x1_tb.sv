class baz;
    rand bit [31:0] x,y;
    rand bit z;
endclass

module Mux_2x1_tb;

localparam period = 10;
logic [31:0] in1;
logic [31:0] in2;
logic [31:0] out;
logic MemtoReg;

Mux_2x1 uut(
    .in1(in1),
    .in2(in2),
    .MemtoReg(MemtoReg),
    .out(out)
);

task test_select1;
    baz b;
    b = new();
    b.randomize();
    in1 = b.x;
    in2 = b.y;
    MemtoReg = b.z;
endtask

initial begin

    repeat (5) begin
        test_select1();
        #period;
        $display("in1 = %d, in2 = %d, MemtoReg = %b, out = %d",in1,in2,MemtoReg,out);
    end

end

endmodule



