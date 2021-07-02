`include "defines.v"
module alu (
    input [31:0] a,
    input [31:0] b,
    output [31:0] out,
    output zero,
    output overflow,
    output ge_than_zero,
    input [1:0] sel
);

wire [31:0] result[4];
assign result[`ALU_SEL_ADD] = a + b;
assign result[`ALU_SEL_SUB] = a - b;
assign result[`ALU_SEL_OR] = a & b;
assign result[`ALU_SEL_SLT] = int'(a) < int'(b);

assign out = result[sel];
assign zero = out == 0;
assign ge_than_zero = (~out[31]);
assign overflow = (sel == `ALU_SEL_ADD) && (a[31] == b[31] && out[31] != a[31]);

endmodule