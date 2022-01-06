module hex_decoder (c, display);
input [3:0] c;
output [6:0] display;

segment U0 (
.c3(c[3]),
.c2(c[2]),
.c1(c[1]),
.c0(c[0]),
.seg6(display[6]),
.seg5(display[5]),
.seg4(display[4]),
.seg3(display[3]),
.seg2(display[2]),
.seg1(display[1]),
.seg0(display[0])
);

endmodule

module segment (c3,c2,c1,c0,seg0,seg1,seg2,seg3,seg4,seg5,seg6);
input c3;
input c2;
input c1;
input c0;
output seg0;
output seg1;
output seg2;
output seg3;
output seg4;
output seg5;
output seg6;

assign seg0 = ((!c3&!c2&!c1&c0)|(!c3&c2&!c1&!c0)|(c3&!c2&c1&c0)|(c3&c2&!c1&c0));
assign seg1 = ((!c3&c2&!c1&c0)|(!c3&c2&c1&!c0)|(c3&!c2&c1&c0)|(c3&c2&!c1&!c0)|(c3&c2&c1&!c0)|(c3&c2&c1&c0));
assign seg2 = ((!c3&!c2&c1&!c0)|(c3&c2&!c1&!c0)|(c3&c2&c1&!c0)|(c3&c2&c1&c0));
assign seg3 = ((!c3&!c2&!c1&c0)|(!c3&c2&!c1&!c0)|(!c3&c2&c1&c0)|(c3&!c2&c1&!c0)|(c3&c2&c1&c0));
assign seg4 = ((!c3&!c2&!c1&c0)|(!c3&!c2&c1&c0)|(!c3&c2&!c1&!c0)|(!c3&c2&!c1&c0)|(!c3&c2&c1&c0)|(c3&!c2&!c1&c0));
assign seg5 = ((!c3&!c2&!c1&c0)|(!c3&!c2&c1&!c0)|(!c3&!c2&c1&c0)|(!c3&c2&c1&c0)|(c3&c2&!c1&c0));
assign seg6 = ((!c3&!c2&!c1&!c0)|(!c3&!c2&!c1&c0)|(!c3&c2&c1&c0)|(c3&c2&!c1&!c0));


endmodule
