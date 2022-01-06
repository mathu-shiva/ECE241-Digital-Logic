module part3(clock, reset, ParallelLoadn, RotateRight, ASRight, Data_IN, Q);
input ASRight, RotateRight, ParallelLoadn, clock, reset;
input [7:0] Data_IN;
output [7:0] Q;

wire [7:0] Q_out;
assign Q = Q_out;

flipflop F7(.clock(clock), .reset(reset), .data(Data_IN[7]), .loadn(ParallelLoadn), .loadleft(RotateRight), .left(Q[0]), .right(Q[6]), .asright(ASRight), .Q(Q[7]));
flipflop F6(.clock(clock), .reset(reset), .data(Data_IN[6]), .loadn(ParallelLoadn), .loadleft(RotateRight), .left(Q[7]), .right(Q[5]), .asright(Q[7]), .Q(Q[6]));
flipflop F5(.clock(clock), .reset(reset), .data(Data_IN[5]), .loadn(ParallelLoadn), .loadleft(RotateRight), .left(Q[6]), .right(Q[4]), .asright(Q[7]), .Q(Q[5]));
flipflop F4(.clock(clock), .reset(reset), .data(Data_IN[4]), .loadn(ParallelLoadn), .loadleft(RotateRight), .left(Q[5]), .right(Q[3]), .asright(Q[7]), .Q(Q[4]));
flipflop F3(.clock(clock), .reset(reset), .data(Data_IN[3]), .loadn(ParallelLoadn), .loadleft(RotateRight), .left(Q[4]), .right(Q[2]), .asright(Q[7]), .Q(Q[3]));
flipflop F2(.clock(clock), .reset(reset), .data(Data_IN[2]), .loadn(ParallelLoadn), .loadleft(RotateRight), .left(Q[3]), .right(Q[1]), .asright(Q[7]), .Q(Q[2]));
flipflop F1(.clock(clock), .reset(reset), .data(Data_IN[1]), .loadn(ParallelLoadn), .loadleft(RotateRight), .left(Q[2]), .right(Q[0]), .asright(Q[7]), .Q(Q[1]));
flipflop F0(.clock(clock), .reset(reset), .data(Data_IN[0]), .loadn(ParallelLoadn), .loadleft(RotateRight), .left(Q[1]), .right(Q[7]), .asright(Q[7]), .Q(Q[0]));

endmodule

module flipflop (clock, reset, data, loadn, loadleft, left, right, asright, Q);
input clock, reset, data, loadn, loadleft, left, right, asright;
output reg Q;

wire A, B;

mux2to1 M1 (.y(right), .x(left), .s(loadleft), .m(A));
mux2to1 M2(.y(data), .x(A), .s(loadn), .m(B));

always @ (posedge clock)
begin

if(reset)
Q <= 1'b0;
else if (asright == 1'b1 && loadleft == 1'b1)
Q <= 1'b0;
else
Q <= B;

end
endmodule


module mux2to1 (y, x, s, m);
input y, x, s;
output m;

assign m = s ? x : y;

endmodule
