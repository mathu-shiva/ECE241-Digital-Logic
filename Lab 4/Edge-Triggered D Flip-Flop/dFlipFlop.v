`timescale 1ns / 1ns

module part2(Clock, Reset_b, Data, Function, ALUout);
input Clock; //Used in always statement for register
input Reset_b; //Used for the register
input [3:0] Data; //Kind of like our A in Lab 3 Part 3
input [2:0] Function; //Used for our ALU
output reg [7:0] ALUout; //ALUout [3:0] is going to be the input signal B

wire [7:0] registerWire;

ALU A1(.A(Data), .B(registerWire[3:0]), .Function(Function), .regState(registerWire), .ALUout(ALUout));
register R1(.registerInput(ALUout), .reset(Reset_b), .clock(Clock), .regState(registerWire));

endmodule

module register (registerInput, reset, clock, regState);
input [7:0] registerInput;
input reset, clock;
output reg [7:0] regState;

always @(posedge clock)
begin
if(reset == 1'b0)
regState <= 8'b00000000;
else
regState <= registerInput;

end

endmodule

module ALU (A, B, Function, regState, ALUout);
input [3:0] A, B;
input [2:0] Function;
input [7:0] regState;
output [7:0] ALUout;

wire [7:0] W0, W1, W2, W3, W4, W5, W6, W7;

//CASE 0 //CORRECT FOR LAB 4
RA C1(.a(A),.b(B),.c_in(1'b0),.s(W0[3:0]),.c_out(W0[4]));
assign W0[7:5] = 3'b000; 

//CASE 1 //CORRECT FOR LAB 4
assign W1[4:0] = (A + B);
assign W1[7:5] = 3'b000;

//CASE 2 //CORRECT FOR LAB 4
assign W2 = {B[3],B[3],B[3],B[3],B};

//CASE 3 //CORRECT FOR LAB 4
assign W3 = ((|A || |B) ? (8'b00000001) : (8'b00000000));

//CASE 4 //CORRECT FOR LAB 4
assign W4 = ((&A && &B) ? (8'b00000001) : (8'b00000000));

//CASE 5
assign W5 = B << A;

//CASE 6
assign W6 = (A*B);

//CASE 7
assign W7 = regState;

mux7to1 M1(.out0(W0), .out1(W1), .out2(W2), .out3(W3), .out4(W4), .out5(W5), .out6(W6), .out7(W7), .MuxSelect(Function), .muxOut(ALUout));

endmodule

module mux7to1 (input [7:0] out0, out1, out2, out3, out4, out5, out6, out7,  
input [2:0] MuxSelect, output reg [7:0] muxOut);

always @(*)
case (~MuxSelect[2:0])

3'b000: muxOut = out0;
3'b001: muxOut = out1;
3'b010: muxOut = out2; 
3'b011: muxOut = out3; 
3'b100: muxOut = out4; 
3'b101: muxOut = out5; 
3'b110: muxOut = out6;
3'b111: muxOut = out7; 
default: muxOut = 8'b00000000; 
					
endcase
				
endmodule 

//PART 2 RIPPLE ADDER MODULE
module RA (a, b, c_in, s, c_out);
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

