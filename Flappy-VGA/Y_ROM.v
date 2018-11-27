`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:05:03 04/10/2014 
// Design Name: 
// Module Name:    Y_ROM 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
// 
// This holds default heights (Y coordinates) for pipe obstacles.
// Coordinate is the top edge of the pipe. Bottom edge is calculated in obstacle logic.
//////////////////////////////////////////////////////////////////////////////////
module Y_ROM(clk, I, IC,
	YEdge0T, YEdge0B,
	YEdge1T, YEdge1B,
	YEdge2T, YEdge2B,
	YEdge3T, YEdge3B,
	YEdge4T, YEdge4B,
	YCoin0, YCoin1, YCoin2, YCoin3, YCoin4
	);
	
	parameter ET0 = 50;
	parameter ET1 = 150;
	parameter ET2 = 150;
	parameter ET3 = 110;
	parameter ET4 = 200;
	
	parameter EB0 = ET0 + 200;
	parameter EB1 = ET1 + 200;
	parameter EB2 = ET2 + 200;
	parameter EB3 = ET3 + 300;
	parameter EB4 = ET4 + 200;
	
	// Random coins' y coordinate: (val - A)*(b-a)/(B-A) + a , if [A,B] -> [a,b]
	reg [9:0] C0 = 0;
	reg [9:0] C1 = 0;
	reg [9:0] C2 = 0;
	reg [9:0] C3 = 0;
	reg [9:0] C4 = 0;
	
	input [2:0] I;
	input [2:0] IC;
	input clk;
	
	output [9:0] YEdge0T;
	output [9:0] YEdge0B;
	output [9:0] YEdge1T;
	output [9:0] YEdge1B;
	output [9:0] YEdge2T;
	output [9:0] YEdge2B;
	output [9:0] YEdge3T;
	output [9:0] YEdge3B;
	output [9:0] YEdge4T;
	output [9:0] YEdge4B;
	
	// coin
	output [9:0] YCoin0;
	output [9:0] YCoin1;
	output [9:0] YCoin2;
	output [9:0] YCoin3;
	output [9:0] YCoin4;

	reg [9:0] YEdge0T;
	reg [9:0] YEdge0B;
	reg [9:0] YEdge1T;
	reg [9:0] YEdge1B;
	reg [9:0] YEdge2T;
	reg [9:0] YEdge2B;
	reg [9:0] YEdge3T;
	reg [9:0] YEdge3B;
	reg [9:0] YEdge4T;
	reg [9:0] YEdge4B;

	// coin
	reg [9:0] YCoin0;
	reg [9:0] YCoin1;
	reg [9:0] YCoin2;
	reg [9:0] YCoin3;
	reg [9:0] YCoin4;	
	
	wire [12:0] random;
	reg enable = 1;
//	LFSR lfsr(.clk(IC), .reset(BtnR), .out(random), .enable(enable));
	Random rand(.clk(IC), .out(random));
 
   always @(I) //instead of always@(I)
         case (I)
            3'b000: 
				begin 
					YEdge0T <= ET0;
					YEdge0B <= EB0;
					YEdge1T <= ET1;
					YEdge1B <= EB1;
					YEdge2T <= ET2;
					YEdge2B <= EB2;
					YEdge3T <= ET3;
					YEdge3B <= EB3;
					YEdge4T <= ET4;
					YEdge4B <= EB4;
				end
            3'b001:
				begin 
					YEdge0T <= ET1;
					YEdge0B <= EB1;
					YEdge1T <= ET2;
					YEdge1B <= EB2;
					YEdge2T <= ET3;
					YEdge2B <= EB3;
					YEdge3T <= ET4;
					YEdge3B <= EB4;
					YEdge4T <= ET0;
					YEdge4B <= EB0;
				end
            3'b010:
				begin 
					YEdge0T <= ET2;
					YEdge0B <= EB2;
					YEdge1T <= ET3;
					YEdge1B <= EB3;
					YEdge2T <= ET4;
					YEdge2B <= EB4;
					YEdge3T <= ET0;
					YEdge3B <= EB0;
					YEdge4T <= ET1;
					YEdge4B <= EB1;
				end
            3'b011:
				begin 
					YEdge0T <= ET3;
					YEdge0B <= EB3;
					YEdge1T <= ET4;
					YEdge1B <= EB4;
					YEdge2T <= ET0;
					YEdge2B <= EB0;
					YEdge3T <= ET1;
					YEdge3B <= EB1;
					YEdge4T <= ET2;
					YEdge4B <= EB2;
				end
			3'b100:
				begin 
					YEdge0T <= ET4;
					YEdge0B <= EB4;
					YEdge1T <= ET0;
					YEdge1B <= EB0;
					YEdge2T <= ET1;
					YEdge2B <= EB1;
					YEdge3T <= ET2;
					YEdge3B <= EB2;
					YEdge4T <= ET3;
					YEdge4B <= EB3;
				end
            default:
				begin 
					YEdge0T <= 10'bXXXXXXXXXX;
					YEdge0B <= 10'bXXXXXXXXXX;
					YEdge1T <= 10'bXXXXXXXXXX;
					YEdge1B <= 10'bXXXXXXXXXX;
					YEdge2T <= 10'bXXXXXXXXXX;
					YEdge2B <= 10'bXXXXXXXXXX;
					YEdge3T <= 10'bXXXXXXXXXX;
					YEdge3B <= 10'bXXXXXXXXXX;
					YEdge4T <= 10'bXXXXXXXXXX;
					YEdge4B <= 10'bXXXXXXXXXX;
				end
         endcase	 
			// (val - A)*(b-a)/(B-A) + a , if [A,B] -> [a,b]
	always @(IC) // Index of selected coin
         case (IC)
            3'b000: 
				begin 
					C2 = (EB2-30)-random%((EB2-30)-(ET2+10));
					YCoin0 = C0;
					YCoin1 = C1;
					YCoin2 = C2;
					YCoin3 = C3;
					YCoin4 = C4;	
				end
            3'b001:
				begin 
					C3 = (EB3-30)-random%((EB3-30)-(ET3+10));
					YCoin0 = C1;
					YCoin1 = C2;
					YCoin2 = C3;
					YCoin3 = C4;
					YCoin4 = C0;	
				end
            3'b010:
				begin 
					C4 = (EB4-30)-random%((EB4-30)-(ET4+10));
					YCoin0 = C2;
					YCoin1 = C3;
					YCoin2 = C4;
					YCoin3 = C0;
					YCoin4 = C1;	
				end
            3'b011:
				begin 
					C0 = (EB0-30)-random%((EB0-30)-(ET0+10));
					YCoin0 = C3;
					YCoin1 = C4;
					YCoin2 = C0;
					YCoin3 = C1;
					YCoin4 = C2;	
				end
			3'b100:
				begin 
					C1 = (EB1-30)-random%((EB1-30)-(ET1+10));
					YCoin0 = C4;
					YCoin1 = C0;
					YCoin2 = C1;
					YCoin3 = C2;
					YCoin4 = C3;
				end
         endcase
		
endmodule
