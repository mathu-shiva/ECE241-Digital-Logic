module part2(CLOCK_50, SW, HEX0);
//SW[1:0] speed
//SW[9] reset
//clock is CLOCK50

output [3:0] CounterValue;
wire enable;
wire [10:0] bound, counter;

input [9:0] SW;
input CLOCK_50;
output [6:0] HEX0;

reg Reset;
reg [1:0] Speed;

always @(*)
begin
	Reset = SW[9];
	Speed = SW[1:0];
end

speeder S (.speed(Speed),.bound(bound)); //Instantation with the input speed and maximum number of cycles
RateDivider R (.clock(CLOCK_50),.bound(bound),.enable(enable),.counter(counter)); /*Instantiation with clock, max cycles, 
the enable signal, and also the counter */
fourbitcounter F (.enable(enable),.clock(CLOCK_50),.clear_b(Reset),.Q(CounterValue)); /*Instantion of the four bit counter with
the enable signal, the clock, the asynchronous active high reset, and the value of the counter */
hex_decoder H (.c(CounterValue),.display(HEX0));

endmodule

module speeder (SW, bound); //module to pick a speed and also the upper bound of the number of cycles
input [1:0] SW;
output reg [10:0] bound;

always @(*)
case(SW[1:0]) //four possible speed choices
2'b00: bound = 11'b00000000000; //Full speed
2'b01: bound = 11'b00111110011; //1 Hz speed //Binary represents 500/1 which is 500 cycles (499)
2'b10: bound = 11'b01111100111; //0.5 Hz Speed //Binary represents 500/0.5 which is 1000 cycles (999)
2'b11: bound = 11'b11111001111; //0.25 Hz speed //Binary represents 500/0.25 which is 2000 cycles (1999)
endcase

endmodule


module RateDivider(clock, bound, enable, counter);
input clock;
input [10:0] bound; 
output reg enable;
output reg [10:0] counter;

always @(posedge clock) //at the positive edge of the clock
begin
	if (counter === 11'bx)
	begin
		counter <= 11'b00000000000;
	end 
	else if (counter == bound) //If we hit the number of maximum cycles, the counter returns to zero
	begin
		enable= 1'b1; //generating an enable pulse once we hit zero (we hit zero when a bound is reached)
		counter <= 11'b00000000000; //counter also goes to zero
	end
	else
	begin
		enable = 1'b0; //enable is zero because we have not reached a bound or the maximum number of cycles
		counter <= counter + 1 ; //increase the counter
	end
end
		
endmodule 


module fourbitcounter (enable, clock, clear_b, Q);
input enable, clock, clear_b;
output reg [3:0] Q;

always @(posedge clock) //at the positive edge of the clock
	begin
		if (clear_b == 1'b1) //synchronous active high reset
		begin
			Q <= 4'b0000; //reset value to zero
		end
		else if (Q == 4'b1111) //when reached the maximum value 
		begin
			Q <= 4'b000; //reset to zero
		end
		else if (enable == 1'b1) //if enable is high
		begin
			Q <= Q + 1; //add, count up
		end
	end
	
endmodule

module hex_decoder (c, display);
input [3:0] c;
output [6:0] display;

segment U0 (.c3(c[3]),.c2(c[2]),.c1(c[1]),.c0(c[0]),.seg6(display[6]),.seg5(display[5]),.seg4(display[4]),.seg3(display[3]),.seg2(display[2]),
.seg1(display[1]),.seg0(display[0]));

endmodule

module segment (c3,c2,c1,c0,seg0,seg1,seg2,seg3,seg4,seg5,seg6);
input c3, c2, c1, c0;
output seg0, seg1, seg2, seg3, seg4, seg5, seg6;
assign seg0 = ((!c3&!c2&!c1&c0)|(!c3&c2&!c1&!c0)|(c3&!c2&c1&c0)|(c3&c2&!c1&c0));
assign seg1 = ((!c3&c2&!c1&c0)|(!c3&c2&c1&!c0)|(c3&!c2&c1&c0)|(c3&c2&!c1&!c0)|(c3&c2&c1&!c0)|(c3&c2&c1&c0));
assign seg2 = ((!c3&!c2&c1&!c0)|(c3&c2&!c1&!c0)|(c3&c2&c1&!c0)|(c3&c2&c1&c0));
assign seg3 = ((!c3&!c2&!c1&c0)|(!c3&c2&!c1&!c0)|(!c3&c2&c1&c0)|(c3&!c2&c1&!c0)|(c3&c2&c1&c0));
assign seg4 = ((!c3&!c2&!c1&c0)|(!c3&!c2&c1&c0)|(!c3&c2&!c1&!c0)|(!c3&c2&!c1&c0)|(!c3&c2&c1&c0)|(c3&!c2&!c1&c0));
assign seg5 = ((!c3&!c2&!c1&c0)|(!c3&!c2&c1&!c0)|(!c3&!c2&c1&c0)|(!c3&c2&c1&c0)|(c3&c2&!c1&c0));
assign seg6 = ((!c3&!c2&!c1&!c0)|(!c3&!c2&!c1&c0)|(!c3&c2&c1&c0)|(c3&c2&!c1&!c0));


endmodule


