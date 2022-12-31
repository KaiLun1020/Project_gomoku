# Project_gomoku
## 第十組 邏設期末Project 五子棋  
### Authors: 110321021 110321020 110321024  

#### I/O 介紹:  

IO1 : 4 bits button，從左至右的功能分別是左、上、下、右移動  
![IO1](https://user-images.githubusercontent.com/121676751/210128976-7f908ae0-c258-4957-bf69-789988ccbe9c.png)

IO2 : Switch指撥開關，藍色1的功能是下棋，藍色2的功能是重新開始  
![IO2](https://user-images.githubusercontent.com/121676751/210137357-6125a0d0-d85c-4740-81ad-eef3b7fd997a.png)

IO3 : 8x8全彩LED，功能是顯示棋盤的畫面  
![IO3](https://user-images.githubusercontent.com/121676751/210137476-747858f4-edfa-4151-ba0b-a50cbf35b526.png)

IO4 : 16 bits LED，功能是顯示目前是誰的回合  
![IO4](https://user-images.githubusercontent.com/121676751/210137516-ff916f29-ce59-43a8-a01b-bf84cdc80641.png)

#### 功能說明:  
Player1跟Player2輪流下棋，當自己的棋子以5顆棋子連成一條線就獲勝。  

#### 程式模組說明:  
module project_gomoku(output reg [7:0] DATA_R//紅色燈, DATA_G//綠色燈, DATA_B//藍色燈,
			 output reg [3:0] COMM//控制亮燈排數,
			 output reg b,r//顯示是黑(紅)子還是白(藍)子回合,
			 input CLK,UP//控制是否要往上移動,DOWN//控制是否要往下移動,LEFT//控制是否要往左移動,RIGHT//控制是否要往右移動,ENTER//控制是否要下棋,RE//控制是否要重新開始);
       
{UP,DOWN,LEFT,RIGHT->接到 4 bits button  
 ENTER,RE->接到 Switch指撥開關  
 DATA_R,DATA_G,DATA_B,COMM->接到 8x8全彩LED  
 b,r->接到 16 bits LED}  


### 功能介紹DEMO影片連結:https://drive.google.com/file/d/1SEnBGY2eQH9t7jiU8HJ98v-7J58BFQmq/view?usp=sharing
