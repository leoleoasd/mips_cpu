`include "defines.v"
`include "alu.v"
`include "alu_src_mux.v"
`include "controller.v"
`include "decoder.v"
`include "dm.v"
`include "extender.v"
`include "gpr.v"
`include "gpr_write_addr_mux.v"
`include "gpr_write_mux.v"
`include "ifu.v"
module mips(
    input clk,
    input rst
);

wire [1:0] npc_sel, alu_sel, gpr_write_addr_sel, gpr_write_data_sel;
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

wire [31:0] alu_src;
wire dm_sel;
ifu ifu(clk, rst, npc_sel, gpr_read_data_1, inst, pc);
decoder decoder(inst,dec_inst,rs,rt,rd,shamt,imm);
controller controller(
    dec_inst, zero,
    reg_write_en,of_write_en,mem_write_en,
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
gpr_write_mux gpr_write_mux(
    alu_out, memory_out, pc,
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
alu alu(
    gpr_read_data_1,
    alu_src,
    alu_out,
    zero,
    overflow,
    ge_than_zero,
    alu_sel
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

endmodule