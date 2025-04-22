
module top(
        input clk,rst_n,rst_n_pc,   
        input  logic        uart_rx_valid,
        input  logic [7:0]  uart_rx_data,
        input  logic        uart_tx_ready,     
        output logic        uart_tx_en,
        output logic [7:0]  uart_tx_data
    );
    logic reg_wr_en;//regfile
    logic [31:0] reg_wr_data;//regfile
    logic [31:0] reg_data1,reg_data2; //regfile
    logic [31:0] pc_current;//pc
    logic [31:0] instr;//instr_mem
    logic [31:0] imm_val;//imm_gen
    logic [31:0] mux_out_B;//mux
    logic [31:0] alu_out;//alu
    logic [31:0] rdata;//data_mem
    logic sel_A;
    logic sel_B;
    logic [1:0] wb_sel;
    logic data_mem_wr_en;
    logic data_mem_rd_en;
    logic [3:0] alu_op;
    logic br_taken;
    logic [2:0] br_type;
    logic [31:0] mux_out_pc;
    logic [31:0] out_plus4;
    logic [31:0] mux_out_A;
    logic [31:0] out_plus4_wb;
    
    logic [31:0] pc_current1;
    logic [31:0] pc_current2;
    logic [31:0] instr1;
    logic [31:0] instr2;
    logic [31:0] alu_out1;
    logic [31:0] reg_data2_1;
    logic reg_wr_en1;
    logic [1:0] wb_sel1;
    logic data_mem_wr_en1;
    logic data_mem_rd_en1;
    
    //logic uart_rx_valid;
    //logic [7:0] uart_rx_data;
    //logic uart_tx_ready;
    //logic uart_tx_en;
    //logic [7:0] uart_tx_data;
    logic mem_wr_en;
    logic mem_rd_en;
    logic [31:0] mem_addr;
    logic [31:0] mem_wr_data;
    logic [31:0] mem_rdata;
    
    
    regfile regfile(.clk(clk),.rst_n(rst_n),.wr_en(reg_wr_en1),.reg_addr1(instr1[19:15]),.reg_addr2(instr1[24:20]),.wr_addr(instr2[11:7]),.wr_data(reg_wr_data),.reg_data1(reg_data1),.reg_data2(reg_data2));
    pc pc(.pc_next(mux_out_pc),.pc_current(pc_current),.clk(clk),.rst_n(rst_n_pc));
    instr_mem instr_mem(.addr(pc_current),.instr(instr));
    imm_gen imm_gen(.instr(instr1),.imm_val(imm_val));
    mux mux_B(.in1(reg_data2),.in2(imm_val),.sel(sel_B),.mux_out(mux_out_B));
    alu alu(.alu_op(alu_op),.data1(mux_out_A),.data2(mux_out_B),.alu_out(alu_out));
    
    data_mem data_mem(.clk(clk),.wr_en(mem_wr_en),.rd_en(mem_rd_en),.rst_n(rst_n),.addr(mem_addr),.wr_data(mem_wr_data),.rdata(mem_rdata));
    LSU LSU(.rd_en(data_mem_rd_en1),.wr_en(data_mem_wr_en1),.addr(alu_out1),.wr_data(reg_data2_1),.uart_rx_valid(uart_rx_valid),.uart_rx_data(uart_rx_data),.uart_tx_ready(uart_tx_ready),.rdata(rdata),.uart_tx_en(uart_tx_en),.uart_tx_data(uart_tx_data),.mem_rdata(mem_rdata),.mem_wr_en(mem_wr_en),.mem_rd_en(mem_rd_en),.mem_addr(mem_addr),.mem_wr_data(mem_wr_data));
    
    controller controller(.instr(instr1),.sel_B(sel_B),.reg_wr_en(reg_wr_en),.data_mem_wr_en(data_mem_wr_en),.data_mem_rd_en(data_mem_rd_en),.alu_op(alu_op),.wb_sel(wb_sel),.br_type(br_type),.sel_A(sel_A));
    mux_wb mux_wb(.in1(alu_out1),.in2(rdata),.in3(out_plus4_wb),.sel(wb_sel1),.mux_out(reg_wr_data));
    mux mux_pc(.sel(br_taken),.in1(out_plus4),.in2(alu_out),.mux_out(mux_out_pc));
    mux mux_A(.sel(sel_A),.in1(reg_data1),.in2(pc_current1),.mux_out(mux_out_A));
    plus4 plus4(.in(pc_current),.out(out_plus4));
    plus4 plus4_wb(.in(pc_current2),.out(out_plus4_wb));
    branch_cond branch_cond(.br_type(br_type),.br_taken(br_taken),.rdata1(reg_data1),.rdata2(reg_data2));
    
    
    d_ff pc_dff1(.rst(rst_n),.clk(clk),.in(pc_current),.out(pc_current1));
    d_ff pc_dff2(.rst(rst_n),.clk(clk),.in(pc_current1),.out(pc_current2));
    IR_dff instr_dff1(.rst(rst_n),.clk(clk),.in(instr),.out(instr1),.br_taken(br_taken));
    //d_ff instr_dff1(.rst(rst_n),.clk(clk),.in(instr),.out(instr1));
    d_ff instr_dff2(.rst(rst_n),.clk(clk),.in(instr1),.out(instr2));
    d_ff alu_dff(.rst(rst_n),.clk(clk),.in(alu_out),.out(alu_out1));
    d_ff wr_data_dff(.rst(rst_n),.clk(clk),.in(reg_data2),.out(reg_data2_1));
    
    controller_d_ff data_mem_rd_en_dff(.rst(rst_n),.clk(clk),.in(data_mem_rd_en),.out(data_mem_rd_en1));
    controller_d_ff data_mem_wr_en_dff(.rst(rst_n),.clk(clk),.in(data_mem_wr_en),.out(data_mem_wr_en1));
    controller_d_ff reg_wr_en_dff(.rst(rst_n),.clk(clk),.in(reg_wr_en),.out(reg_wr_en1));
    wb_sel_dff wb_sel_dff(.rst(rst_n),.clk(clk),.in(wb_sel),.out(wb_sel1));
    
endmodule

/*
module top(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        rd_en,         // Comes from controller
    input  logic        wr_en,         // Comes from controller
    input  logic [31:0] addr,
    input  logic [31:0] wr_data,
    input  logic        uart_rx_valid,
    input  logic [7:0]  uart_rx_data,
    input  logic        uart_tx_ready,
    output logic [31:0] rdata,
    output logic        uart_tx_en,
    output logic [7:0]  uart_tx_data,
    output logic        mem_wr_en,
    output logic        mem_rd_en,
    output logic [31:0] mem_addr,
    output logic [31:0] mem_wr_data,
    input  logic [31:0] mem_rdata
    );
    
data_mem mem (
        .clk(clk),
        .wr_en(mem_wr_en),
        .rd_en(mem_rd_en),
        .rst_n(rst_n),
        .addr(mem_addr),
        .wr_data(mem_wr_data),
        .rdata(mem_rdata)
    );
    
LSU LSU(
        .clk(clk),
        .rst_n(rst_n),
        .rd_en(rd_en),         
        .wr_en(wr_en),         
        .addr(addr),
        .wr_data(wr_data),
        .uart_rx_valid(uart_rx_valid),
        .uart_rx_data(uart_rx_data),
        .uart_tx_ready(uart_tx_ready),
        .rdata(rdata),
        .uart_tx_en(uart_tx_en),
        .uart_tx_data(uart_tx_data),
        .mem_wr_en(mem_wr_en),
        .mem_rd_en(mem_rd_en),
        .mem_addr(mem_addr),
        .mem_wr_data(mem_wr_data),
        .mem_rdata(mem_rdata)
 );
    
endmodule
*/