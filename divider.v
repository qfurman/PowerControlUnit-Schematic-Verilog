module divider (clkIn, clkOut);

input clkIn;
output clkOut;

reg[1:0] cnt; // internal counter
reg flag;

assign clkOut = flag;
always @ (posedge clkIn)
begin
  cnt <= cnt+2'b1;
  if (cnt == 2)begin
	cnt <= 0;
	flag = !flag;
	end
  
end


endmodule
