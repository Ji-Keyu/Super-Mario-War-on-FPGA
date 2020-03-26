`timescale 1ns / 1ps

module seg7_decoder(
	input clk,
    input [3:0] digit,
    output reg ca,
    output reg cb,
    output reg cc,
    output reg cd,
    output reg ce,
    output reg cf,
    output reg cg
    );
	
	
    always @ (*) begin
		case (digit)
		      4'd0: begin
				    ca = 1'b0;
					 cb = 1'b0;
					 cc = 1'b0;
					 cd = 1'b0;
					 ce = 1'b0;
					 cf = 1'b0;
					 cg = 1'b1;
				end

		      4'd1: begin
				    ca = 1'b1;
					 cb = 1'b0;
					 cc = 1'b0;
					 cd = 1'b1;
					 ce = 1'b1;
					 cf = 1'b1;
					 cg = 1'b1;
				end

		      4'd2: begin
				    ca = 1'b0;
					 cb = 1'b0;
					 cc = 1'b1;
					 cd = 1'b0;
					 ce = 1'b0;
					 cf = 1'b1;
					 cg = 1'b0;
				end

		      4'd3: begin
				    ca = 1'b0;
					 cb = 1'b0;
					 cc = 1'b0;
					 cd = 1'b0;
					 ce = 1'b1;
					 cf = 1'b1;
					 cg = 1'b0;
				end

		      4'd4: begin
				    ca = 1'b1;
					 cb = 1'b0;
					 cc = 1'b0;
					 cd = 1'b1;
					 ce = 1'b1;
					 cf = 1'b0;
					 cg = 1'b0;
				end

		      4'd5: begin
				    ca = 1'b0;
					 cb = 1'b1;
					 cc = 1'b0;
					 cd = 1'b0;
					 ce = 1'b1;
					 cf = 1'b0;
					 cg = 1'b0;
				end

		      4'd6: begin
				    ca = 1'b0;
					 cb = 1'b1;
					 cc = 1'b0;
					 cd = 1'b0;
					 ce = 1'b0;
					 cf = 1'b0;
					 cg = 1'b0;
				end

		      4'd7: begin
				    ca = 1'b0;
					 cb = 1'b0;
					 cc = 1'b0;
					 cd = 1'b1;
					 ce = 1'b1;
					 cf = 1'b1;
					 cg = 1'b1;
				end

		      4'd8: begin
				    ca = 1'b0;
					 cb = 1'b0;
					 cc = 1'b0;
					 cd = 1'b0;
					 ce = 1'b0;
					 cf = 1'b0;
					 cg = 1'b0;
				end

		      4'd9: begin
				    ca = 1'b0;
					 cb = 1'b0;
					 cc = 1'b0;
					 cd = 1'b0;
					 ce = 1'b1;
					 cf = 1'b0;
					 cg = 1'b0;
				end
				 
				default: begin
				    ca = 1'b1;
					 cb = 1'b1;
					 cc = 1'b1;
					 cd = 1'b1;
					 ce = 1'b1;
					 cf = 1'b1;
					 cg = 1'b1;
				end
			endcase
		end

endmodule