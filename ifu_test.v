`include "defines.v"
module ifu_test;
reg clk = 0, reset;
reg [1:0] npc_sel;
wire [31:0] insout;
reg [31:0] regpc;
ifu i1(
    .clk(clk),
    .reset(reset),
    .npc_sel(npc_sel),
    .register(regpc),
    .inst(insout),
    .pcWriteEn(1'b1),
    .imNextEn(1'b1)
);

reg [31:0] clk_count;

initial begin
    reset = 0;
    npc_sel = `IFU_SEL_NORM;
    clk_count = 0;
    regpc = 'h3008;
    #5 reset = 1;
    #5 reset = 0;
    $readmemh("ifu_test_code.txt", i1.im.im);

    $display("PC:                   %x", i1.pc);
    $display("Current Insturuction: %x", insout);

    assert(i1.pc == 'h3000);

    #30 clk = 1;
    #30 clk = 0;
    npc_sel = `IFU_SEL_RELATIVE;
    #30 clk = 1;
    #30 clk = 0;
    assert(i1.pc == 'h3008);


    $display("PC:                   %x", i1.pc);
    $display("Current Insturuction: %x", insout);

    npc_sel = `IFU_SEL_RELATIVE;
    #30 clk = 1;
    #30 clk = 0;
    assert(i1.pc == 'h3004);


    $display("PC:                   %x", i1.pc);
    $display("Current Insturuction: %x", insout);

    npc_sel = `IFU_SEL_NORM;
    #30 clk = 1;
    #30 clk = 0;
    assert(i1.pc == 'h3008);
    $display("PC:                   %x", i1.pc);
    $display("Current Insturuction: %x", insout);


    npc_sel = `IFU_SEL_NORM;
    #30 clk = 1;
    #30 clk = 0;
    assert(i1.pc == 'h300c);
    $display("PC:                   %x", i1.pc);
    $display("Current Insturuction: %x", insout);


    npc_sel = `IFU_SEL_NORM;
    #30 clk = 1;
    #30 clk = 0;
    assert(i1.pc == 'h3010);
    $display("PC:                   %x", i1.pc);
    $display("Current Insturuction: %x", insout);


    npc_sel = `IFU_SEL_IRRELATIVE;
    #30 clk = 1;
    #30 clk = 0;
    assert(i1.pc == 'h1234<<2);
    $display("PC:                   %x", i1.pc);
    $display("Current Insturuction: %x", insout);


    npc_sel = `IFU_SEL_REGISTER;
    #30 clk = 1;
    #30 clk = 0;
    assert(i1.pc == 'h3008);
    $display("PC:                   %x", i1.pc);
    $display("Current Insturuction: %x", insout);


    npc_sel = `IFU_SEL_NORM;
    #30 clk = 1;
    #30 clk = 0;
    assert(i1.pc == 'h300c);
    $display("PC:                   %x", i1.pc);
    $display("Current Insturuction: %x", insout);


    npc_sel = `IFU_SEL_NORM;
    #30 clk = 1;
    #30 clk = 0;
    assert(i1.pc == 'h3010);
    $display("PC:                   %x", i1.pc);
    $display("Current Insturuction: %x", insout);


    npc_sel = `IFU_SEL_NORM;
    #30 clk = 1;
    #30 clk = 0;
    assert(i1.pc == 'h3014);
    $display("PC:                   %x", i1.pc);
    $display("Current Insturuction: %x", insout);


    npc_sel = `IFU_SEL_NORM;
    #30 clk = 1;
    #30 clk = 0;
    $finish(0);

end

endmodule