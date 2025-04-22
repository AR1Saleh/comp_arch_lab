
module alu(
        input [3:0] alu_op,
        input [31:0] data1,data2,
        output logic [31:0] alu_out
    );
    always_comb begin
        case (alu_op)
            4'b0000: alu_out = data1 + data2;//ADD
            4'b0001: alu_out = data1 - data2;//SUB
            4'b0010: alu_out = data1 << data2[4:0];//SLL
            4'b0011: alu_out = ($signed(data1) < $signed(data2)) ? 32'b1:32'b0;//SLT
            4'b0100: alu_out = ($unsigned(data1) < $unsigned(data2)) ? 32'b1:32'b0;//SLTU
            4'b0101: alu_out = data1 ^ data2;//XOR
            4'b0110: alu_out = data1 >> data2[4:0];//SRL
            4'b0111: alu_out = $signed(data1) >>> data2[4:0];//SRA
            4'b1000: alu_out = data1 | data2;//OR
            4'b1001: alu_out = data1 & data2;//AND
            4'b1010: alu_out = data2;//LUI
            default: alu_out = 32'b0; 
        endcase
    end
endmodule
