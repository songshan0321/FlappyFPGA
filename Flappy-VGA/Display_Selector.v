	module Display_Selector(
	clk_100MHz,
	data_Cat_1,data_Cat_2,data_Cat_3,data_Cat_4,
	addr_Cat_1,addr_Cat_2,addr_Cat_3,addr_Cat_4,
	data_pipes,data_coins,clk_cat,
	
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
	
	input wire [7:0] data_Cat_1,data_Cat_2,data_Cat_3,data_Cat_4,data_pipes,data_coins;
	output wire [10:0] addr_Cat_1,addr_Cat_2,addr_Cat_3,addr_Cat_4;
	output wire [8:0] addr_coins;
	output wire [12:0]addr_pipes;
   input wire clk_vga, clk_coin,clk_cat;
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
		else Show_Coin[3] <= 0;
		if (Show_Coin[0] == 1) Show_Coin[4] <= 1;
		else Show_Coin[4] <= 0;
		if (Show_Coin[1] == 1) Show_Coin[0] <= 1;
		else Show_Coin[0] <= 0;
		if (Show_Coin[2] == 1) Show_Coin[1] <= 1;
		else Show_Coin[1] <= 0;
		Show_Coin[2] <= 1;
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
					
	wire [9:0]Coin_Display_X_L = (Coin_0)?(X_Coin_OO_L):(Coin_1)?(X_Coin_O1_L):(Coin_2)?(X_Coin_O2_L):(Coin_3)?(X_Coin_O3_L):(Coin_4)?(X_Coin_O4_L):10'b0;
	wire [9:0]Coin_Display_Y_T = (Coin_0)?(Y_Coin_00):(Coin_1)?(Y_Coin_01):(Coin_2)?(Y_Coin_02):(Coin_3)?(Y_Coin_03):(Coin_4)?(Y_Coin_04):10'b0;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//													PIPE																			 //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	wire Pipe_0_T = (x_ptr>=X_Edge_OO_L && x_ptr<=X_Edge_OO_R && (y_ptr<=Y_Edge_00_Top));
	wire Pipe_0_B =(x_ptr>=X_Edge_OO_L && x_ptr<=X_Edge_OO_R && (y_ptr>=Y_Edge_00_Bottom));
	wire Pipe_1_T = (x_ptr>=X_Edge_O1_L && x_ptr<=X_Edge_O1_R && (y_ptr<=Y_Edge_01_Top));
	wire Pipe_1_B = (x_ptr>=X_Edge_O1_L && x_ptr<=X_Edge_O1_R && (y_ptr>=Y_Edge_01_Bottom));
	wire Pipe_2_T = (x_ptr>=X_Edge_O2_L && x_ptr<=X_Edge_O2_R && (y_ptr<=Y_Edge_02_Top));
	wire Pipe_2_B = (x_ptr>=X_Edge_O2_L && x_ptr<=X_Edge_O2_R && (y_ptr>=Y_Edge_02_Bottom));
	wire Pipe_3_T = (x_ptr>=X_Edge_O3_L && x_ptr<=X_Edge_O3_R && (y_ptr<=Y_Edge_03_Top));
	wire Pipe_3_B = (x_ptr>=X_Edge_O3_L && x_ptr<=X_Edge_O3_R && (y_ptr>=Y_Edge_03_Bottom));
	wire Pipe_4_T = (x_ptr>=X_Edge_O4_L && x_ptr<=X_Edge_O4_R && (y_ptr<=Y_Edge_04_Top));
	wire Pipe_4_B = (x_ptr>=X_Edge_O4_L && x_ptr<=X_Edge_O4_R && (y_ptr>=Y_Edge_04_Bottom));
	
	assign Pipe_On = Pipe_0_T || Pipe_0_B||Pipe_1_T || Pipe_1_B||Pipe_2_T || Pipe_2_B||
							Pipe_3_T || Pipe_3_B||Pipe_4_T || Pipe_4_B;

	
	
	wire [9:0]Pipe_Display_X_L = (Pipe_0_T||Pipe_0_B)?(X_Edge_OO_L):
											(Pipe_1_T||Pipe_1_B)?(X_Edge_O1_L):
											(Pipe_2_T||Pipe_2_B)?(X_Edge_O2_L):
											(Pipe_3_T||Pipe_3_B)?(X_Edge_O3_L):
											(Pipe_4_T||Pipe_4_B)?(X_Edge_O4_L): 10'b0;
	wire [9:0]Pipe_Display_Y_T = (Pipe_0_B) ? (Y_Edge_00_Top):			
											(Pipe_1_B) ? (Y_Edge_01_Top):
											(Pipe_2_B) ? (Y_Edge_02_Top):
											(Pipe_3_B) ? (Y_Edge_03_Top):	
											(Pipe_4_B) ? (Y_Edge_04_Top): 10'b0;	
											

	
    assign bg_on = (x_ptr >= LEFT) && (x_ptr < LEFT + BG_W) && (y_ptr >= 0) && (y_ptr < BG_H);

	 reg [9:0] Addr_Buff_Cat=10'd0;
	 reg [8:0] Addr_Buff_coins=9'd4;
	 reg [12:0]Addr_Buff_pipes=13'd4;
	 assign addr_Cat_1 =(((x_ptr)-(Bird_X_L)+1)+(((y_ptr)-(Bird_Y_T)+1)*56));
	 assign addr_Cat_2 =(((x_ptr)-(Bird_X_L)+1)+(((y_ptr)-(Bird_Y_T)+1)*56));
	 assign addr_Cat_3 =(((x_ptr)-(Bird_X_L)+1)+(((y_ptr)-(Bird_Y_T)+1)*56));
	 assign addr_Cat_4 =(((x_ptr)-(Bird_X_L)+1)+(((y_ptr)-(Bird_Y_T)+1)*56));
	 assign addr_coins =(((x_ptr)-(Coin_Display_X_L)+4)+(((y_ptr)-(Coin_Display_Y_T)+1)*20));
	 assign addr_pipes =(((x_ptr)-(Pipe_Display_X_L)+4)+(((y_ptr)-(Pipe_Display_Y_T)+1)*160));
	 wire[7:0] data_Cat=(Cat_1)? (data_Cat_1): (Cat_2)? (data_Cat_2): (Cat_3)? (data_Cat_3): (Cat_4)? (data_Cat_4):8'b0;
	 reg[2:0] Cat_1=1;
	 reg[1:0] Cat_2,Cat_3,Cat_4;
	 reg[3:0] state_Cat=1;
	 	always@(posedge clk_cat) begin
				  case (state_Cat)
					1:begin
					  Cat_1=1;
					  Cat_2=0;
					  Cat_3=0;
					  Cat_4=0;
					  state_Cat=2;
					end
					2:begin
					  Cat_1=0;
					  Cat_2=1;
					  Cat_3=0;
					  Cat_4=0;
					  state_Cat=3;
					end
					3: begin
					  Cat_1=0;
					  Cat_2=0;
					  Cat_3=1;
					  Cat_4=0;
					  state_Cat=4;
					end
					4:begin
					  Cat_1=0;
					  Cat_2=0;
					  Cat_3=0;
					  Cat_4=1;
					  state_Cat=1;
					end
					default:state_Cat=1 ;
				  endcase
				 end
    always @(posedge clk_vga) begin
             if (Cat_On) begin
                    RGB <= (data_Cat!=TRANSPARENT) ? data_Cat : 8'b0;
				end
                else if (Pipe_On) begin
                    RGB <= (data_pipes!=TRANSPARENT) ? data_pipes : 8'b0;
                end
                else if (Coin_On) begin
                    RGB <= (data_coins!=TRANSPARENT) ? data_coins : 8'b0;
                end
        else 
            RGB <= 8'b0;
    end
endmodule 