module ALU_Ctrl (
    input  logic [1:0]             alu_op,
    input  logic [3:0]             funct73,         

    output logic [3:0]             operation      
);

    always_comb begin : Ctrl

        if(alu_op == 2'b00) begin 
            operation = 4'b0010;
        end
        if (alu_op[1] == 1'b1) begin
            if (funct73 == 4'b0000) begin
               operation = 4'b0010; 
            end
            if (funct73 == 4'b1000) begin
               operation = 4'b0110; 
            end
            if (funct73 == 4'b0111) begin
               operation = 4'b0000; 
            end
            if (funct73 == 4'b0110) begin
               operation = 4'b0001; 
            end
        end
        if(alu_op[0] == 1'b1) begin 
            operation = 4'b0110;
        end
    end
endmodule