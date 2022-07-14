module mp8085_v1(		
			input clk,reset,
			output [7:0] acc_out
			);
			
			
wire [3:0] flags;
wire [7:0] data_bus,instruction,result,alu_result,ram_data;
wire [15:0] ram_addr,addr_bus;
wire [2:0] alu_op,regf_addr;

wire acc_en,acc_rw,acc_src,ir_rw,mar_rw,mbr_en,mbr_rw,mbr_src,pc_en,pc_rw,pc_ld,pc_inc,ram_en,ram_rw,regf_en,regf_rw,sp_en,sp_rw,sp_ld,buff_rw,buff_en,is_zero,is_parity,is_sign,is_carry;
			
			
			
			controller CTL(clk,reset,instruction,flags,acc_en,acc_rw,acc_src,ir_rw,mar_rw,alu_op,mbr_en,mbr_rw,mbr_src,pc_en,pc_rw,pc_ld,pc_inc,ram_en,ram_rw,regf_en,regf_rw,regf_addr,sp_en,sp_rw,sp_ld,buff_rw,buff_en);
			
			accumulator ACC(data_bus,result,acc_out,clk,reset,acc_en,acc_src,acc_rw);
			
			bufReg BFR(data_bus,clk,reset,buff_en,buff_rw,alu_result,result);
			
			alu ALU(alu_op,acc_out,data_bus,alu_result,is_zero,is_parity,is_sign,is_carry);
			
			flag_reg FLG(clk,reset,is_zero,is_parity,is_sign,is_carry,flags[0],flags[1],flags[2],flags[3]);
			
			instr_reg INR(clk,reset,ir_rw,data_bus,instruction);
			
			mar MAR(clk,mar_rw,addr_bus,ram_addr);
			
			mbr MBR(clk,reset,mbr_src,mbr_rw,mbr_en,data_bus,ram_data);
			
			program_counter PCT(clk,reset,pc_en,pc_rw,pc_inc,pc_ld,data_bus,addr_bus);
			
			regFile REGF(clk,reset,regf_en,regf_rw,regf_addr,data_bus,addr_bus);
			
			stackPointer STP(clk,reset,sp_en,sp_rw,sp_ld,addr_bus);
			
			memory RAM(clk,ram_en,ram_rw,ram_addr,ram_data);
			
		endmodule	