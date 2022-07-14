module stackPointer(
                    input clk,
						  input reset,
						  input en,
						  input en_read,
						  input inr_sp,
						  output reg [15:0] addr_bus);
 reg [15:0] regsp ;
 
 always @(posedge clk) begin
   if (reset) begin
	 regsp <= 16'h00FA;
	 end
	else if (en_read && (!inr_sp) && en) begin
	 regsp <= regsp - 16'd1;
	 end
	
	else if (en_read && inr_sp && en) begin 
			regsp <= regsp + 16'd1;
     end
	  end
	  
	  
	 always @(*) begin 
	 if ((!en_read ) && en)
	 addr_bus = regsp ;
	  else
	 addr_bus = 16'dZ ;				
end
endmodule