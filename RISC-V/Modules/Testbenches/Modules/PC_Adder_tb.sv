class baz;
    rand bit [31:0] x;
endclass

module PC_Adder_tb;

localparam period = 10;
logic [31:0] operand1;
logic [31:0] operand2;
logic [31:0] result;

PC_Adder uut(
    .operand1(operand1),
    .result(result)
);

task test_select1;
    baz b;
    b = new();
    b.randomize();
    operand1 = b.x;
endtask

initial begin
    operand1 = 0;
    #period;
    $display("operand1 = %d, result = %d",operand1,result);

    repeat (5) begin
        test_select1();
        #period;
        $display("operand1 = %d, result = %d",operand1,result);
    end

end

endmodule


