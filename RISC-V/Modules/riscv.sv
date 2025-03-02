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

    logic [31:0]        f_pc;
    always_ff @(posedge clk) begin 
        f_pc        <= #1 pc_current;        
    end

    PC_Adder PC_Adder (
        .operand1(f_pc),
        .result(result)
    );
                    
    logic [31:0]    pc_4;
    always_ff @(posedge clk) begin 
        pc_4        <= #1 result;      
    end

    logic [31:0]    instr;
    Instruction_memory Instr_Mem (
        .addr(pc_current),
        .instr(instr)
    );

    logic [31:0]    ir;
    always_ff @(posedge clk) begin
        ir           <= #1 instr;   
    end

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
    
    logic [31:0]    ir_reg;
    logic           reg_wr,
                    mem_rd,
                    mem_wr,
                    memreg;

    always_ff @(posedge clk) begin
        ir_reg          <= #1 ir[11:7];
        reg_wr          <= #1 regwrite;
        mem_rd          <= #1 memread;
        mem_wr          <= #1 memwrite;
        memreg          <= #1 memtoreg;
    end

    logic [31:0]    wr_data,
                    reg_data1,
                    reg_data2;
    Registers Reg (
        .reg_addr1(ir[19:15]),
        .reg_addr2(ir[24:20]),
        .wr_addr(ir_reg),
        .clk(clk),
        .rst_n(rst_n),
        .wr_data(wr_data),
        .reg_data1(reg_data1),
        .reg_data2(reg_data2),
        .wr_en(reg_wr)
    );

    logic [31:0]    imm_val;
    imm_gen immgen (
        .instr(instr),
        .imm_val(imm_val)
    );

    logic [3:0]     operation; 
    ALU_Ctrl ALUctrl (
        .alu_op(alu_op),
        .funct73({ir[30],ir[14:12]}),
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
    
    logic [31:0]    de_pc,
                    alu,
                    wd;               
                    
    always_ff @(posedge clk) begin
        de_pc       <= #1 f_pc;        
        alu         <= #1 ALUresult;
        wd          <= #1 reg_data2;
    end

    Add Offset (
        .operand1(f_pc),
        .operand2(imm_val),
        .result(addresult)
    );
  
    logic [31:0]    add_pip;
    logic           brc;

    always_ff @(posedge clk) begin
        add_pip     <= #1 addresult;
        brc         <= #1 (branch & zero);
    end

    Mux_2x1 Br_MUX (
        .MemtoReg(brc),
        .in1(pc_4),
        .in2(add_pip),
        .out(pc_next)
    );   

    logic [31:0]    read;
    Data_memory Data_Mem (
        .clk(clk), .wr_en(mem_wr), .rd_en(mem_rd),
        .addr(alu), .wr_data(wd),
        .rdata(read),
        .rst_n(rst_n)
    );

    Mux_2x1 Reg_MUX (
        .MemtoReg(memreg),
        .in1(alu),
        .in2(read),
        .out(wr_data)
    ); 

endmodule