module Clock_div(clk, clk_pace, clk_game, clk_move, clk_vga, clk_seg, score);

    input wire clk, score;
    output wire clk_pace, clk_game, clk_move, clk_vga;
    output wire [1: 0] clk_seg;

    reg [50: 0] cnt = 0;
	 reg [5:0] game_clk_div = 19;

    always @(posedge clk) begin
        cnt <= cnt + 1;
    end
	 
	 always @(score) begin
			if (score == 5) game_clk_div <= game_clk_div - 1; // increase speed
			if (score == 10) game_clk_div <= game_clk_div - 1;
			if (score == 15) game_clk_div <= game_clk_div - 1;
			if (score == 20) game_clk_div <= game_clk_div - 1;
	 end

    assign clk_pace = cnt[30];
    assign clk_game = cnt[game_clk_div];
    assign clk_move = cnt[25];
    assign clk_vga = cnt[1];
    assign clk_seg = cnt[19: 18];

endmodule
