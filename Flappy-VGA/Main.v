`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// VGA verilog template
// Author:  Da Cheng
//////////////////////////////////////////////////////////////////////////////////

module Main(clk_100MHz, vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b, 
	Sw7, Sw6, Sw5, Sw4, Sw3, Sw2, Sw1, Sw0,
	BtnL, BtnU, BtnD, BtnR, BtnC,
	St_ce_bar, St_rp_bar, Mt_ce_bar, Mt_St_oe_bar, Mt_St_we_bar,
	An0, An1, An2, An3, 
	Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp,
	Ld7, Ld6, Ld5, Ld4, Ld3, Ld2, Ld1, Ld0);
	
		/*  INPUTS */
	input wire	clk_100MHz;
	input	wire  Sw7, Sw6, Sw5, Sw4, Sw3, Sw2, Sw1, Sw0;
	input wire BtnL, BtnR, BtnC, BtnU, BtnD;
	
	output wire	St_ce_bar, St_rp_bar, Mt_ce_bar, Mt_St_oe_bar, Mt_St_we_bar;
	output wire	vga_h_sync, vga_v_sync;
	output wire [2:0] vga_r;
	output wire  [2:0] vga_g;
	output wire [1:0] vga_b;
	output wire	An0, An1, An2, An3;
	output wire	Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp;
	output wire 	Ld0, Ld1, Ld2, Ld3, Ld4, Ld5, Ld6, Ld7;



	
	wire [7:0] RGB, data_Cat,data_pipes,data_coins;
	wire[8:0] addr_coins;
	wire [9:0]addr_Cat;
	wire [12:0] addr_pipes;
	
	
	
	
	//////////////////////////////////////////////////////////////////////////////////////////
	/*  LOCAL SIGNALS */
	wire	Reset, board_clk, sys_clk;
	
	// Inputs to the core design
	wire Start, Ack;
	wire [2:0] X_Index; // index of pipe to read
	wire [2:0] X_Index_Coin; // index of coin to read
	// Outputs from the core design
	wire [9:0] X_Edge_OO_L;
	wire [9:0] X_Edge_OO_R;
	wire [9:0] X_Edge_O1_L;
	wire [9:0] X_Edge_O1_R;
	wire [9:0] X_Edge_O2_L;
	wire [9:0] X_Edge_O2_R;
	wire [9:0] X_Edge_O3_L;
	wire [9:0] X_Edge_O3_R;
	wire [9:0] X_Edge_O4_L;
	wire [9:0] X_Edge_O4_R;
	// Coin's x
	wire [9:0] X_Coin_OO_L;
	wire [9:0] X_Coin_O1_L;
	wire [9:0] X_Coin_O2_L;
	wire [9:0] X_Coin_O3_L;
	wire [9:0] X_Coin_O4_L;
	wire [9:0] X_Coin_OO_R;
	wire [9:0] X_Coin_O1_R;
	wire [9:0] X_Coin_O2_R;
	wire [9:0] X_Coin_O3_R;
	wire [9:0] X_Coin_O4_R;
	
	wire [9:0] Y_Edge_00_Top;
	wire [9:0] Y_Edge_00_Bottom;
	wire [9:0] Y_Edge_01_Top;
	wire [9:0] Y_Edge_01_Bottom;
	wire [9:0] Y_Edge_02_Top;
	wire [9:0] Y_Edge_02_Bottom;
	wire [9:0] Y_Edge_03_Top;
	wire [9:0] Y_Edge_03_Bottom;
	wire [9:0] Y_Edge_04_Top;
	wire [9:0] Y_Edge_04_Bottom;
	// Coin's y
	wire [9:0] Y_Coin_00;
	wire [9:0] Y_Coin_01;
	wire [9:0] Y_Coin_02;
	wire [9:0] Y_Coin_03;
	wire [9:0] Y_Coin_04;
	// Show_Coin
//	wire [4:0] Show_Coin;
	reg [4:0] Show_Coin;
	// Signanl from coin logic
	wire [1:0] get_Zero;
	// Signanl from RAM for coin shift
	wire [1:0] shift_Coin;

	wire Done;
	wire q_Initial, q_Check, q_Lose;
	wire q_InitialX, q_Count, q_Stop;
	wire q_InitialF, q_Flight, q_StopF;
	wire [9:0]	Score;
	
	wire [9:0] Bird_X_L;
	wire [9:0] Bird_Y_T;
	wire [9:0] Bird_X_R;
	wire [9:0] Bird_Y_B;
	wire BtnC_Pulse, BtnL_Pulse, BtnD_Pulse, BtnR_Pulse, BtnU_Pulse;
	 
	wire [1:0] 	ssdscan_clk;
	reg [1:0] state_num;
	reg[1:0] state_num_2;
	
	//BUF BUF1 (board_clk, clk_100MHz); 	
	//BUF BUF2 (Reset, Sw0);
	//BUF BUF3 (Start, Sw1);
	
	reg [27:0]	DIV_CLK;
	always @ (posedge clk_100MHz, posedge Reset)  
	begin : CLOCK_DIVIDER
      if (Reset)
			begin
				DIV_CLK <= 0;
			end
      else
			DIV_CLK <= DIV_CLK + 1'b1;
	end	

    Clock_div clock_div(
        .clk(clk_100MHz),
        .clk_pace(clk_pace),
        .clk_game(clk_game),
        .clk_move(clk_move),
        .clk_vga(clk_vga),
        .clk_seg(scanning)
    );
	assign 	{St_ce_bar, St_rp_bar, Mt_ce_bar, Mt_St_oe_bar, Mt_St_we_bar} = {5'b11111};
	
	wire inDisplayArea;
	wire [9:0] CounterX;
	wire [9:0] CounterY;
	assign sys_clk = board_clk;
	
	VGA_Adapter syncgen(.clk(clk_vga), .hsync(vga_h_sync), .vsync(vga_v_sync), .valid(valid), .x_ptr(CounterX), .y_ptr(CounterY));
	
	/////////////////////////////////////////////////////////////////
	///////////////		VGA control starts here		/////////////////
	/////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//													GRAPHIC																			 //

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	Cat Cat(.clka(clk_vga), .addra(addr_Cat), .douta(data_Cat));
	coin Coin(.clka(clk_vga), .addra(addr_coins), .douta(data_coins));
	pipe Pipe (.clka(clk_vga), .addra(addr_pipes),.douta(data_pipes));


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//												DISPLAY	control																		 //

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   Display_Selector selector(
	.clk_100MHz(clk_100MHz),
	.data_Cat(data_Cat),
	.data_pipes(data_pipes),.data_coins(data_coins),
	.addr_Cat(addr_Cat),
	.addr_pipes(addr_pipes),.addr_coins(addr_coins),
.clk_coin(DIV_CLK[19]), .q_Initial(q_Initial), .shift_Coin(shift_Coin),.get_Zero(get_Zero),
    .X_Edge_OO_L(X_Edge_OO_L),
	.X_Edge_O1_L(X_Edge_O1_L),
	.X_Edge_O2_L(X_Edge_O2_L),
	.X_Edge_O3_L(X_Edge_O3_L),
	.X_Edge_O4_L(X_Edge_O4_L),
	.X_Edge_OO_R(X_Edge_OO_R),
	.X_Edge_O1_R(X_Edge_O1_R),
	.X_Edge_O2_R(X_Edge_O2_R),
	.X_Edge_O3_R(X_Edge_O3_R),
	.X_Edge_O4_R(X_Edge_O4_R),
	.Bird_Y_T(Bird_Y_T), .Bird_Y_B(Bird_Y_B), .Bird_X_R(Bird_X_R),.Bird_X_L(Bird_X_L),
	 .X_Coin_OO_L(X_Coin_OO_L),
	 .X_Coin_O1_L(X_Coin_O1_L),
	 .X_Coin_O2_L(X_Coin_O2_L),
	 .X_Coin_O3_L(X_Coin_O3_L),
	 .X_Coin_O4_L(X_Coin_O4_L),
	 .X_Coin_OO_R(X_Coin_OO_R),
	 .X_Coin_O1_R(X_Coin_O1_R),
	 .X_Coin_O2_R(X_Coin_O2_R),
	 .X_Coin_O3_R(X_Coin_O3_R),
	 .X_Coin_O4_R(X_Coin_O4_R),
     .Y_Coin_00(Y_Coin_00),
	.Y_Coin_01(Y_Coin_01),
	.Y_Coin_02(Y_Coin_02),
	.Y_Coin_03(Y_Coin_03),
	.Y_Coin_04(Y_Coin_04),
	.Y_Edge_00_Top(Y_Edge_00_Top),
	.Y_Edge_00_Bottom(Y_Edge_00_Bottom),
	.Y_Edge_01_Top(Y_Edge_01_Top),
	.Y_Edge_01_Bottom(Y_Edge_01_Bottom),
	.Y_Edge_02_Top(Y_Edge_02_Top),
	.Y_Edge_02_Bottom(Y_Edge_02_Bottom),
	.Y_Edge_03_Top(Y_Edge_03_Top),
	.Y_Edge_03_Bottom(Y_Edge_03_Bottom),
	.Y_Edge_04_Top(Y_Edge_04_Top),
	.Y_Edge_04_Bottom(Y_Edge_04_Bottom),
                        .clk_vga(clk_vga), .x_ptr(CounterX), .y_ptr(CounterY), .RGB(RGB)
	
    );

//	wire R,G,B;
	VGA_Render render(valid, RGB, vga_r,vga_g,vga_b);
//always @(posedge sys_clk)
//	begin
//		vga_r[2:0] <= {3{R}};
//		vga_g[2:0] <= {3{G}};
//		vga_b[1:0] <= {2{B}};
//	end

	//Flash when you lost
	
//	reg Flash_Blue;
//	
//	always @(posedge DIV_CLK[22])
//		begin
//			Flash_Blue <= 0;
//			if (q_Lose)
//				Flash_Blue <= ~Flash_Blue;				
//		end
	

	/////////////////////////////////////////////////////////////////
	//////////////  	  LD control starts here 	 ////////////////
	/////////////////////////////////////////////////////////////////
	//reg VGA_R = vga_r;
	//reg VGA_G = vga_g;
	//reg VGA_B = vga_b;
	//assign {Ld7, Ld6, Ld5} = {VGA_R, VGA_G, VGA_B}; // r, g, b
	//assign {Ld4, Ld3, Ld2, Ld1, Ld0} = {BtnL, BtnR, BtnU, BtnD, BtnC}; 
	
	/////////////////////////////////////////////////////////////////
	//////////////  	  LD control ends here 	 	/////////////////
	/////////////////////////////////////////////////////////////////
	
	/////////////////////////////////////////////////////////////////
	//////////////  	  SSD control starts here 	 ////////////////
	/////////////////////////////////////////////////////////////////
	reg 	[3:0]	SSD;
	wire 	[3:0]	SSD0, SSD1, SSD2, SSD3;
	
	assign SSD0 = Score[9:0]%10; 
	assign SSD1 = (Score[9:0]/10)%10;
	assign SSD2 = (Score[9:0]/100)%10;
	assign SSD3 = 0;
	
	// need a scan clk for the seven segment display 
	// 191Hz (50MHz / 2^18) works well
	assign ssdscan_clk = DIV_CLK[19:18];	
	assign An0	= !(~(ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 00
	assign An1	= !(~(ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 01
	assign An1	= !(~(ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 01
	assign An2	= !( (ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 10
	assign An3	= !( (ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 11	
	
	always @ (ssdscan_clk, SSD0, SSD1, SSD2, SSD3)
	begin : SSD_SCAN_OUT
		case (ssdscan_clk) 
				  2'b00: SSD =     SSD0 ;	// ****** TODO  in Part 2 ******
				  2'b01: SSD =     SSD1;  	// Complete the four lines
				  2'b10: SSD =     SSD2;
				  2'b11: SSD =     SSD3;
		endcase 
	end

	// and finally convert SSD_num to ssd
	reg [6:0]  SSD_CATHODES;
	assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp} = {SSD_CATHODES, 1'b1};
	// Following is Hex-to-SSD conversion
	always @ (SSD) 
	begin : HEX_TO_SSD
		case (SSD)		
			4'b1111: SSD_CATHODES = 7'b1111111 ; //Nothing 
			4'b0000: SSD_CATHODES = 7'b0000001 ; //0
			4'b0001: SSD_CATHODES = 7'b1001111 ; //1
			4'b0010: SSD_CATHODES = 7'b0010010 ; //2
			4'b0011: SSD_CATHODES = 7'b0000110 ; //3
			4'b0100: SSD_CATHODES = 7'b1001100 ; //4
			4'b0101: SSD_CATHODES = 7'b0100100 ; //5
			4'b0110: SSD_CATHODES = 7'b0100000 ; //6
			4'b0111: SSD_CATHODES = 7'b0001111 ; //7
			4'b1000: SSD_CATHODES = 7'b0000000 ; //8
			4'b1001: SSD_CATHODES = 7'b0000100 ; //9
			4'b1010: SSD_CATHODES = 7'b0001000 ; //10 or A
			default: SSD_CATHODES = 7'bXXXXXXX ; // default is not needed as we covered all cases
		endcase
	end
	
	/////////////////////////////////////////////////////////////////
	//////////////  	  SSD control ends here 	 ///////////////////
	/////////////////////////////////////////////////////////////////
	/* BUTTON SIGNAL ASSIGNMENT */
	assign Reset = BtnR;

	X_RAM_NOREAD x_ram(.clk(DIV_CLK[19]),.reset(BtnR),.Start(BtnC), .Stop(q_Lose), .Ack(BtnD), .out_pipe(X_Index), .out_coin(X_Index_Coin),
		.X_Edge_OO_L(X_Edge_OO_L), .X_Edge_O1_L(X_Edge_O1_L), .X_Edge_O2_L(X_Edge_O2_L), .X_Edge_O3_L(X_Edge_O3_L),.X_Edge_O4_L(X_Edge_O4_L), 
		.X_Edge_OO_R(X_Edge_OO_R), .X_Edge_O1_R(X_Edge_O1_R), .X_Edge_O2_R(X_Edge_O2_R), .X_Edge_O3_R(X_Edge_O3_R), .X_Edge_O4_R(X_Edge_O4_R), 
		.X_Coin_OO_L(X_Coin_OO_L), .X_Coin_O1_L(X_Coin_O1_L), .X_Coin_O2_L(X_Coin_O2_L), .X_Coin_O3_L(X_Coin_O3_L), .X_Coin_O4_L(X_Coin_O4_L),
		.X_Coin_OO_R(X_Coin_OO_R), .X_Coin_O1_R(X_Coin_O1_R), .X_Coin_O2_R(X_Coin_O2_R), .X_Coin_O3_R(X_Coin_O3_R), .X_Coin_O4_R(X_Coin_O4_R),
		.shift_Coin(shift_Coin),
		.Q_Initial(q_InitialX), .Q_Count(q_Count), .Q_Stop(q_Stop));	

	Y_ROM y_rom(.clk(DIV_CLK[19]), .I(X_Index), .IC(X_Index_Coin),
		.YEdge0T(Y_Edge_00_Top), 
		.YEdge0B(Y_Edge_00_Bottom),
		.YEdge1T(Y_Edge_01_Top), 
		.YEdge1B(Y_Edge_01_Bottom),
		.YEdge2T(Y_Edge_02_Top),
		.YEdge2B(Y_Edge_02_Bottom),
		.YEdge3T(Y_Edge_03_Top),
		.YEdge3B(Y_Edge_03_Bottom),
		.YEdge4T(Y_Edge_04_Top),
		.YEdge4B(Y_Edge_04_Bottom),
		.YCoin0(Y_Coin_00), 
		.YCoin1(Y_Coin_01),
		.YCoin2(Y_Coin_02),
		.YCoin3(Y_Coin_03),
		.YCoin4(Y_Coin_04)
		);
	

	obstacle_logic obs_log(.Clk(clk_vga),.reset(BtnR),.Q_Initial(q_Initial),.Q_Check(q_Check),.Q_Lose(q_Lose),
		.Start(BtnC), .Ack(BtnC), 
		.X_Edge_Left(X_Edge_OO_L),
		.X_Edge_Right(X_Edge_OO_R),
		.Y_Edge_Top(Y_Edge_00_Top),
		.Y_Edge_Bottom(Y_Edge_00_Bottom),
		.Bird_X_L(Bird_X_L), .Bird_X_R(Bird_X_R), .Bird_Y_T(Bird_Y_T), .Bird_Y_B(Bird_Y_B));
	
		
	coin_logic coin_log(.Clk(clk_vga),.reset(BtnR), .Score(Score),
		.Start(BtnC), .Ack(BtnC), 
		.X_Coin_OO_L(X_Coin_OO_L),
		.X_Coin_OO_R(X_Coin_OO_R),
		.Y_Coin_00(Y_Coin_00),
		.get_Zero(get_Zero),
		.Bird_X_L(Bird_X_L), .Bird_X_R(Bird_X_R), .Bird_Y_T(Bird_Y_T), .Bird_Y_B(Bird_Y_B));
			

	flight_control flight_control(.Clk(DIV_CLK[20]), .reset(BtnR), .Start(BtnC), .Ack(BtnC), .Stop(q_Lose),
		.BtnU(BtnU), .BtnD(BtnD), .Bird_X_L(Bird_X_L),  .Bird_X_R(Bird_X_R), .Bird_Y_T(Bird_Y_T),  .Bird_Y_B(Bird_Y_B),
		.q_Initial(q_InitialF), .q_Flight(q_Flight), .q_Stop(q_StopF));
endmodule
