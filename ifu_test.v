`include "defines.v"
module ifu_test;
reg clk, reset;
reg [1:0] npc_sel;
wire [31:0] insout;
reg [31:0] regpc;
ifu i1(
    .clk(clk),
    .reset(reset),
    .npc_sel(npc_sel),
    .npc(regpc),
    .inst(insout)
);

reg [31:0] clk_count;

initial begin
    clk = 1;
    reset = 0;
    npc_sel = `IFU_SEL_NORM;
    clk_count = 0;
    regpc = 'h3008;
    #5 reset = 1;
    #5 reset = 0;
    $readmemh("ifu_test_code.txt", i1.im.im);
end
always begin
    #30 clk = ~clk;
    if (clk == 1)
    begin
        $display("Clk                   %x", clk_count);
        $display("PC:                   %x", i1.pc);
        $display("Current Insturuction: %x", insout);
        case (clk_count)
            0:
            begin
                npc_sel = `IFU_SEL_RELATIVE;
                assert(i1.pc == 'h3001);
            end
            1:
            begin
                npc_sel = `IFU_SEL_IRRELATIVE;
                assert(i1.pc == 'h3008);
            end
            2:
            begin
                npc_sel = `IFU_SEL_REGISTER;
                assert(i1.pc == 'h1234<<2);
            end
            3:
            begin
                npc_sel = `IFU_SEL_NORM;
                assert(i1.pc == 'h3008);
            end
            4:
            begin
                npc_sel = `IFU_SEL_NORM;
                assert(i1.pc == 'h300c);
            end
            5:
            begin
                npc_sel = `IFU_SEL_NORM;
                assert(i1.pc == 'h3010);
            end
            6:
            begin
                npc_sel = `IFU_SEL_NORM;
                assert(i1.pc == 'h3014);
                $finish(0);
            end
            default: ;
        endcase
        clk_count = clk_count + 1;
    end
end

endmodule