
module main_memory(in,out);
input[7:0] in;
output out;
reg[7:0] mem[63:0];

mem[0] = 8'd0;
mem[1] = 8'd1;
mem[2] = 8'd4;
mem[3] = 8'd9;
mem[4] = 8'd16;
mem[5] = 8'd25;
mem[6] = 8'd36;
mem[7] = 8'd49;
mem[8] = 8'd64;
mem[9] = 8'd81;
mem[10] = 8'd100;
mem[11] = 8'd121;
mem[12] = 8'd144;
mem[13] = 8'd169;
mem[14] = 8'd196;
mem[15] = 8'd225;
mem[16] = 8'd256;
mem[17] = 8'd289;
mem[18] = 8'd324;
mem[19] = 8'd361;
mem[20] = 8'd400;
mem[21] = 8'd441;
mem[22] = 8'd484;
mem[23] = 8'd529;
mem[24] = 8'd576;
mem[25] = 8'd625;
mem[26] = 8'd676;
mem[27] = 8'd729;
mem[28] = 8'd784;
mem[29] = 8'd841;
mem[30] = 8'd900;
mem[31] = 8'd961;
mem[32] = 8'd1024;
mem[33] = 8'd1089;
mem[34] = 8'd1156;
mem[35] = 8'd1225;
mem[36] = 8'd1296;
mem[37] = 8'd1369;
mem[38] = 8'd1444;
mem[39] = 8'd1521;
mem[40] = 8'd1600;
mem[41] = 8'd1681;
mem[42] = 8'd1764;
mem[43] = 8'd1849;
mem[44] = 8'd1936;
mem[45] = 8'd2025;
mem[46] = 8'd2116;
mem[47] = 8'd2209;
mem[48] = 8'd2304;
mem[49] = 8'd2401;
mem[50] = 8'd2500;
mem[51] = 8'd2601;
mem[52] = 8'd2704;
mem[53] = 8'd2809;
mem[54] = 8'd2916;
mem[55] = 8'd3025;
mem[56] = 8'd3136;
mem[57] = 8'd3249;
mem[58] = 8'd3364;
mem[59] = 8'd3481;
mem[60] = 8'd3600;
mem[61] = 8'd3721;
mem[62] = 8'd3844;
mem[63] = 8'd3969;



assign addr1[5:2] = in[7:2];
assign addr2[5:2] = in[7:2];
assign addr3[5:2] = in[7:2];
assign addr4[5:2] = in[7:2];

assign addr1[1:0] = 2'b00;
assign addr2[1:0] = 2'b01;
assign addr3[1:0] = 2'b10;
assign addr4[1:0] = 2'b11;

always @(negedge)