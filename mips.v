`include "defines.v"
module mips(
    input clk,
    input rst
);

wire [1:0] npc_sel, gpr_write_addr_sel, gpr_write_data_sel;
wire [2:0] alu_sel;
wire [31:0] inst, pc;
wire [5:0] dec_inst;
wire [4:0] rs,rt,rd,shamt;
wire [15:0] imm;
wire zero;
wire reg_write_en,mem_write_en;
wire alu_src_ctl;
wire [1:0] ext_ctl;
wire [4:0] gpr_write_addr;
wire [31:0] write_data,gpr_read_data_1,gpr_read_data_2;
wire overflow;
wire [31:0] alu_out, memory_out, ext_out;
wire [9:0] dm_addr;
assign dm_addr = alu_out[9:0];
wire halt_sig;
wire pc_write_en, im_next_en, of_write_en;
wire [31:0] memory_out_reg;

wire ge_than_zero; // not used

wire [31:0] alu_src;
wire dm_sel;
ifu ifu(clk, rst, npc_sel, gpr_read_data_1,pc_write_en, im_next_en, inst, pc);
decoder decoder(inst,dec_inst,rs,rt,rd,shamt,imm);
controller controller(
    clk, rst,
    dec_inst, zero,
    pc_write_en, im_next_en, reg_write_en,of_write_en,mem_write_en,
    alu_sel,
    gpr_write_addr_sel,gpr_write_data_sel,
    alu_src_ctl, ext_ctl,
    npc_sel,
    dm_sel,
    halt_sig
);
gpr gpr(
    clk,reg_write_en,of_write_en,overflow,
    rs,rt,gpr_write_addr,
    write_data,
    gpr_read_data_1,gpr_read_data_2
);

wire [31:0] gpr_source_pc;
word_reg gpr_source_pc_reg(
    .in(pc),
    .out(gpr_source_pc),
    .clk(clk)
);

gpr_write_mux gpr_write_mux(
    alu_out, memory_out_reg, gpr_source_pc,
    gpr_write_data_sel,
    write_data
);
gpr_write_addr_mux gpr_write_addr_mux(
    gpr_write_addr_sel,
    rt,rd,
    gpr_write_addr
);
extender extender(
    imm,
    ext_ctl,
    ext_out
);
wire [31:0] alu_a, alu_b;
word_reg alu_a_reg(
    .in(gpr_read_data_1),
    .out(alu_a),
    .clk(clk)
);
word_reg alu_b_reg(
    .in(alu_src),
    .out(alu_b),
    .clk(clk)
);
wire [31:0] alu_c;
alu alu(
    alu_a,
    alu_b,
    alu_c,
    zero,
    overflow,
    ge_than_zero,
    alu_sel
);
word_reg alu_c_reg(
    .in(alu_c),
    .out(alu_out),
    .clk(clk)
);
alu_src_mux alu_src_mux(
    gpr_read_data_2, ext_out,
    alu_src_ctl,
    alu_src
);
dm_1k dm(
    dm_addr,
    gpr_read_data_2,
    mem_write_en,
    clk,
    dm_sel,
    memory_out
);
word_reg mem_out_reg(
    .in(memory_out),
    .out(memory_out_reg),
    .clk(clk)
);

endmodule