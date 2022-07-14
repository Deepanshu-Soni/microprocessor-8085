module instr_reg(
input clk,reset,en_read,
input [7:0] data_bus,
output reg [7:0] instReg_out);

reg [7:0] irReg;

always@(negedge clk)
begin
if (reset)
irReg <= 8'd0;
else if (en_read)
irReg <= data_bus;
end
always@(irReg)
instReg_out = irReg;

endmodule 