`include "defines.v"

module controller(
    input [5:0] dec_inst, 
    input zero,
    output reg reg_write_en,reg_of_en,mem_write_en,
    output reg [1:0] alu_sel,
    output reg [1:0] gpr_write_addr_sel,gpr_write_data_sel,
    output reg alu_src_ctl, 
    output reg [1:0] ext_ctl,
    output reg [1:0] npc_sel,
    output reg halt_sig
);
integer i;
always@ (*) begin
    reg_write_en=1;
    reg_of_en=0;
    mem_write_en=0;
    alu_sel=`ALU_SEL_ADD;
    gpr_write_addr_sel=`GPR_WRITE_ADDR_RT;
    gpr_write_data_sel=`GPR_WRITE_ALU;
    alu_src_ctl=`ALU_SRC_EXT;
    ext_ctl=`EXT_SEL_SIGN;
    npc_sel=`IFU_SEL_NORM;
    if(dec_inst == `INST_ADDU) begin
        gpr_write_addr_sel=`GPR_WRITE_ADDR_RD;
        alu_src_ctl=`ALU_SRC_GPR;
    end else if(dec_inst == `INST_SUBU) begin
        alu_sel=`ALU_SEL_SUB;
        gpr_write_addr_sel=`GPR_WRITE_ADDR_RD;
        alu_src_ctl=`ALU_SRC_GPR;
    end else if(dec_inst == `INST_ORI) begin
        alu_sel=`ALU_SEL_OR;
        ext_ctl=`EXT_SEL_ZERO;
    end else if(dec_inst == `INST_LW) begin
        gpr_write_data_sel=`GPR_WRITE_MEM;
    end else if(dec_inst == `INST_SW) begin
        reg_write_en=0;
        mem_write_en=1;
    end else if(dec_inst == `INST_BEQ) begin
        reg_write_en=0;
        alu_sel=`ALU_SEL_SUB;
        alu_src_ctl=`ALU_SRC_GPR;
        if(zero) npc_sel = `IFU_SEL_RELATIVE;
    end else if(dec_inst == `INST_LUI) begin
        ext_ctl=`EXT_SEL_LUI;
    end else if(dec_inst == `INST_J) begin
        reg_write_en=0;
        npc_sel=`IFU_SEL_IRRELATIVE;
    end else if(dec_inst == `INST_ADDI) begin
        reg_of_en=1;
    end else if(dec_inst == `INST_ADDIU) begin
        
    end else if(dec_inst == `INST_SLT) begin
        alu_sel=`ALU_SEL_SLT;
        gpr_write_addr_sel=`GPR_WRITE_ADDR_RD;
        alu_src_ctl=`ALU_SRC_GPR;
    end else if(dec_inst == `INST_JAL) begin
        gpr_write_addr_sel=`GPR_WRITE_ADDR_GPR_RA;
        gpr_write_data_sel=`GPR_WRITE_PC;
        npc_sel=`IFU_SEL_IRRELATIVE;
    end else if(dec_inst == `INST_JR) begin
        reg_write_en=0;
        npc_sel=`IFU_SEL_REGISTER;
    end else if(dec_inst == `INST_HLT) begin
        halt_sig = 1;
    end else begin
        $display("BAD INSTRUCTION");
        reg_write_en=0;
    end
end

endmodule
