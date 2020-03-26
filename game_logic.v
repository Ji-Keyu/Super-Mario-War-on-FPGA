`timescale 1ns / 1ps

module game_logic( 
    input clk,
    input rst,
    input BtnL, 
    input BtnU,
    input BtnR,
    output reg [9:0] mario_x,
	output reg [9:0] mario_y,
    output reg [9:0] coin_x,
	output reg [9:0] coin_y,
    output reg [3:0] score_ten,
	output reg [3:0] score_one,
    input SigU,
    input SigL,
    input SigR,
    output reg [9:0] mario_x1,
	output reg [9:0] mario_y1,
    output reg [3:0] score1_ten,
    output reg [3:0] score1_one
    );
`include "param.v"

reg st_jump_up;
reg on_ground;
reg [6:0] jump_dist;
reg [4:0] new_coin_pos;

reg st_jump_up_d;
reg on_ground_d;
reg [6:0] jump_dist_d;


always @ (posedge clk) begin
	if (rst) begin
        mario_x <= 5;
        mario_y <= 17;
		coin_x <= 10'd340;
		coin_y <= 10'd330;
        score_ten <= 0;
		score_one <= 0;
        st_jump_up <= 0;
        jump_dist <= 0;
		on_ground <= 1;
		new_coin_pos <= 0;
    end

    /* horizontal movement */
    if (BtnL && (mario_x > 10'd2)) mario_x <= mario_x - 1;
    else if (BtnR && mario_x < 10'd597) mario_x <= mario_x + 1;
    
    /* vertical upward movement */
    if (BtnU && on_ground) begin
        st_jump_up <= 1;
        jump_dist <= 110;
		on_ground <= 0;
    end
    if (st_jump_up) begin
        jump_dist <= jump_dist - 1;
        mario_y <= mario_y + 1;
    end
    if (jump_dist == 0) st_jump_up <= 0;

    /* vertical downward movement */
    if (~st_jump_up && mario_y > 10'd12) begin
        if (mario_x <= 300) begin //boundary 1-5
            if (
            (mario_x + W_mario < 10'd3 || mario_x > 10'd61 || mario_y != 10'd372) &&
            (mario_x + W_mario < 10'd3 || mario_x > 10'd91 || mario_y != 10'd222) &&
            (mario_x + W_mario < 10'd62 || mario_x > 10'd212 || mario_y != 10'd42) &&
            (mario_x + W_mario < 10'd151 || mario_x > 10'd271 || mario_y != 10'd372) &&
            (mario_x + W_mario < 10'd181 || mario_x > 10'd301 || mario_y != 10'd312)
            )
            mario_y <= mario_y - 1;
			else
				on_ground <= 1;
        end else begin //boundary 6-10
            if (
            (mario_x + W_mario < 10'd302 || mario_x > 10'd390 || mario_y != 10'd72) &&
            (mario_x + W_mario < 10'd361 || mario_x > 10'd481 || mario_y != 10'd162) &&
            (mario_x + W_mario < 10'd391 || mario_x > 10'd598 || mario_y != 10'd282) &&
            (mario_x + W_mario < 10'd482 || mario_x > 10'd598 || mario_y != 10'd102) &&
            (mario_x + W_mario < 10'd541 || mario_x > 10'd598 || mario_y != 10'd222)
            )
            mario_y <= mario_y - 1;
			else
				on_ground <= 1;
        end
	end
	else if (mario_y == 10'd12)
		on_ground <= 1;


    if (rst) 
    begin
        mario_x1 <= 585;
        mario_y1 <= 17;
        score1_ten <= 0;
		score1_one <= 0;
        st_jump_up_d <= 0;
        jump_dist_d <= 0;
		on_ground_d <= 1;
    end

    /* horizontal movement */
    if (SigL && (mario_x1 > 10'd2)) mario_x1 <= mario_x1 - 1;
    else if (SigR && mario_x1 < 10'd597) mario_x1 <= mario_x1 + 1;
    
    /* vertical upward movement */
    if (SigU && on_ground_d) 
    begin
        st_jump_up_d <= 1;
        jump_dist_d <= 110;
        on_ground_d <= 0;
    end
    if (st_jump_up_d) 
    begin
        jump_dist_d <= jump_dist_d - 1;
        mario_y1 <= mario_y1 + 1;
    end
    if (jump_dist_d == 0) st_jump_up_d <= 0;

    /* vertical downward movement */
    if (~st_jump_up_d && mario_y1 > 10'd12) 
    begin
        if (mario_x1 <= 300) 
        begin //boundary 1-5
            if (
            (mario_x1 + W_mario < 10'd3 || mario_x1 > 10'd61 || mario_y1 != 10'd372) &&
            (mario_x1 + W_mario < 10'd3 || mario_x1 > 10'd91 || mario_y1 != 10'd222) &&
            (mario_x1 + W_mario < 10'd62 || mario_x1 > 10'd212 || mario_y1 != 10'd42) &&
            (mario_x1 + W_mario < 10'd151 || mario_x1 > 10'd271 || mario_y1 != 10'd372) &&
            (mario_x1 + W_mario < 10'd181 || mario_x1 > 10'd301 || mario_y1 != 10'd312)
            )
            mario_y1 <= mario_y1 - 1;
            else
                on_ground_d <= 1;
        end else begin //boundary 6-10
            if (
            (mario_x1 + W_mario < 10'd302 || mario_x1 > 10'd390 || mario_y1 != 10'd72) &&
            (mario_x1 + W_mario < 10'd361 || mario_x1 > 10'd481 || mario_y1 != 10'd162) &&
            (mario_x1 + W_mario < 10'd391 || mario_x1 > 10'd598 || mario_y1 != 10'd282) &&
            (mario_x1 + W_mario < 10'd482 || mario_x1 > 10'd598 || mario_y1 != 10'd102) &&
            (mario_x1 + W_mario < 10'd541 || mario_x1 > 10'd598 || mario_y1 != 10'd222)
            )
            mario_y1 <= mario_y1 - 1;
            else
                on_ground_d <= 1;
        end
    end
    else if (mario_y1 == 10'd12)
        on_ground_d <= 1;




    if (mario_x >= coin_x-W_mario && 
		mario_x <= coin_x+W_coin && 
		mario_y >= coin_y-H_mario && 
		mario_y <= coin_y+H_coin) begin
        if (score_one != 9)
			score_one <= score_one + 1;
		else begin
			score_one <= 0;
			score_ten <= score_ten + 1;
		end
		
        case (new_coin_pos % 10)
            5'd0: begin coin_x <= 10'd80; coin_y <= 10'd50; end     //boundary 3
            5'd1: begin coin_x <= 10'd370; coin_y <= 10'd170; end   //7
            5'd2: begin coin_x <= 10'd200; coin_y <= 10'd365; end   //4
            5'd3: begin coin_x <= 10'd540; coin_y <= 10'd100; end   //9
            5'd4: begin coin_x <= 10'd550; coin_y <= 10'd220; end   //10
            5'd5: begin coin_x <= 10'd30; coin_y <= 10'd365; end   //1
            5'd6: begin coin_x <= 10'd30; coin_y <= 10'd225; end   //2
            5'd7: begin coin_x <= 10'd275; coin_y <= 10'd315; end   //5
            5'd8: begin coin_x <= 10'd310; coin_y <= 10'd75; end   //6
            5'd9: begin coin_x <= 10'd480; coin_y <= 10'd285; end   //8
        endcase
		
		if (new_coin_pos == 9)
			new_coin_pos <= 0;
		else
			new_coin_pos <= new_coin_pos + 1;
    end

    if (mario_x1 >= coin_x-W_mario && 
		mario_x1 <= coin_x+W_coin && 
		mario_y1 >= coin_y-H_mario && 
		mario_y1 <= coin_y+H_coin) begin
        if (score1_one != 9)
			score1_one <= score1_one + 1;
		else begin
			score1_one <= 0;
			score1_ten <= score1_ten + 1;
		end
		
        case (new_coin_pos % 10)
            5'd0: begin coin_x <= 10'd80; coin_y <= 10'd50; end     //boundary 3
            5'd1: begin coin_x <= 10'd370; coin_y <= 10'd170; end   //7
            5'd2: begin coin_x <= 10'd200; coin_y <= 10'd365; end   //4
            5'd3: begin coin_x <= 10'd540; coin_y <= 10'd100; end   //9
            5'd4: begin coin_x <= 10'd550; coin_y <= 10'd220; end   //10
            5'd5: begin coin_x <= 10'd30; coin_y <= 10'd365; end   //1
            5'd6: begin coin_x <= 10'd30; coin_y <= 10'd225; end   //2
            5'd7: begin coin_x <= 10'd275; coin_y <= 10'd315; end   //5
            5'd8: begin coin_x <= 10'd310; coin_y <= 10'd75; end   //6
            5'd9: begin coin_x <= 10'd480; coin_y <= 10'd285; end   //8
        endcase
		
		if (new_coin_pos == 9)
			new_coin_pos <= 0;
		else
			new_coin_pos <= new_coin_pos + 1;
    end
end

endmodule