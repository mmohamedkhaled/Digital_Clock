`timescale 1ns / 1ps

module Digital_Clock(input clk, input rst, input[4:0] buttons , output  [0:6] segments, output  [3:0] anode,output [4:0] led , output sec, output alarm_led, output buzzer);
 
    
    wire clk_200;
    wire clk_1;
    
    wire[5:0]counter_seconds;
    wire[3:0]counter_mintue_unites;
    wire [2:0]counter_minutes_tens;
    wire [3:0]counter_hours_units;
    wire [1:0]counter_hours_tens;
    
    wire[3:0]alarm_mintue_units;
    wire [2:0]alarm_minutes_tens;
    wire [3:0]alarm_hours_units;
    wire [1:0]alarm_hours_tens;
    
    
    wire[4:0] zflag;
    wire final_zero_check;
    
    wire  BTNC,BTND,BTNL,BTNR,BTNU;
    
    Pushbutton_Detector(clk_200,rst,buttons[0],BTNL);
    Pushbutton_Detector(clk_200,rst,buttons[1],BTNR);
    Pushbutton_Detector(clk_200,rst,buttons[2],BTNU);
    Pushbutton_Detector(clk_200,rst,buttons[3],BTND);
    Pushbutton_Detector(clk_200,rst,buttons[4],BTNC);
    
    wire clk_input;
    wire en_secs;
    
    wire en_adjust_time_min;
    wire en_adjust_time_Hours;
    wire en_adjust_alarm_min;
    wire en_adjust_alarm_Hours;
    
    wire clock_alarm;
    
    
    
    reg[1:0] sel;
    reg [3:0] num;
    wire up_down;
    reg [3:0] CurrentState, NextState;
    
    parameter S0= 3'b000,S1= 3'b001,S2= 3'b010,S3= 3'b011,S4= 3'b100,S5= 3'b101;
    
    
    
 
always@(sel)begin
    case(sel)
        0: num <= ~clock_alarm ?  counter_mintue_unites : alarm_mintue_units;
        1: num<= ~clock_alarm ? counter_minutes_tens : alarm_minutes_tens;
        2: num<= ~clock_alarm ? counter_hours_units : alarm_hours_units;
        3: num<= ~clock_alarm ? counter_hours_tens: alarm_hours_tens; 
    endcase
end
 

wire blink;
reg AlarmDefuse;

always@(CurrentState, BTNC, BTNL, BTNU, BTNR,BTND,final_zero_check)begin
    case(CurrentState)
        S0:begin  // clock
            if(final_zero_check)
                NextState=S5;
            else if(BTNC) 
                NextState = S1;
            else
                NextState = S0;
        end
        S1:begin // adjust Time hours
            if(BTNC)
                NextState = S0;
            else if(BTNL | BTNR)
                NextState = S2;
            else if(BTNU) // increment time hours
                NextState = S1;
            else if(BTND)
                NextState = S1;
            else
                NextState = S1;
        end        

        S2:begin// adjust Time Minutes
            if(BTNC)
                NextState = S0;
            else if(BTNL | BTNR)
                NextState = S3;
            else if(BTNU) // incremnet minutes
                NextState = S2;
            else if(BTND)
                NextState = S2;
            else
                NextState = S2;
        end

        S3:begin// adjust Alarm Hours
            if(BTNC) 
                NextState = S0;
            else if(BTNL | BTNR)
                NextState = S4;
            else if(BTNU)
                NextState = S3;
            else if(BTND)
                NextState = S3;
            else
                NextState = S3;
        end
        
        S4:begin// adjust Alarm Minutes

            if(BTNC)
                NextState = S0;
            else if(BTNL | BTNR)
                NextState = S1;
            else if(BTNU)
                NextState = S4;
            else if(BTND)
                NextState = S4;
            else
                NextState = S4;
        end
        
    S5:  
     begin 
        if( BTNC==1 | BTND==1 | BTNL==1 | BTNR==1 | BTNU==1 )
            NextState = S0;
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

assign zflag[4]=(counter_seconds ==0);

assign final_zero_check= zflag[0] & zflag[1]  & zflag[2] & zflag[3]& zflag[4];

clock_divider #(250000) clk_200_generate(.clk(clk), .rst(rst),  .clk_out(clk_200));

Sev_segment_display (sel,num,anode,segments);
clock_divider #(50000000) clk_1_generate(.clk(clk), .rst(rst),  .clk_out(clk_1));

assign alarm_led = (CurrentState == S0) ? 0 : ((CurrentState == S5) ? clk_1 : 0);

assign led[3] = CurrentState == S1; // clock hour

assign led[2] = CurrentState == S2; // clock min

assign led[1] = CurrentState == S3; // Alarm hour

assign led[0] = CurrentState == S4; // Alarm min

assign led[4] = CurrentState == S5; // Alarm

assign en_secs = CurrentState == S0 | CurrentState == S5;

assign  sec  = ~(anode==4'b1011  & clk_1 & en_secs);

assign clock_alarm = CurrentState == S4 | CurrentState == S3;

assign clk_input = (CurrentState == S0 | CurrentState == S5) ? clk_1 : clk_200;

assign up_down = ((CurrentState == S1 & BTND)|(CurrentState == S2 & BTND)|
(CurrentState == S3 & BTND)|(CurrentState == S4 & BTND)) ? 0 : 1;

assign en_adjust_time_Hours = (led[3] &(BTNU | BTND)) ? 1 : 0 ;

assign en_adjust_time_min = (led[2] &(BTNU | BTND)) ? 1 : 0 ;

assign en_adjust_alarm_min = (led[1] &(BTNU | BTND)) ? 1 : 0 ;

assign en_adjust_alarm_Hours = (led[0] &(BTNU | BTND)) ? 1 : 0 ;

assign buzzer= (led[4])?clk_1:0;

secounds_mintues_counter(clk_input,rst,en_secs, en_adjust_time_min,en_adjust_time_Hours,
up_down,counter_mintue_unites,counter_minutes_tens,counter_hours_units,
counter_hours_tens,counter_seconds);

Alarm_Counter(clk_input,rst, en_adjust_alarm_min ,en_adjust_alarm_Hours,up_down,
alarm_mintue_units,alarm_minutes_tens,alarm_hours_units,alarm_hours_tens);


endmodule
