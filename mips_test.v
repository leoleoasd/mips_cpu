`include "mips.v"
module mips_test;

reg clk, reset;
mips mips(
    clk, reset
);
reg [31:0] clk_count;

initial begin
    clk = 1;
    reset = 0;
    clk_count = 0;
    #5 reset = 1;
    #5 reset = 0;
    $readmemh("code1.txt", mips.ifu.im.im);
end
integer i;
always begin
    #30;
    clk = 1;
    #30;

    $display("Clk                   %x", clk_count);
    $display("PC:                   %x", mips.pc);
    $display("Current Insturuction: %x", mips.ifu.inst);
    clk_count = clk_count + 1;
    case(mips.decoder.opcode)
        `OPCODE_SPECIAL: begin
            $display("instruction: %b %b %b %b %b %b", mips.decoder.opcode, mips.decoder.rs, mips.decoder.rt,mips.decoder.rd, mips.decoder.shamt, mips.decoder.funct);
            case(mips.decoder.funct)
                `FUNCT_ADDU: begin
                    $display("Got instruction: addu $%d $%d $%d", mips.decoder.rd, mips.decoder.rs, mips.decoder.rt);
                end
                `FUNCT_SUBU: begin
                    $display("Got instruction: subu $%d $%d $%d", mips.decoder.rd, mips.decoder.rs, mips.decoder.rt);
                end
                `FUNCT_SLT: begin
                    $display("Got instruction: slt $%d $%d $%d", mips.decoder.rd, mips.decoder.rs, mips.decoder.rt);
                end
                `FUNCT_JR: begin
                    $display("Got instruction: jr $%d", mips.decoder.rs);
                end
                default:begin
                end
            endcase
        end
        `OPCODE_ORI: begin
            $display("Got instruction: ori $%d $%d %x", mips.decoder.rt, mips.decoder.rs,mips.decoder.imm);
        end
        `OPCODE_LW: begin
            $display("Got instruction: lw $%d, %d($%d)", mips.decoder.rt, mips.decoder.imm, mips.decoder.rs);
        end
        `OPCODE_SW: begin
            $display("Got instruction: sw $%d, %d($%d)", mips.decoder.rt, mips.decoder.imm, mips.decoder.rs);
        end
        `OPCODE_BEQ: begin
            $display("Got instruction: beq $%d $%d %d", mips.decoder.rt, mips.decoder.rs,mips.decoder.imm);
        end
        `OPCODE_LUI: begin
            $display("Got instruction: lui $%d $%d %x", mips.decoder.rt, mips.decoder.rs,mips.decoder.imm);
        end
        `OPCODE_J: begin
            $display("Got instruction: j %x", mips.decoder.inst[25:0] << 2);
        end
        `OPCODE_ADDI: begin
            $display("Got instruction: addi $%d $%d %x", mips.decoder.rt, mips.decoder.rs,mips.decoder.imm);
        end
        `OPCODE_ADDIU: begin
            $display("Got instruction: addiu $%d $%d %x", mips.decoder.rt, mips.decoder.rs,mips.decoder.imm);
        end
        `OPCODE_JAL: begin
            $display("Got instruction: jal %x", mips.decoder.inst[25:0] << 2);
        end
        `OPCODE_LB: begin
            $display("Got instruction: lb $%d, %d($%d)", mips.decoder.rt, mips.decoder.imm, mips.decoder.rs);
        end
        `OPCODE_SB: begin
            $display("Got instruction: sb $%d, %d($%d)", mips.decoder.rt, mips.decoder.imm, mips.decoder.rs);
        end
        `OPCODE_HLT: begin
            $display("Got instruction: HALT");
        end
        default: begin
        end
    endcase

    clk = 0;
    for(i = 0; i < 32; ++ i)
    begin
        $display("Register $%d: %x", i, mips.gpr.regs[i]);
    end
    $display("GPR Write En: %d", mips.reg_write_en);
    $display("GPR Write Addr: %d", mips.gpr_write_addr);
    $display("GPR Write Data: %d", mips.write_data);
    $display("GPR Write Data: %x", mips.write_data);
    $display("npc_sel: %d", mips.npc_sel);

    // if (mips.npc_sel != 0) begin
    //     $stop;
    // end
end
always @(posedge mips.halt_sig) begin
    $display("FINISH");
    for(i = 0; i < 32; ++ i)
    begin
        $display("Register $%d: %x", i, mips.gpr.regs[i]);
    end
    $finish();
end
endmodule