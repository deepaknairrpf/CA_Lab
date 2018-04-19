module l1 (enable, address, dataout, hit,clk1,clk2);

input enable,clk1,clk2;
input [31:0]address;
output reg [31:0] dataout;
output reg hit;

reg [31:0]cache[15:0];
reg [1:0]tag[3:0];
reg  [31:0]cacheout;
reg w;

wire [1:0]block;
wire [3:0]word,word1, word2, word3, word4;
wire [31:0]dIn;
wire [127:0]dOut;

assign block = address[29:28];
assign word  = address[29:26];

assign word1[3:2] = address[29:28];
assign word2[3:2] = address[29:28];
assign word3[3:2] = address[29:28];
assign word4[3:2] = address[29:28];

assign word1[1:0] = 2'b00;
assign word2[1:0] = 2'b01;
assign word3[1:0] = 2'b10;
assign word4[1:0] = 2'b11;


initial
begin

cache[0] = 32'b00100010110001111001000100100010;
cache[1] = 32'b00101000010101111100001000000010;
cache[2] = 32'b00010110011000100100100010110011;
cache[3] = 32'b01010010110011010011110000100011;
cache[4] = 32'b10000101011001110100101101010101;
cache[5] = 32'b00100100010110001011110011001010;
cache[6] = 32'b10010010001101110001000110110111;
cache[7] = 32'b11010000011010111101000101010100;
cache[8] = 32'b11111111101000111101001001101000;
cache[9] = 32'b00000010000001011011101111101000;
cache[10] = 32'b01011101100100010101110100110010;
cache[11] = 32'b11110101000001110100000000010010;
cache[12] = 32'b10100110000011110010101010110011;
cache[13] = 32'b00100000100011010101111010010110;
cache[14] = 32'b00011100000100101111101001100010;
cache[15] = 32'b10001111111110001111001011111000;


tag[0] = 2'b00;
tag[1] = 2'b01;
tag[2] = 2'b10;
tag[3] = 2'b11;


end


always@(posedge clk2)
begin

    if (enable)
    begin

        if (tag[block] == address[31:30])
        begin
    
             dataout = cache[word];
             hit = 1;
             w=0;
             
        end
        
        
        else
        begin
            hit = 0;
            w=1;
  
        end

    end



end



always@( negedge clk2)
begin

    if (w)
    begin
    
       cache[word1] <= dOut[127:96] ;
       cache[word2] <= dOut[95 :64] ;
       cache[word3] <= dOut[63 :32] ;
       cache[word4] <= dOut[31 :0 ] ;
       
       tag[block] <= address[31:30];
        
    
    end
    
 
end



main_memory mm( w, 1'b0 , address, dIn, dOut, clk1);


endmodule
