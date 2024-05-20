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
 input clk, input rst, input[4:0] buttons , output  [0:6] segments, output  [3:0] anode,output reg [3:0] led , output reg sec, output reg alarm_led);
 
 
 wire clk_200;
 wire clk_1;
 
 
 wire[3:0]counter_mintue_unites;
 wire [2:0]counter_minutes_tens;
 wire [3:0]counter_hours_units;
 wire [1:0]counter_hours_tens;
 
wire[3:0]alarm_mintue_units;
wire [2:0]alarm_minutes_tens;
wire [3:0]alarm_hours_units;
wire [1:0]alarm_hours_tens;
 
 
 wire[3:0] zflag;
 wire final_zero_check;
 
 wire  BTNC,BTND,BTNL,BTNR,BTNU;
  
 Pushbutton_Detector(clk_200,rst,buttons[0],BTNL);
 Pushbutton_Detector(clk_200,rst,buttons[1],BTNR);
 Pushbutton_Detector(clk_200,rst,buttons[2],BTNU);
 Pushbutton_Detector(clk_200,rst,buttons[3],BTND);
 Pushbutton_Detector(clk_200,rst,buttons[4],BTNC);

 reg clk_input;
 reg en_secs;
 
 reg en_adjust_time_min;
 reg en_adjust_time_Hours;
 reg en_adjust_alarm_min;
reg en_adjust_alarm_Hours;

 reg clock_alarm;

 
 
 reg[1:0] sel;
 reg [3:0] num;
 reg up_down;
 reg [3:0] CurrentState, NextState;
 
 parameter S0= 3'b000,S1= 3'b001,S2= 3'b010,S3= 3'b011,S4= 3'b100,S5= 3'b101;
 
 

 
always@(sel)begin
    case(sel)
        0: begin  
        if(clock_alarm==1)
        num<= counter_mintue_unites;
        else 
        num<= alarm_mintue_units;
        end
        1: begin 
        if(clock_alarm==1)
        num<=counter_minutes_tens;
        else
        num<= alarm_minutes_tens;
        end
        2: begin
        if(clock_alarm==1)
         num<=counter_hours_units;
         else
        num<=alarm_hours_units;
         end
        3: begin
         if(clock_alarm==1)
         num<= counter_hours_tens; 
         else
          num<= alarm_hours_tens;
         end
    endcase
end
 

wire blink;
reg AlarmDefuse;

always@(CurrentState, BTNC, BTNL, BTNU, BTNR,BTND,final_zero_check)begin
    case(CurrentState)
        S0:begin  // clock
            clk_input = clk_1; 
            en_secs = 1'b1;
            alarm_led = 0;
            led = 4'd0;
            en_adjust_time_min = 0;
            en_adjust_time_Hours = 0;
            sec = clk_1;
            clock_alarm=1'b1;
            //AlarmDefuse = 1;
            up_down = 1;
            if(final_zero_check==1 && AlarmDefuse==0)
                NextState=S5;
             if(BTNC == 1) 
                NextState = S1;
            else
                NextState = S0;
        end
        S1:begin // adjust Time hours
            AlarmDefuse = 0;
            clk_input = clk_200; 
            sec = 1;
            en_secs = 1'b0;
            alarm_led = 1;
            led[1] = 1;
            up_down=1;
            clock_alarm=1'b1;
            en_adjust_time_min = 0;
            en_adjust_time_Hours = 0;
            if(BTNC == 1)
                NextState = S0;
            else if(BTNL | BTNR == 1)
                NextState = S2;
            else if(BTNU)begin // increment time hours
            en_adjust_time_Hours = 1;
                up_down=1;
                NextState = S1;
            end
            else if(BTND)
            begin
            en_adjust_time_Hours = 1;
                up_down=0;
                NextState = S1;
            end
            else
                NextState = S1;
        end        

        S2:begin// adjust Time Minutes
            clk_input = clk_200; 
            sec = 1;
            up_down=1;
            clock_alarm=1'b1;
            en_secs = 1'b0;
            led = 4'b0010;
            en_adjust_time_min = 0;
            en_adjust_time_Hours = 0;
            if(BTNC == 1)
                NextState = S0;
            else if(BTNL | BTNR == 1)
                NextState = S3;
            else if(BTNU)begin // incremnet minutes
                up_down=1;
                en_adjust_time_min = 1;
                NextState = S2;
            end
            else if(BTND)
            begin
                up_down=0;
                en_adjust_time_min = 1;
                NextState = S2;
            end
            else
                NextState = S2;
        end

        S3:begin// adjust Alarm Hours
            clk_input = clk_200; 
            sec = 1;
            en_secs = 1'b0;
            led = 4'b0100;
            up_down=1;
            en_adjust_time_min = 0;
            en_adjust_time_Hours = 0;
            clock_alarm=1'b0;
            en_adjust_alarm_min = 0;
            en_adjust_alarm_Hours = 0;
            if(BTNC == 1) 
                NextState = S0;
            else if(BTNL | BTNR == 1)
                NextState = S4;
            else if(BTNU)begin
                 up_down=1;
                en_adjust_alarm_Hours = 1;
                NextState = S3;
                end
            else if(BTND)begin
                up_down=0;
                en_adjust_alarm_Hours = 1;
                NextState = S3;
            end
            else
                NextState = S3;
        end
        
        S4:begin// adjust Alarm Minutes
            clk_input = clk_200; 
            sec = 1;
            up_down=1;
            en_secs = 1'b0;
            clock_alarm=1'b0;
            led = 4'b1000;
            en_adjust_time_min = 0;
            en_adjust_time_Hours = 0;
            en_adjust_alarm_min = 0;
            en_adjust_alarm_Hours = 0;
            if(BTNC == 1)
                NextState = S0;
            else if(BTNL | BTNR == 1)
                NextState = S1;
            else if(BTNU)begin
                 up_down=1;
                en_adjust_alarm_min = 1;
                NextState = S4;
                end
            else if(BTND)begin
                up_down=0;
                en_adjust_alarm_min = 1;
                NextState = S4;
                end
            else
                NextState = S4;
        end
        
    S5:  
     begin 
        led = 4'b0000;
        alarm_led=1'b1;
        if( BTNC==1 | BTND==1 | BTNL==1 | BTNR==1 | BTNU==1 )begin
            AlarmDefuse=1'b1;
            NextState = S0;
            end
        else
            NextState = S5;
        end
    endcase
    
end


always@(posedge clk_200 or posedge rst )begin
    if(rst)begin
        sel=2'b00;
        CurrentState <= S0;
    end
    else begin
        sel=sel+1;
        CurrentState = NextState;
    end
end

assign zflag[0]=(alarm_mintue_units==counter_mintue_unites);
assign zflag[1]=(alarm_minutes_tens==counter_minutes_tens);
assign zflag[2]=(alarm_hours_units==counter_hours_units);
assign zflag[3]=(alarm_hours_tens==counter_hours_tens);

assign final_zero_check= zflag[0] && zflag[1]  && zflag[2] && zflag[3];

clock_divider #(250000) clk_200_generate(.clk(clk), .rst(rst),  .clk_out(clk_200));

Sev_segment_display (sel,num,anode,segments);
clock_divider #(50000000) clk_1_generate(.clk(clk), .rst(rst),  .clk_out(clk_1));


 secounds_mintues_counter(clk_input,rst,en_secs, en_adjust_time_min,en_adjust_time_Hours,up_down,counter_mintue_unites,counter_minutes_tens,counter_hours_units,counter_hours_tens);
  Alarm_Counter(clk_input,rst, en_adjust_alarm_min ,en_adjust_alarm_Hours,up_down,alarm_mintue_units,alarm_minutes_tens,alarm_hours_units,alarm_hours_tens);
endmodule
