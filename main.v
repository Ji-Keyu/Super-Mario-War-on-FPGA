//http://2.6822.com/www.9/full_26065.html
`timescale 1ns / 1ps
module main( MemOE, MemWR, RamCS, FlashCS, QuadSpiFlashCS, // Disable the three memory chips
      ClkPort, // the board's 100MHz clk
		BtnL, BtnU, BtnR,
		Sw0, // For reset   
		vga_hsync, vga_vsync, 
		vga_r0, vga_r1, vga_r2,
		vga_g0, vga_g1, vga_g2,
		vga_b0, vga_b1,
		MISO, SS, MOSI, SCLK,
		ca, cb, cc, cd, ce, cf, cg, an,
    );

`include "param.v"

input ClkPort;
wire Reset;
assign Reset = Sw0;


/* Clocking */
reg[26:0] DIV_CLK;
//wire full_clock;
//BUFGP CLK_BUF(full_clock, ClkPort);

always @(posedge ClkPort, posedge Reset)
begin
	if (Reset) DIV_CLK <= 0;
	else DIV_CLK <= DIV_CLK + 1'b1;
end

wire game_logic_clk, vga_clk, debounce_clk;
assign vga_clk = DIV_CLK[1]; // 25MHz for pixel freq
//assign game_logic_clk = DIV_CLK[11]; // 24.4 kHz 
//assign debounce_clk = DIV_CLK[11]; // 24.4 kHz; needs to match game_logic for the single clock pulses

clock200hz clk200(.clk(ClkPort), .twohundredhz(game_logic_clk));

	input MISO;					// Master In Slave Out, Pin 3, Port JA
	output SS;					// Slave Select, Pin 1, Port JA
	output MOSI;				// Master Out Slave In, Pin 2, Port JA
	output SCLK;				// Serial Clock, Pin 4, Port JA

	wire SS;						// Active low
	wire MOSI;					// Data transfer from master to slave
	wire SCLK;					// Serial clock that controls communication

	// Signal to send/receive data to/from PmodJSTK
	wire fivehz;

	// Data read from PmodJSTK
	wire [39:0] jstkData;

	// Signal carrying output data that user selected
	wire [9:0] posDataX;
	wire [9:0] posDataY;

				//-----------------------------------------------
				//  	  			PmodJSTK Interface
				//-----------------------------------------------
				PmodJSTK PmodJSTK_Int(
						.CLK(ClkPort),
						.RST(Reset),
						.sndRec(game_logic_clk),
						.DIN(sndData),
						.MISO(MISO),
						.SS(SS),
						.SCLK(SCLK),
						.MOSI(MOSI),
						.DOUT(jstkData)
				);

				//-----------------------------------------------
				//  			 Send Receive Generator
				//-----------------------------------------------
				ClkDiv_5Hz genSndRec(
						.CLK(ClkPort),
						.RST(Reset),
						.CLKOUT(fivehz)
				);

				// Use state of switch 0 to select output of X position or Y position data to SSD
				assign posDataY = {jstkData[9:8], jstkData[23:16]};
				assign posDataX = {jstkData[25:24], jstkData[39:32]};
				
/*  INPUTS */
// Clock & Reset I/O
input		Sw0; 
wire UP, LEFT, RIGHT;
assign UP = (posDataY >= 630);
assign LEFT = (posDataX <= 300);
assign RIGHT = (posDataX >= 630);
input		BtnL, BtnU, BtnR;

/* OUTPUTS */
output wire	MemOE, MemWR, RamCS, FlashCS, QuadSpiFlashCS; // just to disable them all
	assign MemOE = 0;
	assign MemWR = 0;
	assign RamCS = 0;
	assign FlashCS = 0;
	assign QuadSpiFlashCS = 0;
output wire vga_hsync, vga_vsync; 
output wire vga_r0, vga_r1, vga_r2;
output wire vga_g0, vga_g1, vga_g2;
output wire vga_b0, vga_b1;

// connect the vga color buses to the top design's outputs
wire[2:0] vga_r;
wire[2:0] vga_g;
wire[1:0] vga_b;
assign vga_r0 = vga_r[2]; assign vga_r1 = vga_r[1]; assign vga_r2 = vga_r[0];
assign vga_g0 = vga_g[2]; assign vga_g1 = vga_g[1]; assign vga_g2 = vga_b[0];
assign vga_b0 = vga_b[1]; assign vga_b1 = vga_b[0];


wire [9:0] coin_x;
wire [9:0] coin_y;
wire [9:0] mario1_x;
wire [9:0] mario1_y;
wire [9:0] mario2_x;
wire [9:0] mario2_y;
wire [3:0] score1_ten;
wire [3:0] score1_one;
wire [3:0] score2_ten;
wire [3:0] score2_one;

game_logic logic_module(
	.clk(game_logic_clk), 
	.rst(Reset),

	.BtnU(BtnU), .BtnL(BtnL), .BtnR(BtnR), 
	.mario_x(mario1_x), .mario_y(mario1_y), .coin_x(coin_x), .coin_y(coin_y),
	.SigU(UP), .SigL(LEFT), .SigR(RIGHT),
    .mario_x1(mario2_x), .mario_y1(mario2_y),
	.score_ten(score1_ten), .score_one(score1_one),
	.score1_ten(score2_ten), .score1_one(score2_one)
	);

/* Init VGA interface */
display_interface display_interface(
	.clk(vga_clk), // 25 MHz
	.rst(Reset),
	.HSYNC(vga_hsync), // direct outputs to VGA monitor
	.VSYNC(vga_vsync),
	.mario_x(mario1_x),
	.mario_y(mario1_y),
	.mario_x1(mario2_x),
	.mario_y1(mario2_y),
	.coin_x(coin_x),
	.coin_y(coin_y),
	.R(vga_r),
	.G(vga_g),
	.B(vga_b)
);

output [3:0] an;
output ca;
output cb;
output cc;
output cd;
output ce;
output cf;
output cg;

bcd_display b1(.clk(game_logic_clk), .min_ten(score2_ten), .min_one(score2_one), 
 .sec_ten(score1_ten), .sec_one(score1_one), 
 .an(an), .ca(ca), .cb(cb), .cc(cc), .cd(cd), .ce(ce), .cf(cf), .cg(cg));

endmodule
