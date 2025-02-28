class baz;
    rand bit [31:0] x,y;
endclass

module Branch_Adder_tb;

localparam period = 10;
logic [31:0] operand1;
logic [31:0] operand2;
logic [31:0] result;

Add uut(
    .operand1(operand1),
    .operand2(operand2),
    .result(result)
);

task test_select1;
    baz b;
    b = new();
    b.randomize();
    operand1 = b.x;
    operand2 = b.y;
endtask

initial begin
    operand1 = 5; operand2 = 5;
    #period;
    $display("operand1 = %d, operand2 = %d, result = %d",operand1,operand2,result);

    operand1 = 4; operand2 = 5;
    #period;
    $display("operand1 = %d, operand2 = %d, result = %d",operand1,operand2,result);

    operand1 = 4; operand2 = -5;
    #period;
    $display("operand1 = %d, operand2 = %d, result = %d",operand1,operand2,result);

    operand1 = 5; operand2 = 0;
    #period;
    $display("operand1 = %d, operand2 = %d, result = %d",operand1,operand2,result);

    repeat (5) begin
        test_select1();
        #period;
        $display("operand1 = %d, operand2 = %d, result = %d",operand1,operand2,result);
    end

end

endmodule

