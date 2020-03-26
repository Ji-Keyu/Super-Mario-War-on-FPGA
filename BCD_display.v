`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:52:45 04/03/2019 
// Design Name: 
// Module Name:    bcd_display 
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
//////////////////////////////////////////////////////////////////////////////////
module bcd_display(
	input clk,
	input [3:0] min_ten,
	input [3:0] min_one,
	input [3:0] sec_ten,
	input [3:0] sec_one,
	output reg [3:0] an,
	output ca,
	output cb,
	output cc,
	output cd,
	output ce,
	output cf,
	output cg
    );
	
	reg [1:0] an_index = 2'd3;
	reg [3:0] digit = 4'd0;
	
	always @ (posedge clk) begin
		an_index <= an_index + 1;
		case (an_index)
		2'd0: begin
			an <= 4'b1110;
			digit <= sec_one;
		end
		2'd1: begin
			an <= 4'b1101;
			digit <= sec_ten;
		end
		2'd2: begin
			an <= 4'b1011;
			digit <= min_one;
		end
		2'd3: begin
			an <= 4'b0111;
			digit <= min_ten;
		end
		endcase
	end
	
	seg7_decoder decoder(.clk(clk), .digit(digit), 
		.ca(ca), .cb(cb), .cc(cc), .cd(cd), .ce(ce), .cf(cf), .cg(cg));
endmodule