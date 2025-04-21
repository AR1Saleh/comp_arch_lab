module top(
    input                   clk,
                            rst_n,
                          
    output logic            clk_1,                            
    output logic    [6:0]   Dspout, 
    output logic    [3:0]   Segout                             
);

logic s_clk;

clk_div_1hz C1(
    .clk_100mhz(clk),
    .rst_n(rst_n),
    .clk_1hz(s_clk)
);

riscv(
    .clk(s_clk),
    .rst_n(rst_n),
    
    .Dspout(Dspout),
    .Segout(Segout)
);

assign clk_1 = s_clk; 

endmodule

module clk_div_1hz #(
    // For a 100 MHz source, half-period = 0.5 s × 100 MHz = 50_000_000 cycles
    localparam integer HALF_PERIOD    = 50_000_000,
    // 2^25 = 33 554 432 < 50 000 000 ? 2^26 = 67 108 864 ? need 26 bits
    localparam integer COUNTER_WIDTH  = 26
)(
    input                           clk_100mhz, rst_n, 
    output bit                      clk_1hz      // 1 Hz global clock
);

    // Counter and raw divider signal
    reg [COUNTER_WIDTH-1:0] counter;
    reg                    div_clk;

    // Divide logic: toggle div_clk every HALF_PERIOD cycles
    always_ff @(posedge clk_100mhz or negedge rst_n) begin
        if (!rst_n) begin
            counter <= '0;
            div_clk <= 1'b0;
        end else if (counter == HALF_PERIOD-1) begin
            counter <= '0;
            div_clk <= ~div_clk;
        end else begin
            counter <= counter + 1;
        end
    end

    // Feed the divided clock through a global buffer for low-skew distribution
    BUFG bufg_clk1hz (
        .I(div_clk),
        .O(clk_1hz)
    );

endmodule


module riscv(
    input                   clk,
                            rst_n,   

    output logic    [6:0]   Dspout, 
    output logic    [3:0]   Segout                      
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
        if (!rst_n) begin
            f_pc            <= #1 0;
        end
        else begin
            f_pc            <= #1 pc_current;    
        end      
    end

    PC_Adder PC_Adder (
        .operand1(pc_current),
        .result(result)
    );                

    logic [31:0]    instr;
    Instruction_memory Instr_Mem (
        .addr(pc_current),
        .instr(instr)
    );

    logic           brc;
    logic [31:0]    if_reg;
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            if_reg          <= #1 0;
        end
        else begin
            if_reg          <= #1 instr; 
        end  
    end

    logic           branch,
                    alu_src,
                    regwrite,
                    memread,
                    memwrite,
                    memtoreg;

    logic [1:0]     alu_op;
    controller Ctrl (
        .opcode(if_reg[6:0]),

        .branch(branch),
        .alu_src(alu_src),
        .regwrite(regwrite),
        .memread(memread),
        .memwrite(memwrite),
        .memtoreg(memtoreg),

        .alu_op(alu_op)
    );
    
    logic [4:0]     waddr;
    logic           reg_wr,
                    mem_rd,
                    mem_wr,
                    mr_reg;

    always_ff @(posedge clk) begin
        if (!rst_n) begin    
            waddr           <= #1 0;
            reg_wr          <= #1 0;
            mem_rd          <= #1 0;
            mem_wr          <= #1 0;
            mr_reg          <= #1 0;
        end
        else begin
            waddr           <= #1 if_reg[11:7];
            reg_wr          <= #1 regwrite;
            mem_rd          <= #1 memread;
            mem_wr          <= #1 memwrite;
            mr_reg          <= #1 memtoreg;
        end
    end

    logic [31:0]    wr_data, x1,x2,x3,
                    reg_data1,
                    reg_data2;
    Registers Reg (
        .reg_addr1(if_reg[19:15]),
        .reg_addr2(if_reg[24:20]),
        .wr_addr(waddr),
        .clk(clk),
        .rst_n(rst_n),
        .wr_data(wr_data),
        .reg_data1(reg_data1),
        .reg_data2(reg_data2),
        .wr_en(reg_wr),
        
        .x1(x1),
        .x2(x2),
        .x3(x3)
    );

    logic [31:0]    imm_val;
    imm_gen immgen (
        .instr(if_reg),
        .imm_val(imm_val)
    );

    logic [3:0]     operation; 
    ALU_Ctrl ALUctrl (
        .alu_op(alu_op),
        .funct73({if_reg[30],if_reg[14:12]}),
        .operation(operation)
    );

    //logic [31:0]    fAreg, fBreg;
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
        .operand1(f_pc),
        .operand2(imm_val),
        .result(addresult)
    );

    logic [31:0]    alu_reg,
                    add_reg,
                    wrd_mem;

    logic           zero_reg,
                    bran_reg;               
                    
    always_ff @(posedge clk) begin
        if (!rst_n | brc) begin
            zero_reg        <= #1 0;
            bran_reg        <= #1 0;

            alu_reg         <= #1 0;
            add_reg         <= #1 0;  
            wrd_mem         <= #1 0;
        end
        else begin
            zero_reg        <= #1 zero;
            bran_reg        <= #1 branch;

            alu_reg         <= #1 ALUresult;
            add_reg         <= #1 addresult;  
            wrd_mem         <= #1 reg_data2;  
        end
    end

    assign brc = bran_reg & zero_reg;

    Mux_2x1 Br_MUX (
        .MemtoReg(brc),
        .in1(result),
        .in2(add_reg),
        .out(pc_next)
    );   

    /*
    logic           fA, fB;
    forward_unit inst_fwd_unit (
        .regwr(reg_wr),
        .rs1(if_reg[19:15]),
        .rs2(if_reg[24:20]),
        .rd(waddr),

        .fwd_A(fA),
        .fwd_B(fB)
    );

    Mux_2x1 fMux_A (
        .MemtoReg(fA),
        .in1(reg_data1),
        .in2(wr_data),
        .out(fAreg)
    );

    Mux_2x1 fMux_B (
        .MemtoReg(fB),
        .in1(reg_data2),
        .in2(wr_data),
        .out(fBreg)
    );
    */

    logic [31:0]    read, m0;
    Data_memory Data_Mem (
        .clk(clk), .wr_en(mem_wr), .rd_en(mem_rd),
        .addr(alu_reg), .wr_data(wrd_mem),
        .mem0(m0),
        .rdata(read),
        .rst_n(rst_n)
    );

    Mux_2x1 Reg_MUX (
        .MemtoReg(mr_reg),
        .in1(alu_reg),
        .in2(read),
        .out(wr_data)
    ); 

    SSD Test_Block (
        .clk_i(clk),

        .x1(x1[3:0]),
        .x2(x2[3:0]),
        .x3(x3[3:0]),
        .m0(m0[3:0]),

        .Dspout(Dspout),
        .Segout(Segout)  
    );

endmodule