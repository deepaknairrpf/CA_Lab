module cache_tb();

reg enable,clk1,clk2;
reg [11:0]address;


wire [31:0]dataout;



cache l(enable, address, dataout, clk1, clk2);


always
#1 clk1=~clk1;


always@(posedge clk1)
    clk2 = ~clk2;


initial
begin

clk1=0;
clk2=0;

#2

enable=1;
address = 12'b000100100100;

#10

address = 12'b000110010000;


end


initial
#130 $finish;


	
initial
$monitor($time, "     dataout = %b     clk1=%b",dataout,clk2);


endmodule
