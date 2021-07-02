`include "defines.v"

module Decoder(
    input [31:0] inst,
    output reg [5:0] dec_inst,
    output wire [4:0] rs,rt,rd,shamt,
    output wire [15:0] imm
);

wire [5:0] opcode,funct;
assign opcode=inst[31:26];
assign funct=inst[5:0];
assign rs=inst[25:21];
assign rt=inst[20:16];
assign rd=inst[15:11];
assign shamt=inst[10:6];
assign imm=inst[15:0];

always@ (*) begin
    case(opcode)
        `OPCODE_SPECIAL: begin
            case(funct)
                `FUNCT_ADDU: dec_inst=(shamt==0)?(`INST_ADDU):(`INST_NOP);
                `FUNCT_SUBU: dec_inst=(shamt==0)?(`INST_SUBU):(`INST_NOP);
                `FUNCT_SLT: dec_inst=(shamt==0)?(`INST_SLT):(`INST_NOP);
                `FUNCT_JR: dec_inst=(rt==0&&rd==0)?(`INST_JR):(`INST_NOP);
                default: dec_inst=`INST_NOP;
            endcase
        end
        `OPCODE_ORI: dec_inst=`INST_ORI;
        `OPCODE_LW: dec_inst=`INST_LW;
        `OPCODE_SW: dec_inst=`INST_SW;
        `OPCODE_BEQ: dec_inst=`INST_BEQ;
        `OPCODE_LUI: dec_inst=(rs==0)?(`INST_LUI):(`INST_NOP);
        `OPCODE_J: dec_inst=`INST_J;
        `OPCODE_ADDI: dec_inst=`INST_ADDI;
        `OPCODE_ADDIU: dec_inst=`INST_ADDIU;
        `OPCODE_JAL: dec_inst=`INST_JAL;
        `OPCODE_HLT: dec_inst=`INST_HLT;
        default: dec_inst=`INST_NOP;
    endcase
end

endmodule
