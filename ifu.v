`include "defines.v"
module ifu(
    input clk,
    input reset,
    input [1:0] npc_sel,
    input [31:0] npc,
    output [31:0] inst
);
reg [31:0]pc;
wire [9:0] im_addr;
assign im_addr = pc[9:0];
im_1k im(
    .addr(im_addr),
    .dout(inst)
);

always @(posedge clk, posedge reset)
begin
    if (reset) pc = 32'h3000;
    else
    begin
        case (npc_sel)
            `IFU_SEL_NORM: pc <= pc + 4;
            `IFU_SEL_RELATIVE: pc <= pc + 4 + ({ {16{inst[15]}}, inst[15:0] }<<2);
            `IFU_SEL_IRRELATIVE: pc <= {pc[31:29], inst[25:0], 2'b0};
            `IFU_SEL_REGISTER: pc <= npc;
            default: ;
        endcase
    end
end
endmodule