module program_counter(
input clk,reset,en,en_read,inc,ld_high,
input [7:0] data_bus,
output reg [15:0] addr_bus);

reg [15:0] pcReg = 16'dz;

always@(posedge clk)
begin
if (reset)
pcReg <= 8'd0;

else if (en_read && (!ld_high) && en)
pcReg[7:0] <= data_bus;
else if (en_read && ld_high && en)
pcReg[15:8] <= data_bus;

else if (inc && en)
pcReg <= pcReg + 16'd1;

end

always@(en or en_read or pcReg)
begin

if ((!en_read) && en)
addr_bus = pcReg;
else
addr_bus = 16'dz;

end

endmodule 
