`include "defines.v"
`include "im_1k.v"
`include "npc.v"
module ifu(
    input clk,
    input reset,
    input [1:0] npc_sel,
    input [31:0] register,
    output [31:0] inst,
    output reg [31:0] pc
);

wire [9:0] im_addr;
assign im_addr = pc[9:0];
im_1k im(
    .addr(im_addr),
    .dout(inst)
);

wire [31:0] nextPC;
npc npc(
    pc, inst[15:0], inst[25:0], register, npc_sel, nextPC
);

always @(posedge clk, posedge reset)
begin
    if (reset) pc <= 32'h3000;
    else
    begin
        pc <= nextPC;
    end
end
endmodule