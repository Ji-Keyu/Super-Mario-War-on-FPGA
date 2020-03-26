`timescale 1ns / 1ps

module clock200hz(
	//Outputs
	twohundredhz,
	//Inputs
	clk
    );

input 		clk;
reg [26:0] counter;
output reg	twohundredhz;

	always @ (posedge clk)
	begin
		if (counter == 0) begin//200Hz
			counter <= 249999;
			twohundredhz <= ~twohundredhz;
		end else begin
			counter <= counter - 1;
		end
	end
endmodule
