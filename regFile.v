
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:38:00 11/19/2020 
// Design Name: 
// Module Name:    RegFile 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:  clk : in  STD_LOGIC
//
//////////////////////////////////////////////////////////////////////////////////
module regFile(input clk,
                    input reset,
						  input en,
						  input en_read,
						  input [2:0] reg_addr,
						  inout [7:0] data_bus,
						  output reg [15:0] addr_bus);
						  
		reg [7:0] regs[5:0],data_reg;			  

  // Actual register file storage
  always @(posedge clk) begin
    if (reset) begin
		//data_reg <= 8'dZ;
      regs[0] <= 8'd0; 
		regs[1] <= 8'd0; 
		regs[2] <= 8'd0; 
		regs[3] <= 8'd0;
	   regs[4] <= 8'd0; 
		regs[5] <= 8'd0;
    end
    else begin
      if (en_read) begin // Only write back when inEn is asserted, not all instructions write to the register file!
        regs[reg_addr - 1] <= data_bus;
      end
    end
  end

  // Output registers
   always @(*) begin
	if ((reg_addr != 3'b111) && (!en_read) && en )
	data_reg = regs[(reg_addr) - (3'd1)];
	else
   data_reg = 8'dZ;
	
	if ( (reg_addr == 3'b111) && (!en_read) && en )
	addr_bus = {regs[4],regs[5]} ;
	else 
	addr_bus = 16'dZ ;

end

assign data_bus = data_reg;//(reg_addr != 3'b111)?(en_read?8'dz:(en?(regs[(reg_addr) - (3'd1)]):8'dz)):8'dz;

//assign addr_bus = (reg_addr == 3'b111)?(en_read?16'dz:(en?{regs[4],regs[5]}:16'dz)):16'dz;
endmodule
