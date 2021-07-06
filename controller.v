`include "defines.v"

module controller(
    input clk, reset,
    input [5:0] dec_inst, 
    input zero,
    output wire pc_write_en, im_next_en, reg_write_en,reg_of_en,mem_write_en,
    output reg [2:0] alu_sel,
    output reg [1:0] gpr_write_addr_sel,gpr_write_data_sel,
    output reg alu_src_ctl, 
    output reg [1:0] ext_ctl,
    output reg [1:0] npc_sel_out,
    output reg dm_sel,
    output reg halt_sig
);
integer i;
reg [2:0] stage = `STAGE_IF;
reg [1:0] npc_sel;
wire stage_if, stage_decode, stage_exe, stage_mem, stage_wb;

assign stage_if = (stage==`STAGE_IF);
assign stage_decode = (stage==`STAGE_DECODE);
assign stage_exe = (stage==`STAGE_EXE);
assign stage_mem = (stage==`STAGE_MEM);
assign stage_wb = (stage==`STAGE_WB);

reg im_next_en_reg, reg_write_en_reg,reg_of_en_reg,mem_write_en_reg, pc_write_en_reg;

assign pc_write_en = stage_if ||
                     stage_exe && pc_write_en_reg;
assign im_next_en = stage_if;
assign reg_write_en = stage_wb && reg_write_en_reg;
assign reg_of_en = stage_wb && reg_of_en_reg;
assign mem_write_en = stage_mem && mem_write_en_reg;

assign npc_sel_out = stage_if ? `IFU_SEL_NORM : npc_sel;

always@ (*) begin
    reg_write_en_reg = 1;
    reg_of_en_reg = 0;
    mem_write_en_reg = 0;
    alu_sel = `ALU_SEL_ADD;
    gpr_write_addr_sel = `GPR_WRITE_ADDR_RT;
    gpr_write_data_sel = `GPR_WRITE_ALU;
    alu_src_ctl = `ALU_SRC_EXT;
    ext_ctl = `EXT_SEL_SIGN;
    npc_sel = `IFU_SEL_NORM;
    dm_sel = `DM_WORD;
    pc_write_en_reg = 0;
    if(dec_inst == `INST_ADDU) begin
        gpr_write_addr_sel = `GPR_WRITE_ADDR_RD;
        alu_src_ctl = `ALU_SRC_GPR;
    end else if(dec_inst == `INST_SUBU) begin
        alu_sel = `ALU_SEL_SUB;
        gpr_write_addr_sel = `GPR_WRITE_ADDR_RD;
        alu_src_ctl = `ALU_SRC_GPR;
    end else if(dec_inst == `INST_ORI) begin
        alu_sel = `ALU_SEL_OR;
        ext_ctl = `EXT_SEL_ZERO;
    end else if(dec_inst == `INST_LW) begin
        gpr_write_data_sel = `GPR_WRITE_MEM;
    end else if(dec_inst == `INST_SW) begin
        reg_write_en_reg=0;
        mem_write_en_reg=1;
    end else if(dec_inst == `INST_BEQ) begin
        reg_write_en_reg=0;
        alu_sel = `ALU_SEL_SUB;
        alu_src_ctl = `ALU_SRC_GPR;
        npc_sel = `IFU_SEL_RELATIVE;
        if(zero) pc_write_en_reg = 1;
    end else if(dec_inst == `INST_LUI) begin
        ext_ctl = `EXT_SEL_LUI;
    end else if(dec_inst == `INST_J) begin
        reg_write_en_reg=0;
        pc_write_en_reg = 1;
        npc_sel = `IFU_SEL_IRRELATIVE;
    end else if(dec_inst == `INST_ADDI) begin
        reg_of_en_reg=1;
    end else if(dec_inst == `INST_ADDIU) begin
        
    end else if(dec_inst == `INST_SLT) begin
        alu_sel = `ALU_SEL_SLT;
        gpr_write_addr_sel = `GPR_WRITE_ADDR_RD;
        alu_src_ctl = `ALU_SRC_GPR;
    end else if(dec_inst == `INST_JAL) begin
        gpr_write_addr_sel = `GPR_WRITE_ADDR_GPR_RA;
        gpr_write_data_sel = `GPR_WRITE_PC;
        pc_write_en_reg = 1;
        npc_sel = `IFU_SEL_IRRELATIVE;
    end else if(dec_inst == `INST_JR) begin
        reg_write_en_reg=0;
        pc_write_en_reg = 1;
        npc_sel = `IFU_SEL_REGISTER;
    end else if(dec_inst == `INST_HLT) begin
        halt_sig = 1;
    end else if(dec_inst == `INST_SB) begin
        reg_write_en_reg = 0;
        mem_write_en_reg = 1;
        dm_sel = `DM_BYTE;
    end else if(dec_inst == `INST_LB) begin
        gpr_write_data_sel = `GPR_WRITE_MEM;
        dm_sel = `DM_BYTE;
    end else if(dec_inst == `INST_SRAV) begin
        gpr_write_addr_sel = `GPR_WRITE_ADDR_RD;
        alu_src_ctl = `ALU_SRC_RS;
        alu_sel = `ALU_SEL_SAR;
    end else begin
        $display("BAD INSTRUCTION");
        reg_write_en_reg=0;
    end
end

always@(posedge clk or posedge reset)
    if(reset) stage <= `STAGE_IF;
    else begin
        case (stage)
            `STAGE_IF:
                stage <= `STAGE_DECODE;
            `STAGE_DECODE:
                if(dec_inst == `INST_NOP)
                    stage <= `STAGE_IF;
                else
                    stage <= `STAGE_EXE;
            `STAGE_EXE:
                if(
                    dec_inst == `INST_ADDU ||
                    dec_inst == `INST_SUBU ||
                    dec_inst == `INST_ORI ||
                    dec_inst == `INST_LUI ||
                    dec_inst == `INST_ADDI ||
                    dec_inst == `INST_ADDIU ||
                    dec_inst == `INST_SLT ||
                    dec_inst == `INST_JAL ||
                    dec_inst == `INST_SRAV
                )
                    stage <= `STAGE_WB;
                else if (
                    dec_inst == `INST_SW ||
                    dec_inst == `INST_SB ||
                    dec_inst == `INST_LW ||
                    dec_inst == `INST_LB
                )
                    stage <= `STAGE_MEM;
                else
                    stage <= `STAGE_IF;
            `STAGE_MEM:
                if(dec_inst == `INST_LW || dec_inst == `INST_LB)
                    stage <= `STAGE_WB;
                else
                    stage <= `STAGE_IF;
            `STAGE_WB:
                stage <= `STAGE_IF;
            default:
                stage <= `STAGE_IF;
        endcase
    end
endmodule
