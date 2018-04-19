module compare(a,b,out,clk);


input [5:0]a,b;
input clk;
output reg out;



always @(posedge clk)
begin

    if(a==b)
        out = 1;
        
    else 
        out =0;

end

endmodule
