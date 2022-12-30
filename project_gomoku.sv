module project_gomoku(output reg [7:0] DATA_R, DATA_G, DATA_B,
			 output reg [3:0] COMM,
			 output reg b,r,
			 input CLK,UP,DOWN,LEFT,RIGHT,ENTER,RE);

	parameter logic [7:0] winemoji [7:0] =        //紅藍各自贏的圖案
	    '{8'b11111011,
	      8'b11011101,
              8'b10111011,
	      8'b01111111,
	      8'b01111111,
	      8'b10111011,
	      8'b11011101,
	      8'b11111011};
	
	parameter logic [7:0] nowinemojiRed [7:0] =   //平手圖案Red
	    '{8'b10010110,
	      8'b01100110,
              8'b01101101,
	      8'b10001110,
	      8'b11100011,
	      8'b00111110,
	      8'b11100000,
	      8'b00111100};
			
	parameter logic [7:0] nowinemojiGreen [7:0] =  //平手圖案Green
	    '{8'b11100010,
	      8'b01100110,
              8'b10010010,
	      8'b00100100,
	      8'b00100001,
	      8'b11001110,
       	      8'b11100000,
	      8'b11100110};
			
	parameter logic [7:0] nowinemojiBlue [7:0] =   //平手圖案Blue
	    '{8'b00110011,
	      8'b10001100,
              8'b00111011,
	      8'b01010101,
	      8'b10101010,
	      8'b00011100,
	      8'b00100100,
              8'b01100111};
	
	logic [7:0] RED [7:0] ='{8'b11111111,//RED = black
								         8'b11111111,
									 8'b11111111,
									 8'b11111111,
									 8'b11111111,
									 8'b11111111,
									 8'b11111111,
									 8'b11111111};
													  
	logic [7:0] BLUE [7:0] ='{8'b11111111,//BLUE = white
									  8'b11111111,
									  8'b11111111,
									  8'b11111111,
									  8'b11111111,
									  8'b11111111,
									  8'b11111111,
									  8'b11111111};
													 
	logic [7:0] DARK [7:0] ='{8'b00000000,//DARK = 可以下子的點
									  8'b00000000,
									  8'b00000000,
									  8'b00000000,
									  8'b00000000,
									  8'b00000000,
									  8'b00000000,
									  8'b00000000};
														
	logic [7:0] CURRENTPOS [7:0] = '{8'b11111111,//CURRENTPOS = 目前的下棋位置
											   8'b11111111,
											   8'b11111111,
											   8'b11101111,
											   8'b11111111,
											   8'b11111111,
											   8'b11111111,
											   8'b11111111};
	divfreq F0(CLK,CLK_div);
	divfreq2 F1(CLK,CLK_div2);
	bit [2:0] cnt;
	byte prow;
	byte pcol;
	bit redplayer = 1;
	bit redwin = 0;
	bit bluewin = 0;
	bit mode = 0;
	byte count;
	
	initial//初始值
		begin
		   r = 1;         //顯示黑子的回合
			b = 0;         //顯示白子的回合
			cnt = 0;			//顯示亮哪行
			pcol = 4;			//落子column
			prow = 4;			//落子row
			count = 0;        //count 棋子
		end
		
	always @(posedge CLK_div)//偵測上下左右
		begin
					if (DOWN == 1 && mode == 0)//下
						begin
						  pcol = pcol + 1;
						  if (pcol == 8)
							  begin
							    pcol = 0;
							    CURRENTPOS[prow][7] <= 1;
							    CURRENTPOS[prow][0] <= 0;
							  end
						  else
							  begin
							    CURRENTPOS[prow][pcol - 1] = 1;
							    CURRENTPOS[prow][pcol] = 0; 
							  end
					   end
					else if (UP == 1 && mode == 0)//上
						begin
						   pcol = pcol - 1;
							if (pcol == -1)
								begin
								  pcol = 7;
								  CURRENTPOS[prow][0] <= 1;
								  CURRENTPOS[prow][7] <= 0;
								end
							else
								begin
								  CURRENTPOS[prow][pcol + 1] = 1;
								  CURRENTPOS[prow][pcol] = 0; 
								end
						end
					else if (LEFT == 1 && mode == 0)//左
						begin
						   prow = prow - 1;
							if (prow == -1)
								begin
								  prow = 7;
								  CURRENTPOS[0][pcol] <= 1;
								  CURRENTPOS[7][pcol] <= 0;
								end
							else
								begin
								  CURRENTPOS[prow + 1][pcol] = 1;
								  CURRENTPOS[prow][pcol] = 0;
								end
						end
					else if (RIGHT == 1 && mode == 0)//右
						begin
							prow = prow + 1;
							if (prow == 8)
								begin
								  prow = 0;
								  CURRENTPOS[7][pcol] <= 1;
								  CURRENTPOS[0][pcol] <= 0;
								end
							else
								begin
								  CURRENTPOS[prow - 1][pcol] = 1;
								  CURRENTPOS[prow][pcol] = 0;
								end
						end
		end
		
		always @(posedge ENTER) //當ENTER trigger 時
		  begin
		       if(RE)//restart
					 begin
					    redwin = 0;
						 bluewin = 0;
						 mode = 0;
						 count = 0;
					    r = 1;
			          b = 0;
						 redplayer = 1;
						 for(int i = 0; i < 8; i++)
							   for(int j = 0; j < 8; j++)
								   begin
									   DARK[i][j] <= 0;
									   RED[i][j] <= 1;
									   BLUE[i][j] <= 1;
								   end
					 end
					 
				 else if(DARK[prow][pcol] == 0 && redplayer == 1 && mode == 0)//如果可下子且輪到紅色
					 begin
						  b = ~b;
						  r = ~r;
						  count = count + 1;
						  DARK[prow][pcol] <= 1;
					     RED[prow][pcol] <= 0;
						  redplayer = ~redplayer;
					 end
						
				 else if (DARK[prow][pcol] == 0 && redplayer == 0 && mode == 0)//如果可下子且輪到藍色
				    begin
						  b = ~b;
						  r = ~r;
						  count = count + 1;
						  DARK[prow][pcol] <= 1;
					     BLUE[prow][pcol] <= 0;
						  redplayer = ~redplayer;
				    end
					 
					for(int i = 0; i < 8; i++)
							for(int j = 0; j < 4; j++)
								if(RED[i][j] == 0 && RED[i][j + 1] == 0 && RED[i][j + 2] == 0 && RED[i][j + 3] == 0 && RED[i][j + 4] == 0)
									redwin = 1;
					for(int i = 0; i < 4; i++)
							for(int j = 0; j < 8; j++)
								if(RED[i][j] == 0 && RED[i + 1][j] == 0 && RED[i + 2][j] == 0 && RED[i + 3][j] == 0 && RED[i + 4][j] == 0)
									redwin = 1;
					for(int i = 0; i < 4; i++)
							for(int j = 0; j < 4; j++)
								if(RED[i][j] == 0 && RED[i + 1][j + 1] == 0 && RED[i + 2][j + 2] == 0 && RED[i + 3][j + 3] == 0 && RED[i + 4][j + 4] == 0)
									redwin = 1;
					for(int i = 0; i < 4; i++)
							for(int j = 4; j < 8; j++)
								if(RED[i][j] == 0 && RED[i + 1][j - 1] == 0 && RED[i + 2][j - 2] == 0 && RED[i + 3][j - 3] == 0 && RED[i + 4][j - 4] == 0)
									redwin = 1;
									
					for(int i = 0; i < 8; i++)
							for(int j = 0; j < 4; j++)
								if(BLUE[i][j] == 0 && BLUE[i][j + 1] == 0 && BLUE[i][j + 2] == 0 && BLUE[i][j + 3] == 0 && BLUE[i][j + 4] == 0)
									bluewin = 1;
					for(int i = 0; i < 4; i++)
							for(int j = 0; j < 8; j++)
								if(BLUE[i][j] == 0 && BLUE[i + 1][j] == 0 && BLUE[i + 2][j] == 0 && BLUE[i + 3][j] == 0 && BLUE[i + 4][j] == 0)
									bluewin = 1;
					for(int i = 0; i < 4; i++)
							for(int j = 0; j < 4; j++)
								if(BLUE[i][j] == 0 && BLUE[i + 1][j + 1] == 0 && BLUE[i + 2][j + 2] == 0 && BLUE[i + 3][j + 3] == 0 && BLUE[i + 4][j + 4] == 0)
									bluewin = 1;
					for(int i = 0; i < 4; i++)
							for(int j = 4; j < 8; j++)
								if(BLUE[i][j] == 0 && BLUE[i + 1][j - 1] == 0 && BLUE[i + 2][j - 2] == 0 && BLUE[i + 3][j - 3] == 0 && BLUE[i + 4][j - 4] == 0)
									bluewin = 1;
					if(redwin == 1 || bluewin == 1 || count == 64)
					   mode = 1;
		  end
			 
		always @(posedge CLK_div2)      //顯示8x8全彩LED畫面
		  begin
			 if(cnt >= 7)
				  cnt = 0;
			 else
				  cnt = cnt + 1;
			 COMM = {1'b1,cnt};
			 begin
			    if(mode == 0)
				    begin
						DATA_R <= RED[cnt];
						DATA_B <= BLUE[cnt];
						DATA_G <= CURRENTPOS[cnt];
					 end
				 else
				    begin
					   if(redwin)
					     begin
							 DATA_R <= winemoji[cnt];
							 DATA_B <= 8'b11111111;
					       DATA_G <= 8'b11111111;
						  end
						else if(bluewin)
						  begin
						    DATA_R <= 8'b11111111;
							 DATA_B <= winemoji[cnt];
					       DATA_G <= 8'b11111111;
						  end
						else if(count == 64)
						  begin
						    DATA_R <= nowinemojiRed[cnt];
							 DATA_B <= nowinemojiBlue[cnt];
					       DATA_G <= nowinemojiGreen[cnt];
						  end
			       end
			  end
		  end
endmodule

//除頻器1
module divfreq(input CLK, output reg CLK_div);
	reg [24:0] Count;
	always @(posedge CLK)
		begin
			if(Count > 3000000)
				begin
					Count <= 25'b0;
					CLK_div <= ~CLK_div;
				end
			else Count <= Count + 1'b1;
		end
endmodule


//除頻器2
module divfreq2(input CLK, output reg CLK_div2);
	reg [24:0] Count;
	always @(posedge CLK)
		begin
			if(Count > 5000)
				begin
					Count <= 25'b0;
					CLK_div2 <= ~CLK_div2;
				end
			else Count <= Count + 1'b1;
		end
endmodule
