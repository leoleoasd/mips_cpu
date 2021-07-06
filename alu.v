`include "defines.v"
module alu (
    input [31:0] a,
    input [31:0] b,
    output [31:0] out,
    output zero,
    output overflow,
    output ge_than_zero,
    input [2:0] sel
);

wire signed [31:0] signed_a;
wire signed [31:0] signed_b;

reg [31:0] sar_result;
reg [31:0] i;

assign signed_a = a;
assign signed_b = b;

wire [31:0] result[5];
assign result[`ALU_SEL_ADD] = a + b;
assign result[`ALU_SEL_SUB] = a - b;
assign result[`ALU_SEL_OR] = a | b;
assign result[`ALU_SEL_SLT] = (a[31] == b[31])? a < b : !b[31];
assign result[`ALU_SEL_SAR] = sar_result;
// assign result[`ALU_SEL_SAR] = signed_b >>> signed_a;

assign out = result[sel];
assign zero = out == 0;
assign ge_than_zero = (~out[31]);
assign overflow = (sel == `ALU_SEL_ADD) && (a[31] == b[31] && out[31] != a[31]);

always@(*) begin
    sar_result = b;
    for(i = 0; i < a[4:0]; i = i + 1)
    begin
        sar_result = {sar_result[31], sar_result[31:1]};
    end
end

endmodule