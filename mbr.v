module mbr (
input clk,reset,data_src,en_read,en,
inout [7:0] data_bus,ram_data);

reg [7:0] mbrReg; //data_reg,ram_reg;

always@(posedge clk)
begin

if (reset)
begin
mbrReg <= 8'd0;
end 
else if (data_src && en_read && en)
mbrReg <= data_bus;
else if ((!data_src) && en_read && en)
mbrReg <= ram_data;

end


assign data_bus = (en_read)?8'dz:((data_src)?((en)?mbrReg:8'dz):8'dz);
assign ram_data = (en_read)?8'dz:((data_src)?8'dz:((en)?mbrReg:8'dz));

endmodule


