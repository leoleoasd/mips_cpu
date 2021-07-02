`include "defines.v"
`include "gpr_write_mux.v"
module gpr_write_mux_test;

reg [31:0] alu, memory, pc;
reg [1:0] sel;
wire [31:0] out;
gpr_write_mux mux(
    alu, memory, pc,
    sel,
    out
);

initial begin
    // magic numbers for test
    alu = 'hc0ffee;      // coffee
    memory = 'hbaadc0de; // bad code
    pc = 'hdeadbeef;     // dead beef
    sel = `GPR_WRITE_ALU;
    #1;
    assert(out == alu);
    sel = `GPR_WRITE_MEM;
    #1;
    assert(out == memory);
    sel = `GPR_WRITE_PC;
    #1;
    assert(out == pc);
end

endmodule