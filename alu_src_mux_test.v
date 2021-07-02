`include "defines.v"
`include "alu_src_mux.v"
module alu_src_mux_test;

reg [31:0] GPRData, ExtData;
reg sel;
wire [31:0] out;
alu_src_mux mux(
    GPRData, ExtData,
    sel,
    out
);

initial begin
    GPRData = 'h12345678;
    ExtData = 'h87654321;
    sel = `ALU_SRC_GPR;
    #1;
    assert(out == GPRData);
    sel = `ALU_SRC_EXT;
    #1;
    assert(out == ExtData);
end

endmodule