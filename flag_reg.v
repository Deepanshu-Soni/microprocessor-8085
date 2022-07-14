module flag_reg(
input clk,reset,is_zero,is_parity,is_sign,is_carry,
output reg flg_zero,flg_parity,flg_sign,flg_carry);

reg [3:0] flg_reg;

always@(negedge clk)
begin
if(reset)
flg_reg <= 4'd0;
else
begin
flg_reg[0] <= is_zero;
flg_reg[1] <= is_parity;
flg_reg[2] <= is_sign;
flg_reg[3] <= is_carry;
end

end

always@(flg_reg)
begin
flg_zero = flg_reg[0];
flg_parity = flg_reg[1];
flg_sign = flg_reg[2];
flg_carry = flg_reg[3];
end

endmodule
