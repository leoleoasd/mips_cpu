`include "defines.v"

module npc(
    input [31:0] pc,
    input [15:0] offset,
    input [25:0] irrelative,
    input [31:0] register,
    input [1:0] npc_sel,
    output [31:0] npc
);
wire [31:0] options[4];
assign options[`IFU_SEL_NORM] = pc + 4;
assign options[`IFU_SEL_RELATIVE] = pc + ({ {16{offset[15]}}, offset }<<2);
assign options[`IFU_SEL_IRRELATIVE] = {pc[31:29], irrelative, 2'b0};
assign options[`IFU_SEL_REGISTER] = register;

assign npc = options[npc_sel];
endmodule
