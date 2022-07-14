module memory
		#(parameter data_width = 8,
						addr_width = 16 
						)
						
			( //inputs
			  
			   input clk,en,en_read,
				input [(addr_width - 1):0] addr_bus,
				inout [(data_width - 1):0] data_bus
			
			);
			
	reg [(data_width -1):0] ram [0:31];
	
	initial
	$readmemb("initialRam.txt",ram,0,31);
	
	always@(posedge clk)
	begin
	
	if(en && en_read)
	ram[addr_bus] <= data_bus;

	end
/*	always@(*)
	begin
	if (en && (!en_read))
	dataReg <= ram[addr_bus];
	else
	dataReg <= 8'd0;
	end*/
	
	assign data_bus = en?(en_read?8'dz:ram[addr_bus]):8'dz;
	
	endmodule
	
	
	
				
				
			   