`include "defines.v"

module gpr(
    input clk,WrEn,OFWrEn,OFFlag,
    input [4:0] RdAddr1,RdAddr2,WrAddr,
    input [31:0] WrData,
    output reg [31:0] RdData1,RdData2
);

reg [31:0] regArr [32];
integer i;

initial begin 
    for(i=0;i<32;i=i+1) regArr[i]=0;
end

always @(*) begin
    if(RdAddr1!=0)RdData1=regArr[RdAddr1];
    else RdData1=0;
    if(RdAddr2!=0)RdData2=regArr[RdAddr2];
    else RdData2=0;
end

always @(posedge clk) begin
    if(WrEn&&WrAddr!=0 && !(OFWrEn && OFFlag)) regArr[WrAddr]<=WrData;
    if(OFWrEn)regArr[30][0]<=OFFlag;
end

endmodule