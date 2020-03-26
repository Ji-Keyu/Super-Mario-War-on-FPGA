`timescale 1ns / 1ps

module display_interface(
    input clk,
	input rst,
	input [9:0] mario_x,
	input [9:0] mario_y,
	input [9:0] mario_x1,
	input [9:0] mario_y1,
	input [9:0] coin_x,
	input [9:0] coin_y,
	output HSYNC,
	output VSYNC,
	output wire [2:0] R,
	output wire [2:0] G,
	output wire [1:0] B
    );
`include "param.v"

reg [7:0] output_color;
assign R = {
	output_color[7] & inDisplayArea,
	output_color[6] & inDisplayArea,
	output_color[5] & inDisplayArea
};
assign G = {
	output_color[4] & inDisplayArea,
	output_color[3] & inDisplayArea,
	output_color[2] & inDisplayArea
};
assign B = {
	output_color[1] & inDisplayArea,
	output_color[0] & inDisplayArea
};

// INIT the sync generator and its support wires
wire inDisplayArea;
wire [9:0] CounterX;
wire [9:0] CounterY;
hvsync_generator syncgen(.clk(clk), .reset(rst),
	.vga_h_sync(HSYNC), 
	.vga_v_sync(VSYNC), 
	.inDisplayArea(inDisplayArea), 
	.CounterX(CounterX), 
	.CounterY(CounterY));

// colors
localparam mario_color = 8'b111_000_00;
localparam coin_color = 8'hfc;
localparam black = 8'h0;
localparam white = 8'hff;
localparam one = 8'b010_110_11;
localparam two = 8'b101_011_00;
localparam three = 8'b101_011_00;
localparam four = 8'b010_110_11;
localparam five = 8'b100_101_01;
localparam six = 8'b100_101_01;
localparam seven = 8'b111_110_00;
localparam eight = 8'b111_100_01;
localparam nine = 8'b010_110_11;
localparam ten = 8'b111_110_00;
localparam bg_color = 8'b110_110_11;



always @ (posedge clk) begin
if (CounterX >= mario_x && CounterX < mario_x+W_mario && CounterY >= 400-mario_y-H_mario && CounterY < 400-mario_y)
	if (mario_art[400-CounterY-mario_y][CounterX-mario_x])
		output_color <= white;
	else
		output_color <= mario_color;
else if (CounterX >= mario_x1 && CounterX < mario_x1+W_mario && CounterY >= 400-mario_y1-H_mario && CounterY < 400-mario_y1)
	if (mario_art[400-CounterY-mario_y1][CounterX-mario_x1])
		output_color <= white;
	else
		output_color <= mario_color;
else if (CounterX >= coin_x && CounterX < coin_x+W_coin && CounterY > 400-H_coin-coin_y && CounterY < 400-coin_y && coin_art[400-CounterY-coin_y][CounterX-coin_x])
	output_color <= coin_color;
else if (CounterX > 1 && CounterX < 62 && CounterY > 28 && CounterY < 59)
	output_color <= one;
else if (CounterX > 1 && CounterX < 92 && CounterY > 178 && CounterY < 240)
	output_color <= two;
else if (CounterX > 61 && CounterX < 213 && CounterY > 358 && CounterY < 389)
	output_color <= three;
else if (CounterX > 150 && CounterX < 272 && CounterY > 28 && CounterY < 89)
	output_color <= four;
else if (CounterX > 150 && CounterX < 181 && CounterY > 28 && CounterY < 150)
	output_color <= four;
else if (CounterX > 180 && CounterX < 302 && CounterY > 88 && CounterY < 180)
	output_color <= five;
else if (CounterX > 301 && CounterX < 391 && CounterY > 328 && CounterY < 389)
	output_color <= six;
else if (CounterX > 360 && CounterX < 482 && CounterY > 238 && CounterY < 329)
	output_color <= seven;
else if (CounterX > 390 && CounterX < 482 && CounterY > 328 && CounterY < 389)
	output_color <= seven;
else if (CounterX > 390 && CounterX < 599 && CounterY > 118 && CounterY < 179)
	output_color <= eight;
else if (CounterX > 390 && CounterX < 541 && CounterY > 178 && CounterY < 209)
	output_color <= eight;
else if (CounterX > 390 && CounterX < 599 && CounterY > 208 && CounterY < 239)
	output_color <= eight;
else if (CounterX > 481 && CounterX < 599 && CounterY > 238 && CounterY < 299)
	output_color <= eight;
else if (CounterX > 481 && CounterX < 599 && CounterY > 298 && CounterY < 389)
	output_color <= nine;
else if (CounterX > 540 && CounterX < 599 && CounterY > 178 && CounterY < 209)
	output_color <= ten;
else if (CounterX < 2 || CounterX > 598 || CounterY < 2 || CounterY > 388)
	output_color <= black;
else
	output_color <= bg_color;
end
endmodule