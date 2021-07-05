`include "defines.v"
module gpr_test;

reg clk,WrEn,OFWrEn,OFFlag;
reg [4:0] RdAddr1,RdAddr2,WrAddr;
reg [31:0] WrData;
wire [31:0] RdData1,RdData2;

gpr gpr(
    clk,WrEn,OFWrEn,OFFlag, 
    RdAddr1,RdAddr2,WrAddr, WrData, 
    RdData1,RdData2
);
integer i;
initial begin

    // test generic write logic.
    clk = 0;
    WrEn = 1;
    OFWrEn = 0;
    OFFlag = 0;
    for (i = 0; i < 32; i = i + 1)
    begin
        RdAddr1 = i;
        WrData = (i << 3) ^ 32'h12345678; // random data to write.
        RdAddr2 = i - 1;
        WrAddr = i;
        clk = 1;
        #5;
        clk = 0;
        #5;
        $display("i: %d", i);
        $display("write: %x", (i << 3) ^ 32'h12345678);
        $display("RdData1: %x, RdData2: %x", RdData1, RdData2);
        if(i != 0)
        begin
            assert(RdData1 == (i << 3) ^ 32'h12345678);
            assert(RdData2 == (i == 1 ? 0 : (i - 1 << 3) ^ 32'h12345678));
        end
        else
        begin
            // ensures register $0 is not writeable.
            assert(RdData1 == 0);
        end
    end

    // test OverFlow logic.

    // Should write when OFWrEn is true but OverFlowFlag is false.
    OFWrEn = 1;
    OFFlag = 0;
    WrData = 32'h87654321;
    WrAddr = 1;
    RdAddr1 = 1;
    RdAddr2 = 30;
    clk = 1;
    #5;
    clk = 0;
    #5;
    assert(RdData1 == 'h87654321);
    assert(RdData2[0] == OFFlag);

    // Shouldn't write when OverFlowFlag is True.
    OFWrEn = 1;
    OFFlag = 1;
    WrData = 32'h87654321;
    WrAddr = 2;
    RdAddr1 = 2;
    RdAddr2 = 30;
    clk = 1;
    #5;
    clk = 0;
    #5;
    assert(RdData1 != 'h87654321);
    assert(RdData2[0] == OFFlag);
end

endmodule