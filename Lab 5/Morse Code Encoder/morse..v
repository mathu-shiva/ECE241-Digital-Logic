module part3(ClockIn, Resetn, Start, Letter, DotDashOut);
input ClockIn, Resetn, Start;
input [2:0] Letter;
output DotDashOut;

parameter [11:0] A_=12'b000000111010, B_=12'b001010101110, C_=12'b101110101110, D_=12'b000010101110, E_=12'b000000000010, F_=12'b001011101010, G_=12'b001011101110, H_=12'b000010101010;
reg[7:0] R = 8'b11111001; //max number of cycles of 249
wire W2;
reg [11:0] W3; //Letter numbers
wire [7:0] W1;

RateDivider R1(R, ClockIn, W1); //calling module
assign W2 = ~|W1;

always @ (*)
begin
case(Letter[2:0])
3'b000:  W3 <= A_; //A
3'b001:  W3 <= B_; //B
3'b010:  W3 <= C_; //C
3'b011:  W3 <= D_; //D
3'b100:  W3 <= E_; //E
3'b101:  W3 <= F_; //F
3'b110:  W3 <= G_; //G
3'b111:  W3 <= H_; //H
endcase
end

ShiftRegister S(ClockIn, W2, Resetn, Start, W3, DotDashOut); //calling module
endmodule

	
module RateDivider(D, clock, Q);
input [7:0] D; //max cycles value
input clock;
output [7:0] Q;
reg [7:0] M = 8'b00000000;
assign Q = M;

always @ (posedge clock)
begin
if (M == D || M > D) //If we have counted lower than zero
M <= 0;
else
M <= M + 1; //Count down one cycle
end
endmodule

module ShiftRegister(clock, enable, resetn, loadn, data, out);
input clock, enable, resetn, loadn;
input [11:0] data;
output out;

reg [11:0] Q = {12{1'b0}};
always @(posedge clock)
begin
if (resetn == 0) //If active low, bring to zero
Q <= 0;
else if (loadn == 1)//If start is high, we load in the new data
begin
Q <= data;
end
else if(enable) //If enable is true, the shift register goes into action
begin
Q[11] <= Q[0];
Q[10] <= Q[11];
Q[9] <= Q[10];
Q[8] <= Q[9];
Q[7] <= Q[8];
Q[6] <= Q[7];
Q[5] <= Q[6];
Q[4] <= Q[5];
Q[3] <= Q[4];
Q[2] <= Q[3];
Q[1] <= Q[2];
Q[0] <= Q[1];
end
end
assign out = Q[0]; //outputting shifted bit
endmodule
