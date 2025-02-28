
module PC_tb;

localparam period = 10;
logic [31:0] pc_current;
logic [31:0] pc_next;
logic clk;
logic rst_n;

PC uut(
    .pc_current(pc_current),
    .pc_next(pc_next),
    .clk(clk),
    .rst_n(rst_n)
);

PC_Adder PC_Adder(
    .operand1(pc_current),
    .result(pc_next)
);

initial begin
    clk = 1'b1;
    rst_n = 1'b0;
end

always #5 clk=~clk;

initial begin
    #period;
    rst_n = 1'b1;
    $display("pc_current = %h, pc_next = %h",pc_current,pc_next);
    
    #period;
    $display("pc_current = %h, pc_next = %h",pc_current,pc_next);

    #period;
    $display("pc_current = %h, pc_next = %h",pc_current,pc_next);


end

endmodule

