`include "defines.v"
module alu_test;

reg signed [31:0] a;
reg signed [31:0] b;
wire [31:0] out;
reg [1:0] sel;
wire zero, ge_than_zero;
wire overflow;
alu alu(
    .a(a),
    .b(b),
    .out(out),
    .sel(sel),
    .zero(zero),
    .ge_than_zero(ge_than_zero),
    .overflow(overflow)
);

initial begin
    a = 1;
    b = 1;
    sel = `ALU_SEL_ADD;
    #1
    assert(out == 2);
    assert(zero == 0);
    assert(overflow == 0);
    assert(ge_than_zero == 1);


    a = 'h7fffffff;
    b = 1;
    sel = `ALU_SEL_ADD;
    #1
    assert(out == 'h80000000);
    assert(zero == 0);
    assert(overflow == 1);
    assert(ge_than_zero == 0);

    a = 1;
    b = 'h7fffffff;
    sel = `ALU_SEL_ADD;
    #1
    assert(out == 'h80000000);
    assert(zero == 0);
    assert(overflow == 1);
    assert(ge_than_zero == 0);

    a = 123;
    b = 123;
    sel = `ALU_SEL_SUB;
    #1
    assert(out == 0);
    assert(zero == 1);
    assert(overflow == 0);
    assert(ge_than_zero == 1);

    a = 123;
    b = 234;
    sel = `ALU_SEL_SUB;
    #1
    assert(out == 123 - 234);
    assert(zero == 0);
    assert(overflow == 0);
    assert(ge_than_zero == 0);

    a = 0;
    b = 'h7fffffff;
    sel = `ALU_SEL_SUB;
    #1
    assert(out == -'h7fffffff);
    assert(zero == 0);
    assert(overflow == 0);
    assert(ge_than_zero == 0);

    a = 0;
    b = 'h80000000;
    sel = `ALU_SEL_SUB;
    #1
    assert(out == -'h80000000);
    assert(zero == 0);
    assert(overflow == 0);
    assert(ge_than_zero == 0);


    a = -1;
    b = 'h7fffffff;
    sel = `ALU_SEL_SUB;
    #1
    assert(out == -'h80000000);
    assert(zero == 0);
    assert(overflow == 0);
    assert(ge_than_zero == 0);


    a = -2;
    b = 'h7fffffff;
    sel = `ALU_SEL_SUB;
    #1
    $display("%x", a);
    $display("%x", out);
    $display("%x", 32'(-2 - 'h7fffffff));
    assert(out == 32'(-2 - 'h7fffffff));
    assert(zero == 0);
    assert(overflow == 0);
    assert(ge_than_zero == 1);

    a = 'h98765432;
    b = 'habcdef12;
    sel = `ALU_SEL_OR;
    #1
    assert(out == 'h98765432 | 'habcdef12);
    assert(zero == 0);
    assert(overflow == 0);
    assert(ge_than_zero == 0);

    a = 1;
    b = 2;
    sel = `ALU_SEL_SLT;
    #1
    assert(out == 1);
    assert(zero == 0);
    assert(overflow == 0);
    assert(ge_than_zero == 1);

    a = 2;
    b = 2;
    sel = `ALU_SEL_SLT;
    #1
    assert(out == 0);
    assert(zero == 1);
    assert(overflow == 0);
    assert(ge_than_zero == 1);

    a = 3;
    b = 2;
    sel = `ALU_SEL_SLT;
    #1
    assert(out == 0);
    assert(zero == 1);
    assert(overflow == 0);
    assert(ge_than_zero == 1);

end

endmodule