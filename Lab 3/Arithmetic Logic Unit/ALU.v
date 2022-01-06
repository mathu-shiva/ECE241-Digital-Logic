`timescale 1ns / 1ns

module part3(A, B, Function, ALUout);
input [3:0] A;
input [3:0] B;
input [2:0] Function;
output reg [7:0] ALUout;

wire [7:0] W0, W1, W2, W3, W4, W5;

//CASE 0
part2 C1(.a(A),.b(B),.c_in(1'b0),.s(W0[3:0]),.c_out(W0[4]));
assign W0[7:5] = 3'b000;

//CASE 1
assign W1[4:0] = (A + B);
assign W1[7:5] = 3'b000;

//CASE 2
assign W2 = {B[3],B[3],B[3],B[3],B};

//CASE 3
assign W3 = ((|A || |B) ? (8'b00000001) : (8'b00000000));

//CASE 4
assign W4 = ((&A && &B) ? (8'b00000001) : (8'b00000000));

//CASE 5
assign W5[7:4] = A;
assign W5[3:0] = B;

always @(*)
begin
case(Function[2:0])

3'b000: ALUout = W0;
3'b001: ALUout = W1;
3'b010: ALUout = W2;
3'b011: ALUout = W3;
3'b100: ALUout = W4;
3'b101: ALUout = W5;
default: ALUout = 8'b0;

endcase
end
endmodule

//PART 1 7to1 MUX MODULE
module part1(MuxSelect, Input, Out);
input [6:0] Input;
input [2:0] MuxSelect;
output reg Out;

	always @(*)
	begin
		case(MuxSelect[2:0])
			3'b000: Out = Input[0];
			3'b001: Out = Input[1];
			3'b010: Out = Input[2];
			3'b011: Out = Input[3];
			3'b100: Out = Input[4];
			3'b101: Out = Input[5];
			3'b110: Out = Input[6];
			default: Out = 1'b0;
		endcase
	end
endmodule

//PART 2 RIPPLE ADDER MODULE
module part2 (a, b, c_in, s, c_out);
	input [3:0] a;
	input [3:0] b;	
	input c_in;
	output [3:0] s;
	output [3:0] c_out;

	fullAdder A1(.a(a[0]),.b(b[0]),.c_in(c_in),.s(s[0]),.c_out(c_out[0]));
	fullAdder A2(.a(a[1]),.b(b[1]),.c_in(c_out[0]),.s(s[1]),.c_out(c_out[1]));
	fullAdder A3(.a(a[2]),.b(b[2]),.c_in(c_out[1]),.s(s[2]),.c_out(c_out[2]));
	fullAdder A4(.a(a[3]),.b(b[3]),.c_in(c_out[2]),.s(s[3]),.c_out(c_out[3]));

endmodule


module fullAdder (a, b, c_in, s, c_out);
	input a;
	input b;
	input c_in;
	output s;
	output c_out;

	assign c_out = (a&b)|(c_in&a)|(c_in&b);
	assign s = c_in^a^b;
endmodule

//LAB 2 PART 3 HEXDECODER MODULE
module hexdecoder (c, display);
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
