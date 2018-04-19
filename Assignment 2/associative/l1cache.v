module cache (en, addr, dataOut, clk,clk2);

input en,clk,clk2;
input [11:0]addr;
output reg [31:0] dataOut;


reg [31:0]cache[15:0];
reg [9:0]tag[3:0];
reg  [31:0]cache_out;
reg [3:0]word;
reg w;
reg [1:0]FCFS[3:0];


wire [5:0]word1, word2, word3, word4;
wire [31:0]dIn;
wire [127:0]dOut;






// assigning set number 

assign set = addr[5:3];



// preparing block address to be replaced in cache (in case if required data is not there)

assign word1[3:2] = FCFS[0];
assign word2[3:2] = FCFS[0];
assign word3[3:2] = FCFS[0];
assign word4[3:2] = FCFS[0];


assign word1[1:0] = 2'b00;
assign word2[1:0] = 2'b01;
assign word3[1:0] = 2'b10;
assign word4[1:0] = 2'b11;



always@(posedge clk2)
begin

    if (en)
    begin

        if (tag[0] == addr[11:2])
        begin
            
             word[1:0] = addr[1:0];
             word[3:2] = 2'b00;
             w=1'b0;
             
        end
        
        else  if (tag[1] == addr[11:2])
        begin
    
             word[1:0] = addr[1:0];
             word[3:2] = 2'b01;
             w=1'b0;
             
        end
        
        else if (tag[2] == addr[11:2])
        begin
    
             word[1:0] = addr[1:0];
             word[3:2] = 2'b10;
             w=1'b0;
             
        end
        
        else  if (tag[3] == addr[11:2])
        begin
               
             word[1:0] = addr[1:0];
             word[3:2] = 2'b11;
             w=1'b0;
             
        end
        
        
        else
        begin
             
          
            w=1'b1;
            FCFS[0] <=FCFS[1];
            FCFS[1] <=FCFS[2];
            FCFS[2] <=FCFS[3];
            FCFS[3] <=FCFS[0];
  
        end

    end



end





always@( negedge clk2)
begin

if(en)
begin

    if (w==1'b1)
    begin
    
       cache[word1] <= dOut[127:96] ;
       cache[word2] <= dOut[95 :64] ;
       cache[word3] <= dOut[63 :32] ;
       cache[word4] <= dOut[31 :0 ] ;
       
       tag[word1[3:2]] <= addr[11:2];
       
       
   end
    
    
    
    else
    begin
    
    dataOut <= cache[word];
    end
    
 
end

end



main_memory mm( w, 1'b0 , addr, dIn, dOut, clk);





initial
begin

 cache[0] = 32'b10111100110101100000101100011110;
 cache[1] = 32'b00111010111101001010100100011101;
 cache[2] = 32'b01011101010100101000001101000010;
 cache[3] = 32'b00011000111010001001110101111111;
 cache[4] = 32'b11101101011001011100010101010111;
 cache[5] = 32'b10001010000010111110011011010111;
 cache[6] = 32'b11001101001110000000111001010101;
 cache[7] = 32'b00110010001110010011000010111001;
 cache[8] = 32'b00000100000100000110011110100111;
 cache[9] = 32'b10111001000000000110101000110001;
 cache[10] = 32'b01101111101101101000000101000000;
 cache[11] = 32'b11010001000011100100111001001011;
 cache[12] = 32'b11011001000001000100000010111000;
 cache[13] = 32'b10010001101111100100101100010001;
 cache[14] = 32'b00000111100101101110101101101111;
 cache[15] = 32'b10011110011010001100100111110101;
 
 
tag[0] = 10'b0000000000;
tag[1] = 10'b0000000001;
tag[2] = 10'b0000000010;
tag[3] = 10'b0000000011;


      
end




dataOut=32'b10011110011010001100100111110101;
 
endmodule
