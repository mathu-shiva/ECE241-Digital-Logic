module part2(iResetn,iPlotBox,iBlack,iColour,iLoadX,iXY_Coord,iClock,oX,oY,oColour,oPlot);
   parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;
   
   input wire iResetn, iPlotBox, iBlack, iLoadX;
   input wire [2:0] iColour;
   input wire [6:0] iXY_Coord;
   input wire iClock;
   output wire [7:0] oX;         // VGA pixel coordinates
   output wire [6:0] oY;
   
   output wire [2:0] oColour;     // VGA pixel colour (0-7)
   output wire oPlot;       // Pixel draw enable
wire [2:0] colour;
/*

   vga_adapter VGA(.resetn(iResetn),.clock(iClock),.colour(colour),.x(oX),.y(oY),.plot(oPlot),.VGA_R(VGA_R),.VGA_G(VGA_G),
		   .VGA_B(VGA_B),.VGA_HS(VGA_HS),.VGA_VS(VGA_VS),.VGA_BLANK(VGA_BLANK_N),.VGA_SYNC(VGA_SYNC_N),.VGA_CLK(VGA_CLK));
defparam VGA.RESOLUTION = "160x120";
defparam VGA.MONOCHROME = "FALSE";
defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
defparam VGA.BACKGROUND_IMAGE = "black.mif";

*/

wire[7:0] XCounter;
wire[6:0] YCounter;
wire[5:0] plotCounter;
wire loadY, loadColour, black, plotEnable;
wire[2:0] COLOUR;


//Instantiation of the control path.... need to update later
//Instantiation of the data path.... need to update later
   
endmodule // part2

module dataPath(colourEn, plotEn, addderXEn, adderYEn, Xen, Yen, blackEn, reset, clock, enable, colour, data, outColour, squareCounter, blackCounter, x, y);

input colourEn, plotEn, adderXEn, adderYEn, XEn, YEn, blackEn, reset, clock, enable;
input [3:0] colour;
input [7:0] data;
output reg [2:0] outColour;
output reg [3:0] squareCounter;
output reg [15:0] blackCounter;
reg [7:0] x;
reg [6:0] y;


		always@(posedge clock) begin
			if(!reset)
			squareCounter <= 4'b0; //resetting
			else if(enable)
			squareCounter <= squareCounter + 4'b1; //counter that moves pixel by pixel to draw
		end
		
		always@(posedge clock) begin
			if(!reset)
			blackCounter <= 16'b0; //resetting the counter
			else if(blackEn) //if iBlack is pulsed
			blackCounter <= blackCounter + 1'b1; //counter that moves pixel bit by pixel bit for black
		end
		
		always@(posedge clock)begin
			if(!reset) begin //If reset is pulsed, values are all reset
				x <= 8'b0;
				y <= 7'b0;
				outColour <= 3'b0;
			end
			else begin
			if(XEn) //if pulsed iLoadX
				begin
				x[7] <= 0; //last digit to zero
				x[6:0] <= data; //taking in the x input
				end

			if(Yen) //if pulsed //mistake should be iPlotBox?
			y[6:0] <= data; //taking in the y input

			if(colourEn) //if pulsed
			outColour <= colour; //taking in the colour input iColour
			
			end
		end
		
		always@(posedge clock) begin
			if(reset) //If reset is pulsed
				begin
					x <= 8'b0; //Bring x back to zero
					y <= 7'b0; //Bring y back to zero
				end
			else if (adderXEn) //X Counter
			x <= x + squareCounter[1:0]; //We add the x coordinates to move to next pixel

			else if (adderYEn) //Y Counter
			y <= y + squareCounter[3:2]; //We add the y coordinates to move to next pixel

			else if (blackEn) begin //If black is pulsed
				x <= blackCounter[7:0]; //Blacks out four pixel bits x
				y <= blackCounter[14:8]; //Blacks out four pixel bits y
			end
		
		
		end
		

endmodule

module controlPath(clock, reset, plotButton, clear, startButton, XCounter, YCounter, plotCounter, loadY, loadColour, plot, enable, black);
input clock, reset, plotButton, clear, startButton;
input [7:0] XCounter;
input [6:0] YCounter;
input [5:0] plotCounter;
output reg loadY, loadColour, plot, enable, black;
reg [2:0] current, next; //current and next states
  parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;

always@(*)
begin
	case(current) //Looking at the current state
	3'b101: begin //BLACK
			if(black) //if black signal
				next = 3'b101; //the next state will be black
			else
				next = 3'b010; //else we hold the current state
		end

	3'b000: begin //Beginning State
			if(startButton == 1'b1) next = 3'b001; //if iLoadX, we continue to state one with loaded X
			if(startButton == 1'b0) next = 3'b000; //if not iLoadX, we remain at the beginning state
		end

	3'b001: next = startButton ? 3'b001 : 3'b010; //If we pulse iLoadX, we go to state one if not we stay in current state

	3'b010: begin //Holding state one
			if(clear == 1'b1) next = 3'b101; //If the signal is clear, we go to black
			if(plotButton == 1'b0) next = 3'b011; //If plot is low, we go to the next state since plot is only high when we load in Y
			else if(reset == 1'b0) next = 3'b010;
		end

	3'b011: next = 3'b100; //NEXT STATE //The next state is when we load in y and then plot the box, hence it is draw?

	3'b100: begin 
			if(plotCounter <= 6'd15) next = 3'b100;
			else next = 3'b010;
		end
	default: next = 3'b010; //default case
	endcase
end

always @(*)
begin
	loadY = 1'b0;
	loadColour = 1'b0;
	plot = 1'b0;
	enable = 1'b0;
	black = 1'b0;

	case(current)
		3'b011: begin //Going to state two
				loadY = 1'b1; //we load in y (iPlotBox)
				loadColour = 1'b1; //we load in colour
			end
		3'b100: begin //DRAW
				plot = 1'b1; //we set plot to 1
				enable = 1'b1; //we set enable to 1
				loadColour = 1'b1; //we load the Colour
			end
		3'b101: begin //BLACk
				plot = 1'b1; //we set plot to 1
				black = 1'b1; //we set black signal to one
			end
	endcase
end

always @(posedge clock)
begin
	if(!reset) //if not reset
		current <= 3'b010; //we hold state one, keep the current state
	else if(clear) //if clear
		current <= 3'b101; //we make the screen black
	else
		current <= next; //if neither we go to the next state
end

endmodule
















