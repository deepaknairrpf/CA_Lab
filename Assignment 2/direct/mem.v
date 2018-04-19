module main_memory (en,w, addr, dataIn, dataOut, clk);

input w,en,clk;
input [31:0]dataIn,addr;
output reg [127:0] dataOut;


reg [32:0]mem[63:0];
wire [5:0] w1,w2,w3,w4;


initial
begin


mem[0] = 32'd289383;
mem[1] = 32'd930886;
mem[2] = 32'd692777;
mem[3] = 32'd636915;
mem[4] = 32'd747793;
mem[5] = 32'd238335;
mem[6] = 32'd885386;
mem[7] = 32'd760492;
mem[8] = 32'd516649;
mem[9] = 32'd641421;
mem[10] = 32'd202362;
mem[11] = 32'd490027;
mem[12] = 32'd368690;
mem[13] = 32'd520059;
mem[14] = 32'd897763;
mem[15] = 32'd513926;
mem[16] = 32'd180540;
mem[17] = 32'd383426;
mem[18] = 32'd89172;
mem[19] = 32'd455736;
mem[20] = 32'd5211;
mem[21] = 32'd595368;
mem[22] = 32'd702567;
mem[23] = 32'd956429;
mem[24] = 32'd465782;
mem[25] = 32'd21530;
mem[26] = 32'd722862;
mem[27] = 32'd665123;
mem[28] = 32'd174067;
mem[29] = 32'd703135;
mem[30] = 32'd513929;
mem[31] = 32'd979802;
mem[32] = 32'd634022;
mem[33] = 32'd723058;
mem[34] = 32'd133069;
mem[35] = 32'd898167;
mem[36] = 32'd961393;
mem[37] = 32'd18456;
mem[38] = 32'd175011;
mem[39] = 32'd478042;
mem[40] = 32'd176229;
mem[41] = 32'd377373;
mem[42] = 32'd484421;
mem[43] = 32'd544919;
mem[44] = 32'd413784;
mem[45] = 32'd898537;
mem[46] = 32'd575198;
mem[47] = 32'd594324;
mem[48] = 32'd798315;
mem[49] = 32'd664370;
mem[50] = 32'd566413;
mem[51] = 32'd803526;
mem[52] = 32'd776091;
mem[53] = 32'd268980;
mem[54] = 32'd759956;
mem[55] = 32'd241873;
mem[56] = 32'd806862;
mem[57] = 32'd999170;
mem[58] = 32'd906996;
mem[59] = 32'd497281;
mem[60] = 32'd702305;
mem[61] = 32'd420925;
mem[62] = 32'd477084;
mem[63] = 32'd336327;

end

assign w1[5:2] = addr[31:28];
assign w2[5:2] = addr[31:28];
assign w3[5:2] = addr[31:28];
assign w4[5:2] = addr[31:28];

assign w1[1:0] = 2'b00;
assign w2[1:0] = 2'b01;
assign w3[1:0] = 2'b10;
assign w4[1:0] = 2'b11;


always@(negedge clk)
begin

if (en==1)
begin

    if (w==1)
        mem[addr] <= dataIn;
        
    else
    begin
    
        dataOut[127:96] <= mem[w1];
        dataOut[95 :64] <= mem[w2];
        dataOut[63 :32] <= mem[w3];
        dataOut[31 :0 ] <= mem[w4];
        
        
    end  

end

end


endmodule
