`include "defines.v"

module gpr_write_mux (
    input [31:0] alu, memory, pc,
    input [1:0] sel,
    output [31:0] out
);
wire [31:0] options[4];
assign options[`GPR_WRITE_ALU] = alu;
assign options[`GPR_WRITE_MEM] = memory;
assign options[`GPR_WRITE_PC] = pc;
assign options[`GPR_WRITE_RESERVED] = 0;
assign out = options[sel];
endmodule