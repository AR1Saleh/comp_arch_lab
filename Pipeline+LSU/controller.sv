
module controller(
        input [31:0] instr,
        output logic sel_B,sel_A,reg_wr_en,data_mem_wr_en,data_mem_rd_en,
        output logic [1:0] wb_sel,
        output logic [2:0] br_type,
        output logic [3:0] alu_op
    );
    
    logic [6:0] op_code;
    logic [2:0] func3;
    logic [6:0] func7;
    assign op_code = instr[6:0];
    assign func3 = instr[14:12];
    assign func7 = instr[31:25];
    
    always_comb begin
        if (op_code == 7'b0110011) begin  //R-type
        case ({func7,func3})
            {7'b0000000,3'b000}: alu_op = 4'b0000;//ADD
            {7'b0100000,3'b000}: alu_op = 4'b0001;//SUB
            {7'b0000000,3'b001}: alu_op = 4'b0010;//SLL
            {7'b0000000,3'b010}: alu_op = 4'b0011;//SLT
            {7'b0000000,3'b011}: alu_op = 4'b0100;//SLTU
            {7'b0000000,3'b100}: alu_op = 4'b0101;//XOR
            {7'b0000000,3'b101}: alu_op = 4'b0110;//SRL
            {7'b0100000,3'b101}: alu_op = 4'b0111;//SRA
            {7'b0000000,3'b110}: alu_op = 4'b1000;//OR
            {7'b0000000,3'b111}: alu_op = 4'b1001;//AND
            default: alu_op = 4'bx;
        endcase
        end
        else if (op_code == 7'b0010011) begin //I-type
            case(func3)
                3'b000: alu_op = 4'b0000;//ADDI
                3'b010: alu_op = 4'b0011;//SLTI
                3'b011: alu_op = 4'b0100;//SLTIU
                3'b100: alu_op = 4'b0101;//XORI
                3'b110: alu_op = 4'b1000;//ORI
                3'b111: alu_op = 4'b1001;//ANDI
                3'b001: if (func7 == 7'b0000000)
                            alu_op = 4'b0010;//SLLI
                        else alu_op = 4'bxxxx;
                3'b101: if (func7 == 7'b0000000)
                            alu_op = 4'b0110;//SRLI
                        else alu_op = 4'bxxxx;
                3'b101: if (func7 == 7'b0000000)
                            alu_op = 4'b0111;//SARI
                        else alu_op = 4'bxxxx;
                default: alu_op = 4'bx;
            endcase     
        end
        else if (op_code == 7'b0100011) begin //S-type
            alu_op = 4'b0000;//ADD
        end
        else if (op_code == 7'b0000011) begin //I-type Load
            alu_op = 4'b0000;//ADD
        end
        else if (op_code == 7'b1100011) begin //B-type
            alu_op = 4'b0000;//ADD
        end
        else if (op_code == 7'b0110111) begin //U-type LUI
            alu_op = 4'b1010;//LUI
        end
        else if (op_code == 7'b0010111) begin //U-type AUIPC
            alu_op = 4'b0000;//ADD
        end
        else if (op_code ==  7'b1101111) begin //J-type JAL
            alu_op = 4'b0000;
        end
        else if (op_code == 7'b1100111) begin //JALR
            alu_op = 4'b0000;
        end
    end
    
    always_comb begin
        case (op_code)
            7'b0110011: sel_B = 1'b0;//R-type
            default: sel_B = 1'b1;
        endcase
    end
    
    always_comb begin
        case (op_code)
            7'b0110011: reg_wr_en = 1'b1;//R-type
            7'b0010011,//I-type
            7'b0000011: reg_wr_en = 1'b1;//I-type Load
            7'b0110111,//U-type LUI
            7'b0010111: reg_wr_en = 1'b1;//U-type AUIPC
            7'b1101111: reg_wr_en = 1'b1;//J-type JAL
            7'b1100111: reg_wr_en = 1'b1;//JALR
            default: reg_wr_en = 1'b0;
        endcase        
    end
    
    always_comb begin
        case (op_code)
            7'b0100011: begin data_mem_wr_en = 1'b1; //S-type
                        data_mem_rd_en = 1'b0; end
            7'b0000011: begin data_mem_wr_en = 1'b0; //I-type
                        data_mem_rd_en = 1'b1; end 
            default: begin
                     data_mem_wr_en = 1'b0;
                     data_mem_rd_en = 1'b0; end
        endcase
    end
    
    always_comb begin
        case (op_code)
            7'b0000011: wb_sel = 2'b01; //I-type load
            7'b1100111, //JALR
            7'b1101111: wb_sel = 2'b10; //J-type JAL
            default: wb_sel = 2'b00;
        endcase
    end
    
    always_comb begin
        case(op_code)
            7'b1100011: sel_A = 1'b1; //B-type
            7'b0010111: sel_A = 1'b1; //U-type AUIPC
            7'b1101111: sel_A = 1'b1; //J-type JAL
            default: sel_A = 1'b0;
        endcase
    end
    
    always_comb begin
        if (op_code == 7'b1100011) begin //B-type
            br_type = func3;
        end
        else if (op_code == 7'b1101111) begin //J-type JAL
            br_type = 3'b011;
        end
        else if (op_code == 7'b1100111) begin //JALR
            br_type = 3'b011;
        end
        else br_type = 3'b010;
    end
    
endmodule
