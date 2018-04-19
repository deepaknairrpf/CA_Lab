module clock(clock,clk,out_clock);


input clock,clk;
output reg out_clock;

	always@(posedge clk)
		out_clock = ~clk;



endmodule
