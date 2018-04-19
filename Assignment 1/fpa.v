module fpa(a,b,decidebit,signbit,finexponent,finalmanti,finalexponent,outmantissa);
input[31:0]a,b;
input decidebit;
output [22:0]finalmanti;
wire [7:0]e1,e2,barrelkey;
wire s1,s2,low,high,same,bout,finals1,finals2,adcarry,lm,hm,sm;
wire [23:0]m1,m2;

wire [31:0]fm1,fm2,compm1,compm2,g1,g2;

output [31:0]outmantissa;
wire [7:0]finalexp1,finalexp2;
output  [7:0]finalexponent;
output [7:0]finexponent;
output reg signbit;
wire [4:0]key;
wire [7:0]diff;


assign s1=a[31];
assign s2=b[31];
assign e1=a[30:23];
assign e2=b[30:23];
assign m1[23]=1'b1;
assign m2[23]=1'b1;
assign m1[22:0]=a[22:0];
assign m2[22:0]=b[22:0];

comparator c1(e1,e2,low,high,same);
subnshiftter sf1(e1,e2,m1,m2,s1,s2,low,high,same,finalexp1,finalexp2,finalexponent,finals1,finals2,fm1,fm2,compm1,compm2);
mantissaselector h21(finals1,finals2,decidebit,fm1,fm2,g1,g2);

cla32 as1(g1,g2,0,outmantissa,adcarry);
mantissacomparator mc1(compm1,compm2,lm,hm,sm);

always @(*)
begin
if(sm==1)  //m1=m2
begin
if(finals1==0&decidebit==0&finals2==0)
begin
signbit<=0;
end
if(finals1==0&decidebit==1&finals2==0)
begin
signbit<=0;
end

if(finals1==0&decidebit==0&finals2==1)
begin
signbit<=0;
end

if(finals1==0&decidebit==1&finals2==1)
begin
signbit<=0;
end

if(finals1==1&decidebit==0&finals2==0)
begin
signbit<=0;
end

if(finals1==1&decidebit==0&finals2==1)
begin
signbit<=1;
end

if(finals1==1&decidebit==1&finals2==0)
begin
signbit<=1;
end

if(finals1==1&decidebit==1&finals2==1)
begin
signbit<=0;
end
end

else if(hm==1)    //if m1>m2
begin
if(finals1==0&decidebit==0&finals2==0)
begin
signbit<=0;
end

if(finals1==0&decidebit==1&finals2==0)
begin
signbit<=0;
end

if(finals1==0&decidebit==0&finals2==1)
begin
signbit<=0;
end

if(finals1==0&decidebit==1&finals2==1)
begin
signbit<=0;
end

if(finals1==1&decidebit==0&finals2==0)
begin
signbit<=1;
end

if(finals1==1&decidebit==0&finals2==1)
begin
signbit<=1;
end

if(finals1==1&decidebit==1&finals2==0)
begin
signbit<=1;
end

if(finals1==1&decidebit==1&finals2==1)
begin
signbit<=1;
end

end

else if(lm==1)    //if m1<m2
begin
if(finals1==0&decidebit==0&finals2==0)
begin
signbit<=0;
end

if(finals1==0&decidebit==1&finals2==0)
begin
signbit<=1;
end

if(finals1==0&decidebit==0&finals2==1)
begin
signbit<=1;
end

if(finals1==0&decidebit==1&finals2==1)
begin
signbit<=0;
end

if(finals1==1&decidebit==0&finals2==0)
begin
signbit<=0;
end

if(finals1==1&decidebit==0&finals2==1)
begin
signbit<=1;
end

if(finals1==1&decidebit==1&finals2==0)
begin
signbit<=1;
end

if(finals1==1&decidebit==1&finals2==1)
begin
signbit<=0;
end

end

end

updation b4(outmantissa,finalexponent,finalmanti,finexponent);

endmodule



module comparator(ex,ey,low,high,same);
input [7:0]ex,ey;
output low,high,same;
wire [7:0]lcheck,eynot,sum,sum1;
wire cout,cout1;

assign eynot=~ey;
assign lcheck=(ex&ey)|(~ex&~ey);
assign same=lcheck[0]&lcheck[1]&lcheck[2]&lcheck[3]&lcheck[4]&lcheck[5]&lcheck[6]&lcheck[7];

cladder8 w1(eynot,00000000,1,sum,cout);
cladder8 w2(ex,sum,0,sum1,cout1);
assign high=(cout1)&1&(~same);
assign low=(~cout1)&1;

endmodule

module subnshiftter(exp1,exp2,man1,man2,sign1,sign2,mini,max,equi,finalexp1,finalexp2,finalexponent,finals1,finals2,fm1,fm2,compm1,compm2);
input [7:0]exp1,exp2;
input mini,max,equi,sign1,sign2;
input [23:0]man1,man2;
wire [7:0]subtractor1;
wire [31:0]finalbarman2;
 output reg [7:0]finalexp1,finalexp2,finalexponent;
reg [31:0]finalman1,finalman2;
output reg finals1,finals2;
wire [7:0]finalexp2not,subtractor;
wire [31:0]finallman2,fm3;
output [31:0]fm1,compm1,compm2;
output reg[31:0]fm2;
wire outc;
always @(*)
begin

if(max==1|equi==1)
begin
    finalexp1<=exp1;
    finalexp2<=exp2;
    finalman1<=man1;
    finalman2<=man2;
    finals1<=sign1;
    finals2<=sign2;
    finalexponent<=exp1;
      
end
else if(mini==1)
begin
  
    finalexp1<=exp2;
    finalexp2<=exp1;
    finalman1<=man1;
    finalman2<=man2;
    finals1<=sign2;
    finals2<=sign1;
    finalexponent<=exp2;
end
end
assign finalexp2not=~finalexp2;
cladder8 sh1(finalexp2not,00000000,1,subtractor,outc);
cladder8 sh2(finalexp1,subtractor,0,subtractor1,outc1);

assign finallman2[23:0]=finalman2[23:0];
assign finallman2[31:24]=0;
barrelshft32 br1(finallman2,subtractor1[0],subtractor1[1],subtractor1[2],subtractor1[3],subtractor1[4],finalbarman2);
assign fm1=finalman1;
assign fm1[31:24]=0;
assign fm3=finalbarman2>>1;
always @(*)
begin
if(equi==1)
 fm2<=finalbarman2;

else
 fm2<=fm3;
end

assign compm1=fm1;
assign compm2=fm2;


endmodule


module mantissaselector(finals1,finals2,decidebit,fm1,fm2,g1,g2);
input [31:0]fm1,fm2;
output reg [31:0] g1,g2;
input finals1,finals2,decidebit;

always @(*)
begin

if(finals1==0&decidebit==0&finals2==0)
 begin
  g1<=fm1;
  g2<=fm2;
end

else if(finals1==0&decidebit==0&finals2==1)
begin
g1<=fm1;
g2<=(~fm2)+1;
end 

else if(finals1==0&decidebit==1&finals2==0)
begin
g1<=fm1;
g2<=(~fm2)+1;
end

else if(finals1==0&decidebit==1&finals2==1)
begin
g1<=fm1;
g2<=fm2;
end  

else if(finals1==1&decidebit==0&finals2==0)
begin
g1<=(~fm1)+1;
g2<=fm2;
end 
 
else if(finals1==1&decidebit==0&finals2==1)
begin
g1<=(~fm1)+1;
g2<=(~fm2)+1;
end  

else if(finals1==1&decidebit==1&finals2==0)
begin
g1<=(~fm1)+1;
g2<=(~fm2)+1;
end  

else if(finals1==1&decidebit==1&finals2==1)
begin
g1<=(~fm1)+1;
g2<=fm2;
end  

end
endmodule


module cla32(a,b,cin,s,cout);
output [31:0]s;
output cout;
input [31:0]a,b;
input cin;
wire [31:0]g,p,c;
assign g=a&b;
assign p=a^b;
assign c[0]=g[0]|(p[0]&cin);
assign c[1]=g[1]|(p[1]&(g[0]|(p[0]&cin)));
assign c[2]=g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))));
assign c[3]=g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))));
assign c[4]=g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))));

assign c[5]=g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))));

assign c[6]=g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))));

assign c[7]=g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))));

assign c[8]=g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))));

assign c[9]=g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))));

assign c[10]=g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))));

assign c[11]=g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))));

assign c[12]=g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))));

assign c[13]=g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))));

assign c[14]=g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))));

assign c[15]=g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))));

assign c[16]=g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))));

assign c[17]=g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))));

assign c[18]=g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))));

assign c[19]=g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))));

assign c[20]=g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))));

assign c[21]=g[21]|(p[21]&(g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))))));

assign c[22]=g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))))))));

assign c[23]=g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))))))))));

assign c[24]=g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))))))))))));

assign c[25]=g[25]|(p[25]&(g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))))))))))))));

assign c[26]=g[26]|(p[26]&(g[25]|(p[25]&(g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))))))))))))))));

assign c[27]=g[27]|(p[27]&(g[26]|(p[26]&(g[25]|(p[25]&(g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))))))))))))))))));

assign c[28]=g[28]|(p[28]&(g[27]|(p[27]&(g[26]|(p[26]&(g[25]|(p[25]&(g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))))))))))))))))))));

assign c[29]=g[29]|(p[29]&(g[28]|(p[28]&(g[27]|(p[27]&(g[26]|(p[26]&(g[25]|(p[25]&(g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))))))))))))))))))))));

assign c[30]=g[30]|(p[30]&(g[29]|(p[29]&(g[28]|(p[28]&(g[27]|(p[27]&(g[26]|(p[26]&(g[25]|(p[25]&(g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));

assign c[31]=g[31]|(p[31]&(g[30]|(p[30]&(g[29]|(p[29]&(g[28]|(p[28]&(g[27]|(p[27]&(g[26]|(p[26]&(g[25]|(p[25]&(g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));

assign cout=c[31];
assign s[0]=p[0]^cin;
assign s[1]=p[1]^c[0];
assign s[2]=p[2]^c[1];
assign s[3]=p[3]^c[2];
assign s[4]=p[4]^c[3];
assign s[5]=p[5]^c[4];
assign s[6]=p[6]^c[5];
assign s[7]=p[7]^c[6];
assign s[8]=p[8]^c[7];
assign s[9]=p[9]^c[8];
assign s[10]=p[10]^c[9];
assign s[11]=p[11]^c[10]; 
assign s[12]=p[12]^c[11];
assign s[13]=p[13]^c[12];
assign s[14]=p[14]^c[13];
assign s[15]=p[15]^c[14];
assign s[16]=p[16]^c[15];
assign s[17]=p[17]^c[16];
assign s[18]=p[18]^c[17];
assign s[19]=p[19]^c[18];
assign s[20]=p[20]^c[19];
assign s[21]=p[21]^c[20];
assign s[22]=p[22]^c[21];
assign s[23]=p[23]^c[22];
assign s[24]=p[24]^c[23];
assign s[25]=p[25]^c[24];
assign s[26]=p[26]^c[25];
assign s[27]=p[27]^c[26];
assign s[28]=p[28]^c[27];
assign s[29]=p[29]^c[28];
assign s[30]=p[30]^c[29];
assign s[31]=p[31]^c[30];

endmodule


module cladder8(a,b,cin,s,cout);
output [7:0]s;
output cout;
input [7:0]a,b;
input cin;
wire [7:0]g,p,c;

assign g=a&b;
assign p=a^b;
assign c[0]=g[0]|(p[0]&cin);
assign c[1]=g[1]|(p[1]&(g[0]|(p[0]&cin)));
assign c[2]=g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))));
assign c[3]=g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))));
assign c[4]=g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))));
assign c[5]=g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))));
assign c[6]=g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))));
assign c[7]=g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))));


assign cout=c[7];
assign s[0]=p[0]^cin;
assign s[1]=p[1]^c[0];
assign s[2]=p[2]^c[1];
assign s[3]=p[3]^c[2];
assign s[4]=p[4]^c[3];
assign s[5]=p[5]^c[4];
assign s[6]=p[6]^c[5];
assign s[7]=p[7]^c[6];

endmodule


module mux2(a,b,s,o);
input a,b,s;
output  o;
wire w1,w2,w3;
assign w1=~(s);
assign w2=w1&a;
assign w3=s&b;
assign o=w2|w3;
endmodule


module barrelshft32(a,s0,s1,s2,s3,s4,out);
input [31:0]a;
input s0,s1,s2,s3,s4;
output [31:0]out;
wire [31:0]o,o1,o2,o3;
wire ns0,ns1,ns2,ns3,ns4;
assign ns0=~s0;
assign ns1=~s1;
assign ns2=~s2;
assign ns3=~s3;
assign ns4=~s4;

mux2 p1(0,a[31],ns0,o[31]);
mux2 p2(a[31],a[30],ns0,o[30]);
mux2 p3(a[30],a[29],ns0,o[29]);
mux2 p4(a[29],a[28],ns0,o[28]);
mux2 p5(a[28],a[27],ns0,o[27]);
mux2 p6(a[27],a[26],ns0,o[26]);
mux2 p7(a[26],a[25],ns0,o[25]);
mux2 p8(a[25],a[24],ns0,o[24]);
mux2 p9(a[24],a[23],ns0,o[23]);
mux2 p10(a[23],a[22],ns0,o[22]);
mux2 p11(a[22],a[21],ns0,o[21]);
mux2 p12(a[21],a[20],ns0,o[20]);
mux2 p13(a[20],a[19],ns0,o[19]);
mux2 p14(a[19],a[18],ns0,o[18]);
mux2 p15(a[18],a[17],ns0,o[17]);
mux2 p16(a[17],a[16],ns0,o[16]);
mux2 p17(a[16],a[15],ns0,o[15]);
mux2 p18(a[15],a[14],ns0,o[14]);
mux2 p19(a[14],a[13],ns0,o[13]);
mux2 p20(a[13],a[12],ns0,o[12]);
mux2 p21(a[12],a[11],ns0,o[11]);
mux2 p22(a[11],a[10],ns0,o[10]);
mux2 p23(a[10],a[9],ns0,o[9]);
mux2 p24(a[9],a[8],ns0,o[8]);
mux2 p25(a[8],a[7],ns0,o[7]);
mux2 p26(a[7],a[6],ns0,o[6]);
mux2 p27(a[6],a[5],ns0,o[5]);
mux2 p28(a[5],a[4],ns0,o[4]);
mux2 p29(a[4],a[3],ns0,o[3]);
mux2 p30(a[3],a[2],ns0,o[2]);
mux2 p31(a[2],a[1],ns0,o[1]);
mux2 p32(a[1],a[0],ns0,o[0]);







mux2 q1(0,o[31],ns1,o1[31]);
mux2 q2(0,o[30],ns1,o1[30]);
mux2 q3(o[31],o[29],ns1,o1[29]);
mux2 q4(o[29],o[28],ns1,o1[28]);
mux2 q5(o[28],o[27],ns1,o1[27]);
mux2 q6(o[27],o[26],ns1,o1[26]);
mux2 q7(o[26],o[25],ns1,o1[25]);
mux2 q8(o[25],o[24],ns1,o1[24]);
mux2 q9(o[24],o[23],ns1,o1[23]);
mux2 q10(o[23],o[22],ns1,o1[22]);
mux2 q11(o[22],o[21],ns1,o1[21]);
mux2 q12(o[21],o[20],ns1,o1[20]);
mux2 q13(o[20],o[19],ns1,o1[19]);
mux2 q14(o[19],o[18],ns1,o1[18]);
mux2 q15(o[18],o[17],ns1,o1[17]);
mux2 q16(o[17],o[16],ns1,o1[16]);
mux2 q17(o[16],o[15],ns1,o1[15]);
mux2 q18(o[15],o[14],ns1,o1[14]);
mux2 q19(o[14],o[13],ns1,o1[13]);
mux2 q20(o[13],o[12],ns1,o1[12]);
mux2 q21(o[12],o[11],ns1,o1[11]);
mux2 q22(o[11],o[10],ns1,o1[10]);
mux2 q23(o[10],o[9],ns1,o1[9]);
mux2 q24(o[9],o[8],ns1,o1[8]);
mux2 q25(o[8],o[7],ns1,o1[7]);
mux2 q26(o[7],o[6],ns1,o1[6]);
mux2 q27(o[6],o[5],ns1,o1[5]);
mux2 q28(o[5],o[4],ns1,o1[4]);
mux2 q29(o[4],o[3],ns1,o1[3]);
mux2 q30(o[3],o[2],ns1,o1[2]);
mux2 q31(o[2],o[1],ns1,o1[1]);
mux2 q32(o[1],o[0],ns1,o1[0]);







mux2 u1(0,o1[31],ns2,o2[31]);
mux2 u2(0,o1[30],ns2,o2[30]);
mux2 u3(0,o1[29],ns2,o2[29]);
mux2 u4(0,o1[28],ns2,o2[28]);
mux2 u5(o1[31],o1[27],ns2,o2[27]);
mux2 u6(o1[30],o1[26],ns2,o2[26]);
mux2 u7(o1[29],o1[25],ns2,o2[25]);
mux2 u8(o1[28],o1[24],ns2,o2[24]);
mux2 u9(o1[27],o1[23],ns2,o2[23]);
mux2 u10(o1[26],o1[22],ns2,o2[22]);
mux2 u11(o1[25],o1[21],ns2,o2[21]);
mux2 u12(o1[24],o1[20],ns2,o2[20]);
mux2 u13(o1[23],o1[19],ns2,o2[19]);
mux2 u14(o1[22],o1[18],ns2,o2[18]);
mux2 u15(o1[21],o1[17],ns2,o2[17]);
mux2 u16(o1[20],o1[16],ns2,o2[16]);
mux2 u17(o1[19],o1[15],ns2,o2[15]);
mux2 u18(o1[18],o1[14],ns2,o2[14]);
mux2 u19(o1[17],o1[13],ns2,o2[13]);
mux2 u20(o1[16],o1[12],ns2,o2[12]);
mux2 u21(o1[15],o1[11],ns2,o2[11]);
mux2 u22(o1[14],o1[10],ns2,o2[10]);
mux2 u23(o1[13],o1[9],ns2,o2[9]);
mux2 u24(o1[12],o1[8],ns2,o2[8]);
mux2 u25(o1[11],o1[7],ns2,o2[7]);
mux2 u26(o1[10],o1[6],ns2,o2[6]);
mux2 u27(o1[9],o1[5],ns2,o2[5]);
mux2 u28(o1[8],o1[4],ns2,o2[4]);
mux2 u29(o1[7],o1[3],ns2,o2[3]);
mux2 u30(o1[6],o1[2],ns2,o2[2]);
mux2 u31(o1[5],o1[1],ns2,o2[1]);
mux2 u32(o1[4],o1[0],ns2,o2[0]);





mux2 ss1(0,o2[31],ns3,o3[31]);
mux2 ss2(0,o2[30],ns3,o3[30]);
mux2 ss3(0,o2[29],ns3,o3[29]);
mux2 ss4(0,o2[28],ns3,o3[28]);
mux2 ss5(0,o2[27],ns3,o3[27]);
mux2 ss6(0,o2[26],ns3,o3[26]);
mux2 ss7(0,o2[25],ns3,o3[25]);
mux2 ss8(0,o2[24],ns3,o3[24]);
mux2 ss9(o2[31],o2[23],ns3,o3[23]);
mux2 ss10(o2[30],o2[22],ns3,o3[22]);
mux2 ss11(o2[29],o2[21],ns3,o3[21]);
mux2 ss12(o2[28],o2[20],ns3,o3[20]);
mux2 ss13(o2[27],o2[19],ns3,o3[19]);
mux2 ss14(o2[26],o2[18],ns3,o3[18]);
mux2 ss15(o2[25],o2[17],ns3,o3[17]);
mux2 ss16(o2[24],o2[16],ns3,o3[16]);
mux2 ss17(o2[23],o2[15],ns3,o3[15]);
mux2 ss18(o2[22],o2[14],ns3,o3[14]);
mux2 ss19(o2[21],o2[13],ns3,o3[13]);
mux2 ss20(o2[20],o2[12],ns3,o3[12]);
mux2 ss21(o2[19],o2[11],ns3,o3[11]);
mux2 ss22(o2[18],o2[10],ns3,o3[10]);
mux2 ss23(o2[17],o2[9],ns3,o3[9]);
mux2 ss24(o2[16],o2[8],ns3,o3[8]);
mux2 ss25(o2[15],o2[7],ns3,o3[7]);
mux2 ss26(o2[14],o2[6],ns3,o3[6]);
mux2 ss27(o2[13],o2[5],ns3,o3[5]);
mux2 ss28(o2[12],o2[4],ns3,o3[4]);
mux2 ss29(o2[11],o2[3],ns3,o3[3]);
mux2 ss30(o2[10],o2[2],ns3,o3[2]);
mux2 ss31(o2[9],o2[1],ns3,o3[1]);
mux2 ss32(o2[8],o2[0],ns3,o3[0]);




mux2 w1(0,o3[31],ns4,out[31]);
mux2 w2(0,o3[30],ns4,out[30]);
mux2 w3(0,o3[29],ns4,out[29]);
mux2 w4(0,o3[28],ns4,out[28]);
mux2 w5(0,o3[27],ns4,out[27]);
mux2 w6(0,o3[26],ns4,out[26]);
mux2 w7(0,o3[25],ns4,out[25]);
mux2 w8(0,o3[24],ns4,out[24]);
mux2 w9(0,o3[23],ns4,out[23]);
mux2 w10(0,o3[22],ns4,out[22]);
mux2 w11(0,o3[21],ns4,out[21]);
mux2 w12(0,o3[20],ns4,out[20]);
mux2 w13(0,o3[19],ns4,out[19]);
mux2 w14(0,o3[18],ns4,out[18]);
mux2 w15(0,o3[17],ns4,out[17]);
mux2 w16(0,o3[16],ns4,out[16]);
mux2 w17(o3[31],o3[15],ns4,out[15]);
mux2 w18(o3[30],o3[14],ns4,out[14]);
mux2 w19(o3[29],o3[13],ns4,out[13]);
mux2 w20(o3[28],o3[12],ns4,out[12]);
mux2 w21(o3[27],o3[11],ns4,out[11]);
mux2 w22(o3[26],o3[10],ns4,out[10]);
mux2 w23(o3[25],o3[9],ns4,out[9]);
mux2 w24(o3[24],o3[8],ns4,out[8]);
mux2 w25(o3[23],o3[7],ns4,out[7]);
mux2 w26(o3[22],o3[6],ns4,out[6]);
mux2 w27(o3[21],o3[5],ns4,out[5]);
mux2 w28(o3[20],o3[4],ns4,out[4]);
mux2 w29(o3[19],o3[3],ns4,out[3]);
mux2 w30(o3[18],o3[2],ns4,out[2]);
mux2 w31(o3[17],o3[1],ns4,out[1]);
mux2 w32(o3[16],o3[0],ns4,out[0]);


endmodule



module mantissacomparator(ex,ey,low,high,same);
input [31:0]ex,ey;
output low,high,same;
wire [31:0]lcheck,eynot,sum,sum1;
wire cout,cout1;

assign eynot=~ey;
assign lcheck=(ex&ey)|(~ex&~ey);
assign same=lcheck[0]&lcheck[1]&lcheck[2]&lcheck[3]&lcheck[4]&lcheck[5]&lcheck[6]&lcheck[7]&lcheck[8]&lcheck[9]&lcheck[10]&lcheck[11]&lcheck[12]&lcheck[13]&lcheck[14]&lcheck[15]&lcheck[16]&lcheck[17]&lcheck[18]&lcheck[19]&lcheck[20]&lcheck[21]&lcheck[22]&lcheck[23]&lcheck[24]&lcheck[25]&lcheck[26]&lcheck[27]&lcheck[28]&lcheck[29]&lcheck[30]&lcheck[31];

cla32 w1(eynot,00000000,1,sum,cout);
cla32 w2(ex,sum,0,sum1,cout1);
assign high=(cout1)&1&(~same);
assign low=(~cout1)&1;

endmodule


module prio_enco_8x3( d_in,d_out);

   output [4:0] d_out;
   input [31:0] d_in ;

 assign d_out = (d_in[31] ==1'b1 ) ? 5'b11111:
		(d_in[30] ==1'b1 ) ? 5'b11110:
		(d_in[29] ==1'b1 ) ? 5'b11101:
		(d_in[28] ==1'b1) ?  5'b11100:
		(d_in[27] ==1'b1) ?  5'b11011:
		(d_in[26] ==1'b1) ?  5'b11010:
               	(d_in[25] ==1'b1) ?  5'b11001:
		(d_in[24] ==1'b1) ?  5'b11000:
		(d_in[23] ==1'b1) ?  5'b10111:
		(d_in[22] ==1'b1) ?  5'b10110:
		(d_in[21] ==1'b1) ?  5'b10101:
		(d_in[20] ==1'b1) ?  5'b10100:
		(d_in[19] ==1'b1) ?  5'b10011:
		(d_in[18] ==1'b1) ?  5'b10010:
		(d_in[17] ==1'b1) ?  5'b10001:
		(d_in[16] ==1'b1) ?  5'b10000:
		(d_in[15] ==1'b1) ?  5'b01111:
		(d_in[14] ==1'b1) ?  5'b01110:
		(d_in[13] ==1'b1) ?  5'b01101:
		(d_in[12] ==1'b1) ?  5'b01100:
		(d_in[11] ==1'b1) ?  5'b01011:
		(d_in[10] ==1'b1) ?  5'b01010:
		(d_in[09] ==1'b1) ?  5'b01001:
		(d_in[8] ==1'b1) ?   5'b01000:
		(d_in[7] ==1'b1) ?   5'b00111:
		(d_in[6] ==1'b1) ?   5'b00110:
		(d_in[5] ==1'b1) ?   5'b00101:
		(d_in[4] ==1'b1) ?   5'b00100:
		(d_in[3] ==1'b1) ?   5'b00011:
		(d_in[2] ==1'b1) ?   5'b00010:
		(d_in[1] ==1'b1) ?   5'b00001:
               (d_in[0] ==1'b1) ?    5'b00000: 5'bxxx;

endmodule

module updation (outmantissa,finalexponent,finalmanti,finexponent);
input [31:0]outmantissa;
input [7:0]finalexponent;
output reg [22:0]finalmanti;
output [7:0]finexponent;
wire [4:0]key;
wire dffc;
wire [7:0]diff,diffnot,diffs,b;
reg [7:0]b1;

prio_enco_8x3 l6(outmantissa,key);
assign diff=(~key)+5'b10111+1;
assign diff[7:6]=0;

assign diffnot=~diff;
assign b=1;

cladder8 w1(diffnot,00000000,1,diffs,diffc);

always @(*)
begin
if(outmantissa[24]==1)
begin
b1<=b;
finalmanti<=outmantissa[23:1];
end

else
begin
b1<=diffs;
finalmanti<=outmantissa[22:0];
 
end
end
cladder8 w2(finalexponent,b1,0,finexponent,checkout);
endmodule
