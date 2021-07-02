module dm_test ();

reg [9:0] addr;
reg [31:0] dataWrite;
wire [31:0] dataRead;
reg en;
reg clk;

dm_1k dm(
    .addr(addr),
    .din(dataWrite),
    .dout(dataRead),
    .WriteEn(en),
    .clk(clk)
);

initial begin
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


end

endmodule