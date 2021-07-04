`include "defines.v"

module alu_src_mux(
    input [31:0] GPRData, ExtData,
    input sel,
    output [31:0] out
);
wire [31:0] options[1:0];
assign options[`ALU_SRC_GPR] = GPRData;
assign options[`ALU_SRC_EXT] = ExtData;
assign out = options[sel];

endmodule