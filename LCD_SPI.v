module LCD_SPI(SSEL,SCK,MOSI,CLK,RS,DLCD,E,LCD_LE);

input SSEL,MOSI,SCK,CLK;
output wire E, LCD_LE;
output RS;
output[7:0]DLCD;

reg[3:0]bit_cntr;
reg[8:0]word;

reg F1;//rise edge  
reg [1:0]rCntr;//couter

assign E = !F1;//signal inverting a transistor
assign LCD_LE = F1;//Latching if Hight

always@(negedge SCK, posedge SSEL)
begin
    
    if(SSEL)begin
        bit_cntr <= 0; 
    end 
    else begin 
		bit_cntr <= bit_cntr + 4'b0001;
    end
end

assign DLCD = (bit_cntr == 9)? word[8:1] : DLCD;
assign RS = (bit_cntr == 9)? !word[0] : RS;//signal inverting a transistor

always@(posedge SCK)
begin
    word[bit_cntr] = MOSI;  
end

always@(negedge SSEL, posedge CLK)
begin
	if(SSEL == 0)begin 
		rCntr <= 3;
		if(bit_cntr == 9)F1 <= 1;
	end
	else begin 
		rCntr <= rCntr - 2'b01;
		if(rCntr == 0) F1 <= 0;
	end
     
end

endmodule
