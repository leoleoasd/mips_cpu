`include "defines.v"

module decoder(
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
            //$display("instruction: %b %b %b %b %b %b", opcode, rs, rt,rd, shamt, funct);
            case(funct)
                `FUNCT_ADDU: begin
                    dec_inst<=(shamt==0)?(`INST_ADDU):(`INST_NOP);
                    //$display("Got instruction: addu $%d $%d $%d", rd, rs, rt);
                end
                `FUNCT_SUBU: begin
                    dec_inst<=(shamt==0)?(`INST_SUBU):(`INST_NOP);
                    //$display("Got instruction: subu $%d $%d $%d", rd, rs, rt);
                end
                `FUNCT_SLT: begin
                    dec_inst<=(shamt==0)?(`INST_SLT):(`INST_NOP);
                    //$display("Got instruction: slt $%d $%d $%d", rd, rs, rt);
                end
                `FUNCT_JR: begin
                    dec_inst<=(rt==0&&rd==0)?(`INST_JR):(`INST_NOP);
                    //$display("Got instruction: jr $%d", rs);
                end
                default:begin
                     dec_inst<=`INST_NOP;
                end
            endcase
        end
        `OPCODE_ORI: begin
            dec_inst<=`INST_ORI;
            //$display("Got instruction: ori $%d $%d %x", rt, rs,imm);
        end
        `OPCODE_LW: begin
            dec_inst<=`INST_LW;
            //$display("Got instruction: lw $%d, %d($%d)", rt, imm, rs);
        end
        `OPCODE_SW: begin
            dec_inst<=`INST_SW;
            //$display("Got instruction: sw $%d, %d($%d)", rt, imm, rs);
        end
        `OPCODE_BEQ: begin
            dec_inst<=`INST_BEQ;
            //$display("Got instruction: beq $%d $%d %d", rt, rs,imm);
        end
        `OPCODE_LUI: begin
            dec_inst<=(rs==0)?(`INST_LUI):(`INST_NOP);
            //$display("Got instruction: lui $%d $%d %x", rt, rs,imm);
        end
        `OPCODE_J: begin
            dec_inst<=`INST_J;
            //$display("Got instruction: j %x", inst[25:0] << 2);
        end
        `OPCODE_ADDI: begin
            dec_inst<=`INST_ADDI;
            //$display("Got instruction: addi $%d $%d %x", rt, rs,imm);
        end
        `OPCODE_ADDIU: begin
            dec_inst<=`INST_ADDIU;
            //$display("Got instruction: addiu $%d $%d %x", rt, rs,imm);
        end
        `OPCODE_JAL: begin
            dec_inst<=`INST_JAL;
            //$display("Got instruction: jal %x", inst[25:0] << 2);
        end
        `OPCODE_HLT: begin
            dec_inst<=`INST_HLT;
            //$display("Got instruction: HALT");
        end
        default: begin
            dec_inst<=`INST_NOP;
        end
    endcase
end

endmodule
