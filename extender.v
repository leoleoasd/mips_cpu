`include "defines.v"
module extender(
    input [15:0] in,
    input [1:0] sel,
    output [31:0] out
);
wire [31:0] result[3:0];
assign result[`EXT_SEL_ZERO] = {16'b0, in};
assign result[`EXT_SEL_SIGN] = {{16{in[15]}}, in};
assign result[`EXT_SEL_LUI] = {in, 16'b0};
assign result[`EXT_SEL_RESERVED] = 0;
assign out = result[sel];
endmodule
