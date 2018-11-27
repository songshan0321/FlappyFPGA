module Clock_div(clk, clk_pace, clk_game, clk_move, clk_vga, clk_seg);

    input wire clk;
    output wire clk_pace, clk_game, clk_move, clk_vga;
    output wire [1: 0] clk_seg;

    reg [50: 0] cnt = 0;

    always @(posedge clk) begin
        cnt <= cnt + 1;
    end

    assign clk_pace = cnt[30];
    assign clk_game = cnt[19];
    assign clk_move = cnt[25];
    assign clk_vga = cnt[1];
    assign clk_seg = cnt[19: 18];

endmodule
