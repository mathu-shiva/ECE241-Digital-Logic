module part1(Clock, Enable, Clear_b, CounterValue);
input Clock, Enable, Clear_b;
output [7:0] CounterValue;
wire W1, W2, W3, W4, W5, W6, W7, W8, W9, W10, W11, W12, W13, W14, W15, W16, W17;

assign W1 = Enable & W10;
assign W2 = W1 & W11;
assign W3 = W2 & W12;
assign W4 = W3 & W13;
assign W5 = W4 & W14;
assign W6 = W5 & W15;
assign W7 = W6 & W16;
assign W8 = W7 & W17;

TFlipFlop T1(.T(Enable),.clock(Clock),.reset(Clear_b),.Q(W10));
TFlipFlop T2(.T(W1),.clock(Clock),.reset(Clear_b),.Q(W11));
TFlipFlop T3(.T(W2),.clock(Clock),.reset(Clear_b),.Q(W12));
TFlipFlop T4(.T(W3),.clock(Clock),.reset(Clear_b),.Q(W13));
TFlipFlop T5(.T(W4),.clock(Clock),.reset(Clear_b),.Q(W14));
TFlipFlop T6(.T(W5),.clock(Clock),.reset(Clear_b),.Q(W15));
TFlipFlop T7(.T(W6),.clock(Clock),.reset(Clear_b),.Q(W16));
TFlipFlop T8(.T(W7),.clock(Clock),.reset(Clear_b),.Q(W17));

assign CounterValue[0] = W10;
assign CounterValue[1] = W11;
assign CounterValue[2] = W12;
assign CounterValue[3] = W13;
assign CounterValue[4] = W14;
assign CounterValue[5] = W15;
assign CounterValue[6] = W16;
assign CounterValue[7] = W17;

endmodule

module TFlipFlop(T, clock, reset, Q);
input T, clock, reset;
output reg Q;

	always @(posedge clock, negedge reset)
	begin

		if(reset == 0)
			Q <= 1'b0;

		else if (T)
			Q <= ~Q;
	end

endmodule
