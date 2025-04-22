module LSU (
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

    // UART-mapped addresses
    localparam UART_TX_ADDR = 32'h10000000;
    localparam UART_RX_ADDR = 32'h10000004;

    always_comb begin
        // Defaults
        uart_tx_en   = 1'b0;
        uart_tx_data = 8'b0;
        rdata        = 32'b0;

        // Default: memory access disabled unless it's not UART
        mem_wr_en    = 1'b0;
        mem_rd_en    = 1'b0;
        mem_addr     = addr;
        mem_wr_data  = wr_data;

        if (rd_en) begin
            if (addr == UART_RX_ADDR) begin
                // Read from UART receiver
                rdata = uart_rx_valid ? {24'b0, uart_rx_data} : 32'hFFFF_FFFF;
            end else begin
                // Normal memory read
                mem_rd_en = 1'b1;
                rdata     = mem_rdata;
            end
        end else if (wr_en) begin
            if (addr == UART_TX_ADDR) begin
                if (uart_tx_ready) begin
                    // Write to UART transmitter
                    uart_tx_en   = 1'b1;
                    uart_tx_data = wr_data[7:0];
                end
                // else: no write allowed; tx not ready
            end else begin
                // Normal memory write
                mem_wr_en = 1'b1;
            end
        end
    end

endmodule
