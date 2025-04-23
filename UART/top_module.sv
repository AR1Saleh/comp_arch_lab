//top module for uart

module top_module (
	input logic clk, rst

);
	//instantiating sub modules
	
	logic wr_en,busy,data_valid,baud_tick,f_e,b_e;
	logic rd_en;
	logic [7:0] data,lsu_data,rx_data,to_lsu_data;

    baud_gen baud(
        .clk(clk),
        .rst(rst),
        .tick(baud_tick)
    );
	
	rx_shift_register rx_shift (
		.clk(clk),
		.rst_n(rst),
		.baud_tick(baud_tick),
		.sr_in(),
		.data(rx_data),
		.data_valid(),
		.frame_error(),
		.break_error(),
		.break_valid()
	);

	rx_fifo r_fifo (
		.clk(clk),
		.rst_n(rst),
		.data_in(rx_data),
		.frame_error_in(f_e),
		.break_error_in(b_e),
		.wr_en(),
		.rd_en(rd_en),
		.data_out(to_lsu_data),
		.frame_error_out(),
		.break_error_out(),
		.empty(),
		.full(),
		.data_valid()
	);


	tx_fifo t_fifo (
		.clk(clk),
		.rst_n(rst),
		.buff_in(lsu_data),
		.wr_en(wr_en),
		.full(),
		.tx_busy(busy),
		.buff_out(data),
		.empty(),
		.data_valid(data_valid)
	);

	tx_shift_register tx_shift (
		.clk(clk),
		.baud_tick(baud_tick),
		.rst(rst),
		.data_valid(data_valid),
		.data(data),
		.busy(busy)	
	);


endmodule
