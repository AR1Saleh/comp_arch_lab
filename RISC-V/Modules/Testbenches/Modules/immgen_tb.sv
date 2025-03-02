module imm_gen_tb;
    logic [31:0]    instr,
                    imm_val;

    initial begin
        imm_gen_test;
    end

    task automatic imm_gen_test;
        #50 instr      = ;
        #50 instr      = ;   
        #50 instr      = ;
        #50 instr      = ;
        #50 instr      = ;
        #50 instr      = ;
        #50 instr      = ; 
    endtask

    imm_gen dut(.*);

endmodule