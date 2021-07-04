`include "dm.v"
module dm_test;

reg [9:0] addr;
reg [31:0] dataWrite;
wire [31:0] dataRead;
reg en;
reg clk;
reg sel;

dm_1k dm(
    .addr(addr),
    .din(dataWrite),
    .dout(dataRead),
    .WriteEn(en),
    .clk(clk),
    .sel(sel)
);

initial begin
    sel = `DM_WORD;
    clk = 1;
    #10;
    clk = 0;
    #10;

    addr = 0;
    dataWrite = 'h12345678;
    en = 1;
    #10;
    clk = 1;
    #10;
    clk = 0;

    addr = 1;
    en = 0;
    dataWrite = 0;
    
    #10;
    clk = 1;
    #10;
    clk = 0;
    assert(dataRead == 'h123456);
    // ensure little endian
    // also ensures WriteEn.
    // protection against unalised memory read is not implemented.

    sel = `DM_BYTE;
    addr = 0;
    #10;
    assert(dataRead == 'h78);

    en = 1;
    dataWrite = 'h87;
    #10;
    clk = 1;
    #10;
    clk = 0;
    assert(dataRead == 'hffffff87);


end

endmodule