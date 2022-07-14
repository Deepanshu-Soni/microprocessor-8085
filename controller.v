module controller(

input clk,reset,
input [7:0] instruction,
input [3:0] flags,

output reg acc_en,acc_rw,acc_src,
output reg ir_rw,mar_rw,
output reg [2:0] alu_op,
output reg mbr_en,mbr_rw,mbr_src,
output reg pc_en,pc_rw,pc_ld,pc_inc,
output reg ram_en,ram_rw,
output reg regf_en,regf_rw,
output reg [2:0] regf_addr,
output reg sp_en,sp_rw,sp_ld,
output reg buff_rw,buff_en);

parameter reset_state = 6'd21, fetch0 = 6'd22, fetch1 = 6'd23, fetch2 = 6'd24, dm_rr0 = 6'd0, dm_rr1 =6'd1,
			 dm_mr0 = 6'd2, dm_mr1 =6'd3, dm_mr2 = 6'd4, dm_rm0 = 6'd5, dm_rm1 =6'd6, dm_rm2 =6'd7,
			 alu_r0 = 6'd16, alu_r1 = 6'd17, alu_m0 = 6'd18, alu_m1 = 6'd19, alu_m2 = 6'd20, imm_cm0 = 6'd32,
			 imm_cm1 = 6'd33,imm_dm0 = 6'd34, imm_alu0 = 6'd35, imm_alu1 = 6'd36, j_st0 = 6'd48, j_st1 = 6'd49,
			 j_st2 = 6'd50, j_st2hlf = 6'd51, j_st3 = 6'd52, j_st4 = 6'd53, j_st5 = 6'd54, j_alt0 = 6'd55,
			 j_alt1 = 6'd56, push_st0 = 6'd57, push_st1 = 6'd58, pop_st0 = 6'd59, pop_st1 = 6'd60,
			 pop_st2 = 6'd61, pop_st3 = 6'd62, pop_st4 = 6'd63, halt = 6'd63;
			 
reg [5:0] state = reset_state;

always@(posedge clk)
begin
if (reset)
state <= reset_state;
else
begin

case(state)

reset_state : begin
				  state <= (reset)?reset_state:fetch0;
				  end				  
fetch0 : begin
			state <= fetch1;			
			end
fetch1: begin
			state <= fetch2;			
			end
			
fetch2 : begin
			case(instruction[7:6])
			
			2'b00 : begin
					
					if (instruction[5:3] == 3'b111)
					state <= dm_mr0;
					else if (instruction[2:0] == 3'b111)
					state <= dm_rm0;
					else
					state <= dm_rr0;
					
					end
			2'b01 : begin
					
					if (instruction[2:0] == 3'b111)
						state <= alu_m0;
					else
						state <= alu_r0;
						
					end
			2'b10 : begin
					state <= imm_cm0;
				  end
				  
			2'b11 : begin
						case(instruction[5])
						1'd0 : begin
								 
								  if (instruction[5:3] == 3'b000)
										state <= j_st0;
										
								else if (instruction[5:3] == 3'b001 && flags[0])
										state <= j_st0;
								else if (instruction[5:3] == 3'b010 && ((!flags[0]) && (!flags[3])))
										state <= j_st0;
								else if (instruction[5:3] == 3'b011 && flags[3])
										state <= j_st0;
								
								else
							         state <= j_alt0;
										end
						1'd1 : begin
									
									if (instruction[4:3] == 2'b00)
									   state <= push_st0;
									else if (instruction[4:3] == 2'b01)
										state <= pop_st0;
										else
										state <= halt;
									end
						
						endcase
						end
						endcase
						end
						
						

dm_rr0 : state <= dm_rr1;
dm_rr1 : state <= fetch0;
dm_mr0 : state <= dm_mr1;  
dm_mr1 : state <= dm_mr2;
dm_mr2 : state <= fetch0;  
dm_rm0 : state <= dm_rm1; 
dm_rm1 : state <= dm_rm2;
dm_rm2 : state <= fetch0;
alu_r0 : state <= alu_r1;
alu_r1 : state <= fetch0;
alu_m0 : state <= alu_m1;
alu_m1 : state <= alu_m2;
alu_m2 : state <= alu_r1;
j_alt0 : state <= j_alt1;
j_alt1 : state <= fetch0;
imm_cm0 : state <= imm_cm1;

imm_cm1 : begin
				if (instruction[5] == 1'b0)
					state <= imm_dm0;
				else
				 state <= imm_alu0;
			end
			
imm_dm0 : state <= fetch0;
imm_alu0 : state <= imm_alu1;
imm_alu1 : state <= fetch0;
j_st0 : state <= j_st1;
j_st1 : state <= j_st2;
j_st2 : state <= j_st2hlf;
j_st2hlf : state <= j_st3;
j_st3 : state <= j_st4;
j_st4 : state <= j_st5;
j_st5 : state <= fetch0;
push_st0 : state <= push_st1;
push_st1 : state <= fetch0;
pop_st0 : state <= pop_st1;
pop_st1 : state <= pop_st2;
pop_st2 : state <= pop_st3;
pop_st3 : state <= fetch0;

default : state <= halt;

endcase
end
end

always@*
begin

if (( ((state === dm_rr0) || (state === dm_mr0) || (state === pop_st3)) && (instruction[2:0] === 3'b000)) || ( (state === dm_rr1) && (instruction[5:3] === 3'b000)) || ( (state === dm_rm2) && (instruction[5:3] === 3'b000) ) || ( ((state === imm_dm0) || (state === push_st0)) && (instruction[2:0] === 3'b000) ) || (state === alu_r1) || (state === imm_alu1))
     acc_en = 1'b1;
else
     acc_en = 1'b0;

if ( (((state == dm_rr1) || (state == dm_rm2)) && (instruction[5:3] == 3'b000)) || ( ((state == imm_dm0) || (state == pop_st3)) && (instruction[2:0] == 3'b000) ) || (state == alu_r1) || (state == imm_alu1))
     acc_rw = 1'b1;
else
     acc_rw = 1'b0;

if (( ((state == dm_rr1) || (state == dm_rm2)) && (instruction[5:3] == 3'b000)) || ( ((state == imm_dm0) || (state == push_st0) || (state == pop_st3)) && (instruction[2:0] == 3'b000)) )
   acc_src = 1'b1;
else
   acc_src = 1'b0;

if ((state == alu_r0) || (state == alu_m2))
	 alu_op = instruction[5:3];
else if (state == imm_alu0)
    alu_op = instruction[4:2];
else
    alu_op = 3'dZ;

if (state == fetch2)
  ir_rw = 1'b1;
 else
   ir_rw = 1'b0;

  
if ((state == fetch0) || (state == dm_rm0) || (state == dm_mr1) || (state == alu_m0 || state == imm_cm0) || (state == j_st0) || (state == j_st2hlf) || (state == push_st0) || (state == pop_st1) ) 
	 mar_rw = 1'b1;
else
   mar_rw = 1'b0;  

if ( (state == fetch1) || (state == fetch2) || (state == dm_rm1) || (state == dm_rm2) || (state == dm_mr1) || (state == dm_mr2) || (state == push_st0) || (state == push_st1) || (state == pop_st2) || (state == pop_st3) || (state == alu_m1) || (state == alu_m2) || (state == imm_cm1) || (state == imm_dm0) || (state == imm_alu0) || (state == j_st1) || (state == j_st3) || (state == j_st2) || (state == j_st4) )
	 mbr_en = 1'b1;
	
else
    mbr_en = 1'b0;
	
if ( (state == fetch1) || (state == dm_rm1) || (state == dm_mr1) || (state == alu_m1) || (state == imm_cm1) || (state == j_st1) || (state == j_st3) || (state == push_st0) || (state == pop_st2) )
	  mbr_rw = 1'b1;
else 
    mbr_rw = 1'b0;


if ( (state == fetch2) || (state == dm_rm2) || (state == dm_mr1) || (state == alu_m2) || (state == imm_dm0) || (state == imm_alu0) || (state == j_st2) || (state == j_st4) || (state == push_st0) || (state == pop_st3) )
    mbr_src = 1'b1;
else 
	 mbr_src = 1'b0;
	
if ( (state == fetch0) || (state == fetch1) || (state == imm_cm0) || (state == imm_cm1) || (state == j_st0) || (state == j_st1) || (state == j_st3) || (state == j_st2hlf) || (state == j_st4) || (state == j_st5) || (state == j_alt0) || (state == j_alt1)) 
	 pc_en = 1'b1;
else 
	 pc_en = 1'b0;
	
if ( (state == j_st4) || (state == j_st5)) 
	 pc_rw = 1'b1;
else
	 pc_rw = 1'b0;
	
if (state == j_st5)
	 pc_ld = 1'b1;
else
	 pc_ld = 1'b0;
	
if ( (state == fetch1) || (state == imm_cm1) || (state == j_st1) || (state == j_st3) || (state == j_alt0) || (state == j_alt1) )
   pc_inc = 1'b1;
  else
   pc_inc = 1'b0;

if ( (state == fetch1) || (state == dm_rm1) || (state == dm_mr2) || (state == alu_m1) || (state == imm_cm1) || (state == j_st1) || (state == j_st3) || (state == push_st1) || (state == pop_st2)) 
	 ram_en = 1'b1;
else 
	 ram_en = 1'b0;
	
if ( (state == dm_mr2) || (state == push_st1))
	 ram_rw = 1'b1;
else
	 ram_rw = 1'b0;
	
if (( ((state == dm_rr0) || (state == dm_mr0)) && (instruction[2:0] != 3'b000)) || ( (state == dm_rr1) && (instruction[5:3] != 3'b000) ) || ( (state == dm_rm2) && (instruction[5:3] != 3'b000) ) || ( ((state == imm_dm0) || (state == push_st0) || (state == pop_st3)) && (instruction[2:0] != 3'b000) ) || (state == dm_rm0) || (state == dm_mr1) || (state == alu_m0) || (state == alu_r0) )
	 regf_en = 1'b1;
else
	 regf_en = 1'b0;
	
if (( ((state == dm_rr1) || (state == dm_rm2)) && (instruction[5:3] != 3'b000)) || ( ((state == imm_dm0) || (state == pop_st3)) && (instruction[2:0] != 3'b000) ))
    regf_rw = 1'b1;
else
    regf_rw = 1'b0;

if (( ((state == dm_rr0) || (state == dm_mr0) || (state == imm_dm0) || (state == push_st0) || (state == pop_st3)) && (instruction[2:0] != 3'b000)) || (state == dm_rm0) || (state == alu_r0) || (state == alu_m0))
	 regf_addr = instruction[2:0];
else if (( ((state == dm_rr1) || (state == dm_rm2)) && (instruction[5:3] != 3'b000)) || (state == dm_mr1))	
	 regf_addr = instruction[5:3];
else
	 regf_addr = 3'dZ;
	

if ((state == push_st0) || (state == push_st1) || (state == pop_st0) || (state == pop_st1))
	 sp_en = 1'b1;
else
	 sp_en = 1'b0;
	
if ((state == push_st1) || (state == pop_st0)) 
	 sp_rw = 1'b1;
else
	 sp_rw = 1'b0;
	
if (state == pop_st0)
	 sp_ld = 1'b1;
else
	 sp_ld = 1'b0;
	

if ((state == dm_rr0) || (state == dm_rr1) || (state == dm_mr0) || (state == dm_mr1) || (state == j_st2) || (state == j_st5)) 
    buff_en = 1'b1;
else 
	 buff_en = 1'b0;
	
if ( ( state == dm_rr0) || (state == dm_mr0) || (state == j_st2) || (state == alu_r0) || (state == alu_m2) || (state == imm_alu0))
	 buff_rw = 1'b1;
else
    buff_rw = 1'b0;
	 
	 end
	
//always@(posedge clk)
//begin
//if (reset)
//state <= reset_state;
//else
//state <= state;
//end
	

	


endmodule

			
 						
			
			

