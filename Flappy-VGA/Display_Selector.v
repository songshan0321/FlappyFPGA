	module Display_Selector(
	clk_100MHz,
	data_Cat,
	data_pipes,data_coins,
	addr_Cat,
	addr_coins,addr_pipes,
                        clk_coin, q_Initial, shift_Coin,get_Zero,
   X_Edge_OO_L,
	X_Edge_O1_L,
	X_Edge_O2_L,
	X_Edge_O3_L,
	X_Edge_O4_L,
	
	X_Edge_OO_R,
	X_Edge_O1_R,
	X_Edge_O2_R,
	X_Edge_O3_R,
	X_Edge_O4_R,
    Bird_Y_T, Bird_Y_B, Bird_X_R,Bird_X_L,
	 
	 X_Coin_OO_L,
	 X_Coin_O1_L,
	 X_Coin_O2_L,
	 X_Coin_O3_L,
	 X_Coin_O4_L,
	 X_Coin_OO_R,
	 X_Coin_O1_R,
	 X_Coin_O2_R,
	 X_Coin_O3_R,
	 X_Coin_O4_R,
    Y_Coin_00,
	 Y_Coin_01,
	 Y_Coin_02,
	 Y_Coin_03,
	 Y_Coin_04,
	Y_Edge_00_Top,
	Y_Edge_00_Bottom,
	Y_Edge_01_Top,
	Y_Edge_01_Bottom,
	Y_Edge_02_Top,
	Y_Edge_02_Bottom,
	Y_Edge_03_Top,
	Y_Edge_03_Bottom,
	Y_Edge_04_Top,
	Y_Edge_04_Bottom,

	
                        clk_vga, x_ptr, y_ptr, RGB);
	
	input wire [7:0] data_Cat,data_pipes,data_coins;
	output reg [9:0] addr_Cat;
	output reg [8:0] addr_coins;
	output reg [12:0]addr_pipes;
   input wire clk_vga, clk_coin;
	input q_Initial, shift_Coin, get_Zero;
	input[9:0] Bird_Y_T, Bird_Y_B, Bird_X_R,Bird_X_L;
	
	input wire clk_100MHz;
	
	input [9:0] X_Coin_OO_L;
	input [9:0] X_Coin_O1_L;
	input [9:0] X_Coin_O2_L;
	input [9:0] X_Coin_O3_L;
	input [9:0] X_Coin_O4_L;
	input [9:0] X_Coin_OO_R;
	input [9:0] X_Coin_O1_R;
	input [9:0] X_Coin_O2_R;
	input [9:0] X_Coin_O3_R;
	input [9:0] X_Coin_O4_R;
   input [9:0] Y_Coin_00;
	input [9:0] Y_Coin_01;
	input [9:0] Y_Coin_02;
	input [9:0] Y_Coin_03;
	input [9:0] Y_Coin_04;
	
	
	input [9:0] Y_Edge_00_Top;
	input [9:0] Y_Edge_00_Bottom;
	input [9:0] Y_Edge_01_Top;
	input [9:0] Y_Edge_01_Bottom;
	input [9:0] Y_Edge_02_Top;
	input [9:0] Y_Edge_02_Bottom;
	input [9:0] Y_Edge_03_Top;
	input [9:0] Y_Edge_03_Bottom;
	input [9:0] Y_Edge_04_Top;
	input [9:0] Y_Edge_04_Bottom;
	
	
    input [9:0] X_Edge_OO_L;
    input [9:0] X_Edge_O1_L;
    input [9:0] X_Edge_O2_L;
    input [9:0] X_Edge_O3_L;
    input [9:0] X_Edge_O4_L;
    
    input [9:0] X_Edge_OO_R;
    input [9:0] X_Edge_O1_R;
    input [9:0] X_Edge_O2_R;
    input [9:0] X_Edge_O3_R;
    input [9:0] X_Edge_O4_R;
//  input wire pressing;
// input wire [7: 0] Coin, Pipe, Cat;
//  input wire [227: 0] state_monsters;
//  input wire [1: 0] state_hero;
    input wire [9: 0] x_ptr, y_ptr;
    // output wire [15: 0] addr_bg;
    // output wire [8: 0] addr_hero, addr_monster;
    output reg [7: 0] RGB;
    wire [7: 0] x_bg, y_bg;
    wire [4: 0] x_hero, y_hero;
    wire Coin_On,Pipe_On,Cat_On;
    // wire monster_up_on, monster_down_on, monster_left_on, monster_right_on, monster_on;

    parameter  TRANSPARENT = 16'hFF,
	    LEFT = 155,
        BG_W = 330,
        BG_H = 480;


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//													CAT												       							 //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	assign Cat_On = ((y_ptr>=(Bird_Y_T)) && (y_ptr<=(Bird_Y_B)) && 
		(x_ptr>=(Bird_X_L)) && (x_ptr<=(Bird_X_R)));

	wire Cat_Out = (x_ptr==Bird_X_R)&&(y_ptr==Bird_Y_B);
	////////////////////// Show Coin Logic ////////////////////////////////
	reg [4:0] Show_Coin={5{0}};
	always @ (posedge clk_coin) //
	begin
	if (q_Initial)
		Show_Coin <= {5{0}};
	if (get_Zero)
	begin
		Show_Coin[0] <= 0;
	end
		
	if (shift_Coin)
	begin
		if (Show_Coin[4] == 1) Show_Coin[3] <= 1;
		else if (Show_Coin[0] == 1) Show_Coin[4] <= 1;
		else if (Show_Coin[1] == 1) Show_Coin[0] <= 1;
		else if (Show_Coin[2] == 1) Show_Coin[1] <= 1;
		else   Show_Coin[2] <= 1;
	end	
	end

	wire Coin_0 = Show_Coin[0] && x_ptr>=X_Coin_OO_L && x_ptr<=X_Coin_OO_R && y_ptr>=Y_Coin_00 && y_ptr<=Y_Coin_00+20;
	wire Coin_1 = Show_Coin[1] && x_ptr>=X_Coin_O1_L && x_ptr<=X_Coin_O1_R && y_ptr>=Y_Coin_01 && y_ptr<=Y_Coin_01+20;
	wire Coin_2 = Show_Coin[2] && x_ptr>=X_Coin_O2_L && x_ptr<=X_Coin_O2_R && y_ptr>=Y_Coin_02 && y_ptr<=Y_Coin_02+20;
	wire Coin_3 = Show_Coin[3] && x_ptr>=X_Coin_O3_L && x_ptr<=X_Coin_O3_R && y_ptr>=Y_Coin_03 && y_ptr<=Y_Coin_03+20;
	wire Coin_4 = Show_Coin[4] && x_ptr>=X_Coin_O4_L && x_ptr<=X_Coin_O4_R && y_ptr>=Y_Coin_04 && y_ptr<=Y_Coin_04+20;
	assign Coin_On = Coin_0 || Coin_1 || Coin_2 || Coin_3 || Coin_4;

	wire Coin_Out = ((x_ptr==X_Coin_OO_R)&&(y_ptr==Y_Coin_00+20)||(x_ptr==X_Coin_O1_R)&&(y_ptr==Y_Coin_01+20)
					||(x_ptr==X_Coin_O2_R)&&(y_ptr==Y_Coin_02+20)||(x_ptr==X_Coin_O3_R)&&(y_ptr==Y_Coin_03+20)
					||(x_ptr==X_Coin_O4_R)&&(y_ptr==Y_Coin_04+20));

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//													PIPE																			 //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	assign Pipe_On = ((x_ptr>=X_Edge_OO_L && x_ptr<=X_Edge_OO_R && (y_ptr<=Y_Edge_00_Top || y_ptr>=Y_Edge_00_Bottom)) ||
		(x_ptr>=X_Edge_O1_L && x_ptr<=X_Edge_O1_R && (y_ptr<=Y_Edge_01_Top || y_ptr>=Y_Edge_01_Bottom)) ||
		(x_ptr>=X_Edge_O2_L && x_ptr<=X_Edge_O2_R && (y_ptr<=Y_Edge_02_Top || y_ptr>=Y_Edge_02_Bottom)) ||
		(x_ptr>=X_Edge_O3_L && x_ptr<=X_Edge_O3_R && (y_ptr<=Y_Edge_03_Top || y_ptr>=Y_Edge_03_Bottom)) ||
		(x_ptr>=X_Edge_O4_L && x_ptr<=X_Edge_O4_R && (y_ptr<=Y_Edge_04_Top || y_ptr>=Y_Edge_04_Bottom)));


	wire Pipe_Out = (( x_ptr==X_Edge_OO_R && (y_ptr==Y_Edge_00_Top || y_ptr==Y_Edge_00_Bottom))||
					( x_ptr==X_Edge_O1_R && (y_ptr==Y_Edge_01_Top || y_ptr==Y_Edge_01_Bottom))||
					( x_ptr==X_Edge_O2_R && (y_ptr==Y_Edge_02_Top || y_ptr==Y_Edge_02_Bottom))||
					( x_ptr==X_Edge_O3_R && (y_ptr==Y_Edge_03_Top || y_ptr==Y_Edge_03_Bottom))||
					( x_ptr==X_Edge_O4_R && (y_ptr==Y_Edge_04_Top || y_ptr==Y_Edge_04_Bottom)));
	
    assign bg_on = (x_ptr >= LEFT) && (x_ptr < LEFT + BG_W) && (y_ptr >= 0) && (y_ptr < BG_H);

	 reg [9:0] Addr_Buff_Cat=10'd4;
	 reg [8:0] Addr_Buff_coins=9'd4;
	 reg [12:0]Addr_Buff_pipes=13'd4;
    always @(posedge clk_vga) begin
                if (Cat_On) begin
                    RGB <= (data_Cat!=TRANSPARENT) ? data_Cat : 8'b0;
					if (Cat_Out)
						Addr_Buff_Cat<=10'd4;
					else
						Addr_Buff_Cat<=Addr_Buff_Cat+1;
					addr_Cat <= Addr_Buff_Cat;
                end
                else if (Pipe_On) begin
                    RGB <= (data_pipes!=TRANSPARENT) ? data_pipes : 8'b0;
					if (Pipe_Out)
						Addr_Buff_pipes<=10'd4;
					else
						Addr_Buff_pipes<=Addr_Buff_pipes+1;
					addr_pipes <= Addr_Buff_pipes;
                end
                else if (Coin_On) begin
                    RGB <= (data_coins!=TRANSPARENT) ? data_coins : 8'b0;
					if (Coin_Out)
						Addr_Buff_coins<=10'd4;
					else
						Addr_Buff_coins<=Addr_Buff_coins+1;
					addr_coins <= Addr_Buff_coins;
                end
        else 
            RGB <= 8'b0;
    end
endmodule 