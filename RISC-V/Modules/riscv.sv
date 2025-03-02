module riscv(
    input               clk,
                        rst_n             
);
    logic [31:0]    addresult;
    logic [31:0]    result;
    logic [31:0]    pc_next,
                    pc_current;
    PC PC (
        .clk(clk),
        .rst_n(rst_n),
        .pc_next(pc_next),
        .pc_current(pc_current)
    );

    PC_Adder PC_Adder (
        .operand1(pc_current),
        .result(result)
    );

    logic [31:0]    instr;
    Instruction_memory Instr_Mem (
        .addr(pc_current),
        .instr(instr)
    );

    logic           branch,
                    alu_src,
                    regwrite,
                    memread,
                    memwrite,
                    memtoreg;

    logic [1:0]     alu_op;
    controller Ctrl (
        .opcode(instr[6:0]),

        .branch(branch),
        .alu_src(alu_src),
        .regwrite(regwrite),
        .memread(memread),
        .memwrite(memwrite),
        .memtoreg(memtoreg),

        .alu_op(alu_op)
    );
    

    logic [31:0]    wr_data,
                    reg_data1,
                    reg_data2;
    Registers Reg (
        .reg_addr1(instr[19:15]),
        .reg_addr2(instr[24:20]),
        .wr_addr(instr[11:7]),
        .clk(clk),
        .rst_n(rst_n),
        .wr_data(wr_data),
        .reg_data1(reg_data1),
        .reg_data2(reg_data2),
        .wr_en(regwrite)
    );

    logic [31:0]    imm_val;
    imm_gen immgen (
        .instr(instr),
        .imm_val(imm_val)
    );

    logic [3:0]     operation; 
    ALU_Ctrl ALUctrl (
        .alu_op(alu_op),
        .funct73({instr[30],instr[14:12]}),
        .operation(operation)
    );

    logic [31:0]    imm_out;
    Mux_2x1 Imm_MUX (
        .MemtoReg(alu_src),
        .in1(reg_data2),
        .in2(imm_val),
        .out(imm_out)
    );

    logic           zero;
    logic [31:0]    ALUresult;
    ALU ALU (
        .operand1(reg_data1),
        .operand2(imm_out),
        .ALUoperation(operation),
        .ALUresult(ALUresult),
        .zero(zero)
    );

    Add Offset (
        .operand1(pc_current),
        .operand2(imm_val),
        .result(addresult)
    );

  
    Mux_2x1 Br_MUX (
        .MemtoReg((branch & zero)),
        .in1(result),
        .in2(addresult),
        .out(pc_next)
    );   

    logic [31:0]    read;
    Data_memory Data_Mem (
        .clk(clk), .wr_en(memwrite), .rd_en(memread),
        .addr(ALUresult), .wr_data(reg_data2),
        .rdata(read),
        .rst_n(rst_n)
    );

    Mux_2x1 Reg_MUX (
        .MemtoReg(memtoreg),
        .in1(ALUresult),
        .in2(read),
        .out(wr_data)
    ); 

endmodule