class baz;
    rand bit [31:0] x,y;
    rand bit [3:0] z;

    constraint z_constraint {
        z inside {4'b0000, 4'b0001, 4'b0110, 4'b0100};
    }
    
endclass

module ALU_tb;

localparam period = 10;
logic [31:0] operand1;
logic [31:0] operand2;
logic [31:0] ALUresult;
logic [3:0] ALUoperation;
logic zero;

ALU uut(
    .operand1(operand1),
    .operand2(operand2),
    .ALUresult(ALUresult),
    .ALUoperation(ALUoperation),
    .zero(zero)
);

task test_select1;
    baz b;
    b = new();
    b.randomize();
    operand1 = b.x;
    operand2 = b.y;
    ALUoperation = b.z;
endtask

initial begin
    operand1 = 5; operand2 = 5; ALUoperation = 4'b0000;
    #period;
    $display("operand1 = %d, operand2 = %d, ALUoperation = %b, ALUresult = %d, zero = %b",operand1,operand2,ALUoperation,ALUresult,zero);

    operand1 = 4; operand2 = 5; ALUoperation = 4'b0001;
    #period;
    $display("operand1 = %b, operand2 = %b, ALUoperation = %b, ALUresult = %b, zero = %b",operand1,operand2,ALUoperation,ALUresult,zero);

    operand1 = 4; operand2 = 5; ALUoperation = 4'b0110;
    #period;
    $display("operand1 = %d, operand2 = %d, ALUoperation = %b, ALUresult = %b, zero = %b",operand1,operand2,ALUoperation,ALUresult,zero);

    operand1 = 5; operand2 = 5; ALUoperation = 4'b0110;
    #period;
    $display("operand1 = %d, operand2 = %d, ALUoperation = %b, ALUresult = %d, zero = %b",operand1,operand2,ALUoperation,ALUresult,zero);

    repeat (5) begin
        test_select1();
        #period;
        $display("operand1 = %d, operand2 = %d, ALUoperation = %b, ALUresult = %d, zero = %b",operand1,operand2,ALUoperation,ALUresult,zero);
    end

end

endmodule
