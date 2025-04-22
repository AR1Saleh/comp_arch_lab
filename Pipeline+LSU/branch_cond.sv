
module branch_cond(
        input [2:0] br_type,
        input [31:0] rdata1,rdata2,
        output logic br_taken
    );
    always_comb begin
        case (br_type)
            3'b000:  if (rdata1 == rdata2) br_taken = 1'b1; //beq
                     else br_taken = 1'b0;
            3'b001:  if (rdata1 != rdata2) br_taken = 1'b1; //bne
                     else br_taken = 1'b0;
            3'b100:  if (rdata1 < rdata2) br_taken = 1'b1; //blt
                     else br_taken = 1'b0;
            3'b101:  if (rdata1 >= rdata2) br_taken = 1'b1; //bge
                     else br_taken = 1'b0;    
            3'b110:  if ($unsigned(rdata1) < $unsigned(rdata2)) br_taken = 1'b1; //bltu
                     else br_taken = 1'b0;
            3'b111:  if ($unsigned(rdata1) >= $unsigned(rdata2)) br_taken = 1'b1; //bgeu
                     else br_taken = 1'b0;    
            3'b011: br_taken = 1'b1; //J-type 
            default: br_taken = 1'b0;                                                                                                                 
        endcase    
    end
endmodule
