`include "defines.v"
module dm_1k(
    input [9:0] addr,
    input [31:0] din,
    input WriteEn,
    input clk,
    input sel,
    output [31:0] dout
);
reg [7:0] dm[1023:0];
wire [31:0] options[2];

assign options[`DM_WORD] = {dm[addr + 3], dm[addr + 2], dm[addr + 1], dm[addr]};
assign options[`DM_BYTE] = {{24{dm[addr][7]}}, dm[addr]};
assign dout = options[sel];

integer i;
initial begin 
    for(i=0;i<1024;i=i+1)
        dm[i]=0;
end

always@(posedge clk)
begin
    if (WriteEn)
    begin
        case(sel)
        `DM_WORD: begin
            $display("ADDR: %x", addr);
            if(addr[1:0] != 0)
            begin
                $display("Unaligned adderess in store word: %x", addr);
                $fatal(1);
            end
            else
                {dm[addr + 3], dm[addr + 2], dm[addr + 1], dm[addr]} <= din;
        end
        `DM_BYTE: dm[addr] <= din[7:0];
        endcase
    end
end

endmodule