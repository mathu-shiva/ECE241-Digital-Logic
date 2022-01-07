module part3(iColour,iResetn,iClock,oX,oY,oColour,oPlot);
   input wire [2:0] iColour;
   input wire 	    iResetn;
   input wire 	    iClock;
   output wire [7:0] oX;         // VGA pixel coordinates
   output wire [6:0] oY;
   
   output wire [2:0] oColour;     // VGA pixel colour (0-7)
   output wire 	     oPlot;       // Pixel drawn enable
wire[2:0] colour;
wire startButton, delete, enable, rst;

wire[7:0] XCounter;
wire[6:0] YCounter;
wire[5:0] plotCounter;
wire[25:0] frequency;

   parameter
     X_SCREENSIZE = 160,  // X screen width for starting resolution and fake_fpga
     Y_SCREENSIZE = 120,  // Y screen height for starting resolution and fake_fpga
     CLOCKS_PER_SECOND = 5000, // 5 KHZ for fake_fpga
     X_BOXSIZE = 8'd4,   // Box X dimension
     Y_BOXSIZE = 7'd4,   // Box Y dimension
     X_MAX = X_SCREENSIZE - 1 - X_BOXSIZE, // 0-based and account for box width
     Y_MAX = Y_SCREENSIZE - 1 - Y_BOXSIZE,
     PULSES_PER_SIXTIETH_SECOND = CLOCKS_PER_SECOND / 60
	       ;

/*
vga_adapter VGA(.resetn(iResetn),.clock(iClock),.colour(colour),.x(oX),.y(oY),.plot(startButton),.VGA_R(VGA_R),.VGA_G(VGA_G),
		.VGA_B(VGA_B),.VGA_HS(VGA_HS),.VGA_BLANK(VGA_BLANK_N),.VGA_SYNC(VGA_SYNC_N),.VGA_CLK(VGA_CLK));
defparam VGA.RESOLUTION = "160x120";
defparam VGA.MONOCHROME = "FALSE";
defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
defparam VGA.BACKGROUND_IMAGE = "black.mif";
*/

controlPath C(iClock, iResetn, XCounter, YCounter, plotCounter, frequency, startButton, delete, update, enable, rst);
dataPath D(iClock, iResetn, enable, startButton, delete, update, rst, iColour, oX, oY, colour, XCounter, YCounter, plotCounter, frequency);


endmodule // part3

module dataPath(clock, reset, enable, startButton, delete, update, rst, colour, x, y, COLOUR, XCounter, YCounter, plotCounter, frequency);
input clock, reset, enable, startButton, delete, update, rst;
input [2:0] colour;
output reg [7:0] x;
output reg [6:0] y;
output reg [2:0] COLOUR;
output reg [7:0] XCounter;
output reg [6:0] YCounter;
output reg [5:0] plotCounter;
output reg [25:0] frequency;
reg [7:0] xTemporary;
reg  [6:0] yTemporary;
reg oX, oY;

always @(posedge clock)
begin
	if(rst||!reset)
	begin
		x <= 8'd156;
		y <= 7'b0;
		xTemporary <= 8'd156;
		yTemporary <= 7'b0;
		XCounter <= 8'b0;
		YCounter <= 7'b0;
		plotCounter <= 6'b0;
		COLOUR <= 3'b0;
		frequency <= 25'd0;
		oX <= 1'b0;
		oY <= 1'b1;
	end

	else 
	begin
		if(delete & !enable)
		begin
			if(XCounter == 8'd160 && YCounter != 7'd120)
			begin
				XCounter <= 8'b0;
				YCounter <= YCounter + 1;
			end
			else
			begin
				XCounter <= XCounter + 1;
				x <= XCounter;
				y <= YCounter;
				COLOUR <= 3'b0;
			end
		end
		if(!delete) COLOUR <= colour;

		if(frequency == 26'd12499999) frequency <= 26'd0;
		else frequency <= frequency + 1;

 		if(enable)
		begin
			if(delete) COLOUR <= 0;
			else COLOUR <= colour;
			if(plotCounter == 6'b10000) plotCounter <= 6'b0;
			else plotCounter <= plotCounter + 1;
			x <= xTemporary + plotCounter[1:0];
			y <= yTemporary + plotCounter[3:2];
		end

		if(update)
		begin
			if(x == 8'b0) oX = 1;
			if(x == 8'd156) oX = 0;
			if(y == 7'b0) oY = 1;
			if(y == 7'd116) oY = 0;

			if(oX == 1'b1)
			begin
				x <= x + 1;
				xTemporary <= xTemporary + 1;
			end
			if(oX == 1'b0)
			begin
				x <= x - 1;
				xTemporary <= xTemporary - 1;
			end
			if(oY == 1'b1)
			begin
				y <= y + 1;
				yTemporary <= yTemporary + 1;
			end
			if(oY == 1'b0)
			begin
				y <= y - 1;
				yTemporary <= yTemporary - 1;
			end
		end
	end
end

endmodule

module controlPath(clock, reset, XCounter, YCounter, plotCounter, frequency, startButton, delete, update, enable, rst);
input clock, reset;
input[7:0] XCounter;
input[6:0] YCounter;
input[5:0] plotCounter;
input[25:0] frequency;
output reg startButton, delete, update, enable, rst;
reg[2:0] current, next;

always@(*)
begin

case(current)
3'b000: next = 3'b001;
3'b001: begin
	if(plotCounter <= 6'd15) next = 3'b001;
	else next = 3'b010;
end
3'b010: begin
	if(frequency < 26'd12499999) next = 3'b010;
	else next = 3'b011;
end
3'b011: begin
	if(plotCounter <= 6'd15) next = 3'b011;
end
3'b100: next = 3'b001;
3'b101: next = (XCounter == 8'd160 & YCounter == 7'd120) ? 3'b000 : 3'b101;
default: next = 3'b000;

endcase

end

always @(*)
begin

startButton = 1'b0;
update = 1'b0;
rst = 1'b0;
delete = 1'b0;
enable = 1'b0;

case(current)
3'b000: rst = 1'b1;
3'b001: begin
	startButton = 1'b1;
	delete = 1'b0;
	enable = 1'b1;
end
3'b011: begin
	startButton = 1'b1;
	delete = 1'b1;
	enable = 1'b1;
end
3'b100: update = 1'b1;
3'b101: begin
	delete = 1'b1;	
	startButton = 1'b1;
end

endcase
end

always @(posedge clock)
begin
	if(!reset) current <= 3'b101;
	else current <= next;
end

endmodule



























