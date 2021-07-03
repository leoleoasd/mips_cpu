`include "defines.v"

module gpr_write_addr_mux(
    input [1:0] sel,
    input [4:0] rt,rd,
    output reg [4:0] out
);

wire [4:0] options[4];
assign options[`GPR_WRITE_ADDR_RD] = rd;
assign options[`GPR_WRITE_ADDR_RT] = rt;
assign options[`GPR_WRITE_ADDR_GPR_RA] = 31;
assign out = options[sel];

endmodule
