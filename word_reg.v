`include "defines.v"

module word_reg(
    input clk,
    input [31:0] in,
    output reg[31:0] out
);

always@ (posedge clk) begin
    out<=in;
end

endmodule
