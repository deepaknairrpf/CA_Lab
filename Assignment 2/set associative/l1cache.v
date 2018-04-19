module l1 (enable, address, dataout, clk1,clk2);


input enable,clk1,clk2;
input [11:0]address;
output reg [31:0] dataout;


reg [31:0]cache[63:0];
reg [5:0]tag[15:0];
reg  [31:0]cacheout;
reg [5:0]word;
reg w;
reg LRU_block[7:0];

wire [2:0]set;
wire [5:0]word1, word2, word3, word4;
wire [31:0]din;
wire [127:0]dout;
wire [3:0] tag1,tag0;


assign tag0[3:1] = address[5:3];
assign tag0[0] = 1'b0;

assign tag1[3:1] = address[5:3];
assign tag1[0] = 1'b1;
 

assign set = address[5:3];


assign word1[5:3] = address[5:3];
assign word2[5:3] = address[5:3];
assign word3[5:3] = address[5:3];
assign word4[5:3] = address[5:3];

assign word1[2] = LRU_block[address[5:3]];
assign word2[2] = LRU_block[address[5:3]];
assign word3[2] = LRU_block[address[5:3]];
assign word4[2] = LRU_block[address[5:3]];

assign word1[1:0] = 2'b00;
assign word2[1:0] = 2'b01;
assign word3[1:0] = 2'b10;
assign word4[1:0] = 2'b11;


always@(posedge clk2)
begin

    if (enable)
    begin

        if (tag[tag0] == address[11:6])
        begin
    
             word[5:2] = tag0;
             word[1:0] = address[1:0];
             w=1'b0;
             LRU_block[set] = 1'b1;
             
        end
        
        else if (tag[tag1] == address[11:6])
        begin
    
             
             word[5:2] = tag1;
             word[1:0] = address[1:0];
             w=1'b0;
             LRU_block[set] = 1'b0;
             
        end
        
        
        else
        begin
                 
            w=1'b1;
  
        end

    end



end


always@( negedge clk2)
begin

if(enable)
begin

    if (w==1'b1)
    begin
    
       cache[word1] <= dout[127:96] ;
       cache[word2] <= dout[95 :64] ;
       cache[word3] <= dout[63 :32] ;
       cache[word4] <= dout[31 :0 ] ;
       
       tag[word1[5:2]] <= address[11:6];
       
       
   end
       
    else
    begin
    
    dataout <= cache[word];
    end
    
 
end

end

main_memory mm( w, 1'b0 , address, din, dout, clk1);

initial
begin

cache[0] = 32'd4289383;
cache[1] = 32'd6930886;
cache[2] = 32'd1692777;
cache[3] = 32'd4636915;
cache[4] = 32'd7747793;
cache[5] = 32'd4238335;
cache[6] = 32'd9885386;
cache[7] = 32'd9760492;
cache[8] = 32'd6516649;
cache[9] = 32'd9641421;
cache[10] = 32'd5202362;
cache[11] = 32'd490027;
cache[12] = 32'd3368690;
cache[13] = 32'd2520059;
cache[14] = 32'd4897763;
cache[15] = 32'd7513926;
cache[16] = 32'd5180540;
cache[17] = 32'd383426;
cache[18] = 32'd4089172;
cache[19] = 32'd3455736;
cache[20] = 32'd5005211;
cache[21] = 32'd1595368;
cache[22] = 32'd4702567;
cache[23] = 32'd6956429;
cache[24] = 32'd6465782;
cache[25] = 32'd1021530;
cache[26] = 32'd8722862;
cache[27] = 32'd3665123;
cache[28] = 32'd5174067;
cache[29] = 32'd8703135;
cache[30] = 32'd1513929;
cache[31] = 32'd1979802;
cache[32] = 32'd5634022;
cache[33] = 32'd5723058;
cache[34] = 32'd9133069;
cache[35] = 32'd5898167;
cache[36] = 32'd9961393;
cache[37] = 32'd9018456;
cache[38] = 32'd8175011;
cache[39] = 32'd6478042;
cache[40] = 32'd1176229;
cache[41] = 32'd3377373;
cache[42] = 32'd9484421;
cache[43] = 32'd4544919;
cache[44] = 32'd8413784;
cache[45] = 32'd6898537;
cache[46] = 32'd4575198;
cache[47] = 32'd3594324;
cache[48] = 32'd9798315;
cache[49] = 32'd8664370;
cache[50] = 32'd9566413;
cache[51] = 32'd4803526;
cache[52] = 32'd2776091;
cache[53] = 32'd4268980;
cache[54] = 32'd1759956;
cache[55] = 32'd9241873;
cache[56] = 32'd7806862;
cache[57] = 32'd2999170;
cache[58] = 32'd2906996;
cache[59] = 32'd5497281;
cache[60] = 32'd1702305;
cache[61] = 32'd4420925;
cache[62] = 32'd7477084;
cache[63] = 32'd7336327;

 
tag[0] = 6'b00000;
tag[1] = 6'b00001;
tag[2] = 6'b00010;
tag[3] = 6'b00011;
tag[4] = 6'b00100;
tag[5] = 6'b00101;
tag[6] = 6'b00110;
tag[7] = 6'b00111;
tag[8] = 6'b01000;
tag[9] = 6'b01001;
tag[10] = 6'b01010;
tag[11] = 6'b01011;
tag[12] = 6'b01100;
tag[13] = 6'b01101;
tag[14] = 6'b01110;
tag[15] = 6'b01111;

LRU_block[0] = 1'b0;
LRU_block[1] = 1'b0;
LRU_block[2] = 1'b0;
LRU_block[3] = 1'b0;
LRU_block[4] = 1'b0;
LRU_block[5] = 1'b0;
LRU_block[6] = 1'b0;
LRU_block[7] = 1'b0;

      
end

endmodule
