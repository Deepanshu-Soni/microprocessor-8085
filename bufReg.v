module bufReg(
	inout [7:0] data_bus,
	input clk,reset,en,en_read,
	input [7:0] alu_result,
	output [7:0] result);
	
	reg [7:0] bufrReg,data_reg;

always@(negedge clk )
begin
if (reset)
	begin
	data_reg <= 8'dZ;
	bufrReg <= 8'd0;
	end
else if (en_read && en)
bufrReg <= data_bus;

else if (en_read && (!en))
bufrReg <= alu_result;

else if (!en_read && en)
data_reg <= bufrReg;

else
data_reg <= 8'dZ;
end

assign result = bufrReg;
assign data_bus = data_reg;


endmodule


