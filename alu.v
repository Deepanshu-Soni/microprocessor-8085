module alu(
	input [2:0] op,
	input [7:0] acc_data,data_bus,
	output reg signed [7:0] result,
	output reg flg_zero,flg_parity,flg_sign,flg_carry);


reg [7:0] add,sub;
reg carry;

always@(op or acc_data or data_bus)
begin
if(op == 3'b000)
{carry,result} = acc_data + data_bus;
else if (op == 3'b001)
{carry,result} = acc_data - data_bus;
else if (op == 3'b010)
{carry,result} = ~(acc_data);
else if (op == 3'b011)
{carry,result} = acc_data & data_bus;
else if (op == 3'b100)
{carry,result} = acc_data | data_bus;
else if (op == 3'b101)
{carry,result} = acc_data ^ data_bus;
else if (op == 3'b110)
{carry,result} = acc_data << 1;
else if (op == 3'b111)
{carry,result} = acc_data >> 1;
else
{carry,result} = 8'dz;

//Flag Implemented
flg_zero =(result)? 1'b1:1'b0;

flg_parity = ^result;

flg_sign = (result[7])?1'b1:1'b0;

flg_carry = carry;

end

endmodule



