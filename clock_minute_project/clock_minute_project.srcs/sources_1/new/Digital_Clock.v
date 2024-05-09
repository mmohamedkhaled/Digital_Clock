`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/09/2024 06:56:13 PM
// Design Name: 
// Module Name: Digital_Clock
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Digital_Clock(
 input clk, input rst, input[4:0] buttons , output  [0:6] segments, output  [3:0] anode,output reg sec);
 wire clk_200;
 wire clk_1;
 wire[3:0]counter_mintue_unites;
wire [2:0]counter_minutes_tens;
 wire [3:0]counter_hours_units;
 wire [1:0]counter_hours_tens;
 
 wire  BTNC,BTND,BTNL,BTNR,BTNU;
 // input clk, rst,input x,output z
  Pushbutton_Detector(clk_200,rst,buttons[4],BTNC);
  Pushbutton_Detector(clk_200,rst,buttons[0],BTNL);
  Pushbutton_Detector(clk_200,rst,buttons[1],BTNR);
  Pushbutton_Detector(clk_200,rst,buttons[3],BTND);
  Pushbutton_Detector(clk_200,rst,buttons[2],BTNU);
 
 reg adjust;
 reg[1:0] adjust_state;
 
 wire en;
 
 reg[1:0] sel;
 reg [3:0] num;
 
 reg [3:0] CurrentState, NextState;
 
 parameter S0= 3'b000,S1= 3'b001,S2= 3'b010,S3= 3'b011,S4= 3'b100,S5= 3'b101;
 
 
 always@(posedge clk_200 or posedge rst)begin
 
 if(rst==1)begin
 sel=2'b00;
 end
 else
 sel=sel+1;

 end
 
 always@(sel)begin
 case(sel)
 0:  num<= counter_mintue_unites;
 1: num<=counter_minutes_tens;
 2: num<=counter_hours_units;
 3: num<= counter_hours_tens;
 
 endcase
 
 if(sel==2)begin
  if(adjust==0)
    sec=clk_1;
    else
    sec=1;
 end
 else 
 sec=1;

 
 end
 

 
 wire LorR;
 assign LorR=BTNL | BTNR;

wire increment , decremrent;
always@(CurrentState, adjust, adjust_state,increment , decremrent)begin
case(CurrentState)
S0:if(adjust == 1) // clock
        NextState = S1;
    else
        NextState = S0;
S1:if(adjust == 1)// adjust hours time
        if(adjust_state == 1)
        NextState = S2;
    else
        NextState = S0;
S2:if(adjust == 1)
        NextState = S3;
    else
        NextState = S0;
S3:if(adjust == 1)
        NextState = S4;
    else
        NextState = S0;
S4:if(adjust == 1)
        NextState = S1;
    else
        NextState = S0;
endcase

end


always@(posedge LorR or posedge BTNC or posedge BTNU or posedge BTND or posedge rst )begin
    if(rst)
        CurrentState <= S0;
    else begin  
        if(BTNC)
            if(adjust==0)
                 adjust=1;
            else 
                 adjust=0;
        else if(LorR)
            if(adjust == 0)
                adjust_state = 0;
            else if(adjust == 4)
                adjust_state = 1;
            else 
                adjust_state = adjust_state + 1;
        else if(BTNU)
       CurrentState <= NextState;
    end

end

//always@ ( adjust_state )begin
//case(adjust_state)
//0: 
//1:
//2:
//3:

//end


//always@(posedge BTNU or posedge BTND)begin

//if(BTNU==1)begin


//end


//end
 
 assign en= adjust==0? 1'b1 :1'b0;
  clock_divider #(250000) clk_200_generate(.clk(clk), .rst(rst),  .clk_out(clk_200));
 //always@()
 Sev_segment_display (sel,num,anode,segments);
 // input [1:0] sel, input[3:0] num,output reg [3:0] active_anode,output reg [6:0] segments
 clock_divider #(50000) clk_1_generate(.clk(clk), .rst(rst),  .clk_out(clk_1));
 //input clk_out, input reset, input en 
//,output [3:0]counter1,output [3:0]counter2,output [3:0]counter3,output [3:0]counter4
  secounds_mintues_counter(clk_1,rst,en,counter_mintue_unites,counter_minutes_tens,counter_hours_units,counter_hours_tens);
 
endmodule
