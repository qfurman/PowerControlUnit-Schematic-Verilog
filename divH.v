module divH (clkIn, clkOut, oneHalf);

input clkIn;
output clkOut, oneHalf;
reg ltc;

reg[12:0] cnt; // internal counter

assign clkOut = cnt[12];
assign oneHalf = ltc;

always @ (posedge clkIn)
begin
  cnt <= cnt+13'b1;
  if(cnt == 13'b1111111111111) ltc <=1;
end


endmodule
