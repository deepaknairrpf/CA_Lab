module cache_tb();

reg en,clk,clk2;
reg [11:0]addr;


wire [31:0]dataOut;



l1 l(en, addr, dataOut, clk, clk2);


always
#1 clk=~clk;


always@(posedge clk)
    clk2 = ~clk2;


initial
begin

clk=0;
clk2=0;

#2

en=1;
addr = 12'b000010000000;

#10

addr = 12'b000110010100;


end


initial
#130 $finish;



initial
$monitor($time, "     dataOut = %b     clk=%b",dataOut,clk2);


endmodule
