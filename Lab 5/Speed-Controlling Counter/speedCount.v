module part2(ClockIn, Reset, Speed, CounterValue);

input ClockIn;
input Reset;
input [1:0] Speed;
output [3:0] CounterValue;
wire enable;
wire [10:0] bound, counter;
//wire [26:0] bound, counter;

speeder S (.speed(Speed),.bound(bound)); //Instantation with the input speed and maximum number of cycles
RateDivider R (.clock(ClockIn),.bound(bound),.enable(enable),.counter(counter)); /*Instantiation with clock, max cycles, 
the enable signal, and also the counter */
fourbitcounter F (.enable(enable),.clock(ClockIn),.clear_b(Reset),.Q(CounterValue)); /*Instantion of the four bit counter with
the enable signal, the clock, the asynchronous active high reset, and the value of the counter */

endmodule

/*
module speeder (speed, bound); //module to pick a speed and also the upper bound of the number of cycles
input [1:0] speed;
output reg [26:0] bound;

always @(*)
case(speed[1:0]) //four possible speed choices
2'b00: bound = 27'b0; //Full speed
2'b01: bound = 27'010111110101111000001111111b; //1 Hz speed //Binary represents 50,000,000/1 which is 50,000,000 cycles (49,999,999)
2'b10: bound = 27'101111101011110000011111111b; //0.5 Hz Speed //Binary represents 50,000,000/0.5 which is 100,000,000 cycles (99,999,999)
2'b11: bound = 27'1011111010111100000111111111b; //0.25 Hz speed //Binary represents 50,000,000/0.25 which is 200,000,000 cycles (199,999,999)
endcase

endmodule
*/

module speeder (speed, bound); //module to pick a speed and also the upper bound of the number of cycles
input [1:0] speed;
output reg [10:0] bound;

always @(*)
case(speed[1:0]) //four possible speed choices
2'b00: bound = 11'b00000000000; //Full speed
2'b01: bound = 11'b00111110011; //1 Hz speed //Binary represents 500/1 which is 500 cycles (499)
2'b10: bound = 11'b01111100111; //0.5 Hz Speed //Binary represents 500/0.5 which is 1000 cycles (999)
2'b11: bound = 11'b11111001111; //0.25 Hz speed //Binary represents 500/0.25 which is 2000 cycles (1999)
endcase

endmodule


module RateDivider(clock, bound, enable, counter);
input clock;
input [10:0] bound; 
//input [26:0] bound;
output reg enable;
output reg [10:0] counter;
//output reg [26:0] counter;

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

/*
always @(posedge clock) //at the positive edge of the clock
begin
	if (counter === 26'bx)
	begin
		counter <= 27'b0;
	end 
	else if (counter == bound) //If we hit the number of maximum cycles, the counter returns to zero
	begin
		enable= 1'b1; //generating an enable pulse once we hit zero (we hit zero when a bound is reached)
		counter <= 27'b0; //counter also goes to zero
	end
	else
	begin
		enable = 1'b0; //enable is zero because we have not reached a bound or the maximum number of cycles
		counter <= counter + 1 ; //increase the counter
	end
end
*/
		
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



