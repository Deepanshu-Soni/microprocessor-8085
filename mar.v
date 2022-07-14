module mar (
input clk,en_read,
input [15:0] addr_bus,
output [15:0] ram_addr);

reg [15:0] marReg = 16'd0;

always@(posedge clk)
begin
if (en_read)
marReg <= addr_bus;
end

assign ram_addr = marReg;

endmodule
