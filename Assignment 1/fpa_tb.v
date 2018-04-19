`timescale 1ns / 1ps
//`include "main.v"
module fpa_tb();

reg [31:0]a,b;
reg decidebit,clk,reset;
wire [22:0]finalmanti;
wire [7:0]finexponent;
wire signbit;


fpa j2(a,b,decidebit,clk,reset,signbit,finexponent,finalmanti);

initial
clk=1'b1;

initial 
begin

reset=1'b0;
clk=1'b0;


a=32'b01101011111100111010000011000011;  //exp equal
b=32'b01101011100011100101111100011100;  
decidebit=1'b0;



#20
a=32'b01101011111100111010000011000011;    //exponent=215   mantissa=11101011101.........
b=32'b01101000100011100101111100011100;
decidebit=1'b0;

#35 $finish;
end

always
#2 clk=~clk;

initial


$monitor("clk=%b;a=%d;b=%d;reset=%b;signbit=%b;finexponent=%d;finalmanti=%b",clk,a,b,reset,signbit,finexponent,finalmanti);

endmodule

	