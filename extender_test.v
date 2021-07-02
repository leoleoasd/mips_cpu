`include "defines.v"
`include "extender.v"
module extender_test;

reg [15:0] in;
wire [31:0] out;
reg [1:0] sel;

extender extender(
    in, sel, out
);

initial begin
    in = 'h1234;
    sel = `EXT_SEL_ZERO;
    #1;
    assert(out == 32'h1234);
    $display("in: %x, out: %x", in, out);


    in = 'h1234;
    sel = `EXT_SEL_SIGN;
    #1;
    assert(out == 32'h1234);
    $display("in: %x, out: %x", in, out);

    in = 'hf234;
    sel = `EXT_SEL_SIGN;
    #1;
    assert(out == 32'hfffff234);
    $display("in: %x, out: %x", in, out);

    in = 'hf234;
    sel = `EXT_SEL_LUI;
    #1;
    assert(out == 32'hf2340000);
    $display("in: %x, out: %x", in, out);
end

endmodule;