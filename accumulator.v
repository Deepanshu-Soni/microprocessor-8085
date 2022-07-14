module accumulator(
    inout [7:0] data_bus,
    input [7:0] alu_data,
    output reg [7:0] acc_out,
    input clk,reset,en,alu_select,en_rw
    );
	 
	 reg [7:0] accReg;
	 reg [7:0] data_reg = 8'd0;
	 
	 always@(posedge clk or posedge reset)
	 begin
	 if (reset)
	 begin
	 accReg <= 8'd0;	 
	 end
	 else if (en_rw && (!alu_select) && en)
	 accReg <= alu_data;
	 else if (en_rw && alu_select && en)
	 accReg <= data_bus;
	 end
	 
	 
	 always@(accReg or en or en_rw)
	 begin
	 if (!en_rw && en)
	 data_reg = accReg;
	 else
	 data_reg = 8'dZ;
	 acc_out = accReg;
	 end
assign data_bus = data_reg;
	 

endmodule