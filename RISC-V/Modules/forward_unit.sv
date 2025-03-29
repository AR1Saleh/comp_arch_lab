module forward_unit (
    input               regwr,

    input [4:0]         rs1,
                        rs2,
                        rd,           
    
    output logic        fwd_A,
                        fwd_B                    
);

always_comb begin : forward_unit 
    if (regwr & (rd != 0)) begin
        if (rd == rs1) begin
            fwd_A       = 1;     
        end 
        if (rd == rs2) begin
            fwd_B       = 1;     
        end 
    end
    else begin
        fwd_A = 0; fwd_B = 0;
    end
end

endmodule