module cache_tb();

reg en,clk1,clk2;
reg [31:0]addr;


wire [31:0]dataOut;
wire hit;


l1 l(en, addr, dataOut,hit, clk1, clk2);


always
#1 clk1=~clk1;


always@(posedge clk1)
    clk2 = ~clk2;


initial
begin

clk1=0;
clk2=0;

#2

en=1;
addr = 32'd212886778;


end


initial
#10 $finish;



initial
$monitor($time, " data hit =%b address = %b    dataOut = %b     clk=%b",hit,addr,dataOut,clk2);


endmodule
