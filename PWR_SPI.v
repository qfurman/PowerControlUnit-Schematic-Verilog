module PWR_SPI(SSEL, SCR1, SCR2, Rw,SCK,MOSI,CLK,SYNC,MISO,STR, BRN, BRN1, BRN2);

input SSEL, SCR1, SCR2, Rw,MOSI,SCK,CLK,SYNC;
output wire MISO,STR, BRN, BRN1, BRN2;

reg[4:0]bit_cntr;
reg[15:0]word;
reg[15:0]SP0;//=16'hffff;
reg[15:0]SP1;
reg[15:0]SP2;
reg[15:0]PCNTR;//power couter
reg engage;//burn
reg engage1;//burn
reg engage2;//burn

reg F1;//rise edge 
reg wF;//write flag 
reg [1:0]rCntr;//couter

assign STR = !F1;//signal inverting a transistor
assign MISO = SP0[15-bit_cntr];
assign BRN = engage;
assign BRN1 = engage1;
assign BRN2 = engage2;

always@(negedge SCK, posedge SSEL)
begin
    
    if(SSEL)begin
        bit_cntr <= 0;
    end 
    else begin 
		bit_cntr <= bit_cntr + 5'b00001;
    end
end

always@(posedge SCK)
begin
    word[15-bit_cntr] = MOSI;
end

always@(negedge SSEL, posedge CLK)
begin
	if(SSEL == 0)begin 
		rCntr <= 2;
		if (bit_cntr == 16) F1 <= 1;//set write flag
	    if (Rw==0) wF <= 1;//catch the write signal  
	end
	else begin 
		rCntr <= rCntr - 2'b01;
		if(rCntr == 0)begin
			F1 <= 0;
			if(wF)begin
				if (SCR1==0) SP0[15:0] <= word[15:0];//word[15:0];//16'h8231;//word[16:1];//write if read write signal is low 
				else if (SCR2==1) SP1[15:0] <= word[15:0];
					 else SP2[15:0] <= word[15:0];
				wF <= 0;
			end	
	    end		
	end     
end

always@(posedge CLK)
begin
	
	if(SYNC)begin
		PCNTR = 0;
		engage = 0;
		engage1 = 0;
		engage2 = 0;
	end	else 
		begin
			PCNTR = PCNTR + 16'b1;
			if (PCNTR == SP0) engage = 1;		
			if (PCNTR == SP1) engage1 = 1;		
			if (PCNTR == SP2) engage2 = 1;		
		end
	
end

endmodule
