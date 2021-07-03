`include "defines.v"

module gpr(
    input clk,write_en,of_write_en,overflow,
    input [4:0] read_addr_1,read_addr_2,write_addr,
    input [31:0] write_data,
    output reg [31:0] read_data_1,read_data_2
);

reg [31:0] regs [32];
integer i;

initial begin 
    for(i=0;i<32;i=i+1) regs[i]=0;
end

always@(*) begin
    if(read_addr_1!=0)read_data_1<=regs[read_addr_1];
    else read_data_1<=0;
    if(read_addr_2!=0)read_data_2<=regs[read_addr_2];
    else read_data_2<=0;
end

always@(posedge clk) begin
    // $display("GPR Got clk!");
    if(write_en&&write_addr!=0 && !(of_write_en && overflow))
    begin
        // $display("Writing %x to $%d", write_data, write_addr);
        regs[write_addr]<=write_data;
    end
    if(of_write_en && overflow)regs[30][0]<=1;
end

endmodule