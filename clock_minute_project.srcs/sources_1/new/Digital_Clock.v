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
 input clk, input rst, input[4:0] buttons , output  [0:6] segments, output  [3:0] anode,output reg [3:0] led , output reg sec);
 wire clk_200;
 wire clk_400;
 wire clk_175;
 wire clk_1;
 wire[3:0]counter_mintue_unites;
wire [2:0]counter_minutes_tens;
 wire [3:0]counter_hours_units;
 wire [1:0]counter_hours_tens;
 
 
 wire  BTNC,BTND,BTNL,BTNR,BTNU;
 // input clk, rst,input x,output z
  
 Pushbutton_Detector(clk_200,rst,buttons[0],BTNL);
 Pushbutton_Detector(clk_200,rst,buttons[1],BTNR);
 Pushbutton_Detector(clk_200,rst,buttons[2],BTNU);
 Pushbutton_Detector(clk_200,rst,buttons[3],BTND);
 Pushbutton_Detector(clk_200,rst,buttons[4],BTNC);

 reg clk_input;
 reg en_secs;
 reg en_adjust_time_min;
 reg en_adjust_time_Hours;
 
 reg[1:0] sel;
 reg [3:0] num;
 reg up_down;
 reg [3:0] CurrentState, NextState;
 
 parameter S0= 4'b0000,S1= 4'b0001,S2= 4'b0010,S3= 4'b0011,S4= 4'b0100,S5= 4'b0101,S6=4'b0110,S7=4'b0111,
 S8=4'd8,S9=4'd9,S10=4'd10,S11=4'd11,S12=4'd12,S13=4'd13;
 
 

 
always@(sel)begin
    case(sel)
        0:  num<= counter_mintue_unites;
        1: num<=counter_minutes_tens;
        2: num<=counter_hours_units;
        3: num<= counter_hours_tens; 
    endcase

end
 



always@(CurrentState, BTNC, BTNL, BTNU, BTNR,BTND)begin
    case(CurrentState)
        
        S0:begin  // clock
            clk_input = clk_1; 
            en_secs = 1'b1;
            en_adjust_time_min = 0;
            en_adjust_time_Hours = 0;
            sec = clk_1;
            led = 4'd0;
            up_down = 1;
            if(BTNC == 1) 
                NextState = S1;
            else
                NextState = S0;
        end
        S1:begin // adjust Time hours
            clk_input = clk_200; 
            sec = 1;
            en_secs = 1'b0;
            up_down=1;
            en_adjust_time_min = 0;
            en_adjust_time_Hours = 0;
            led = 4'd1;
            if(BTNC == 1)
                NextState = S0;
            else if(BTNL | BTNR == 1)
                NextState = S4;
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

        S4:begin// adjust Time Minutes
            clk_input = clk_200; 
            sec = 1;
            en_secs = 1'b0;
            en_adjust_time_min = 0;
            en_adjust_time_Hours = 0;
            led = 4'd2;
            if(BTNC == 1)
                NextState = S0;
            else if(BTNL | BTNR == 1)
                NextState = S7;
            else if(BTNU)begin // incremnet minutes
                up_down=1;
                en_adjust_time_min = 1;
                en_adjust_time_Hours = 0;
                NextState = S4;
            end
            else if(BTND)
            begin
                up_down=0;
                en_adjust_time_min = 1;
                en_adjust_time_Hours = 0;
                NextState = S4;
            end
            else
                NextState = S4;
        end

        S7:begin// adjust Alarm Hours
            clk_input = clk_200; 
            sec = 1;
            en_secs = 1'b0;
            en_adjust_time_min = 0;
            en_adjust_time_Hours = 0;
            led = 4'd4;
            if(BTNC == 1) 
                NextState = S0;
            else if(BTNL | BTNR == 1)
                NextState = S10;
            else if(BTNU)begin
                 up_down=1;
                en_adjust_time_min = 1;
                en_adjust_time_Hours = 0;
                NextState = S2;
                end
            else if(BTND)begin
                up_down=0;
                en_adjust_time_min = 1;
                en_adjust_time_Hours = 0;
                NextState = S3;
            end
            else
                NextState = S7;
        end
        
        S10:begin// adjust Alarm Minutes
            clk_input = clk_1; 
            sec = 1;
            en_secs = 1'b0;
            en_adjust_time_min = 0;
            en_adjust_time_Hours = 0;
            led = 4'd8;
            if(BTNC == 1)
                NextState = S0;
            else if(BTNL | BTNR == 1)
                NextState = S1;
            else if(BTNU)begin
                 up_down=1;
                en_adjust_time_min = 1;
                en_adjust_time_Hours = 0;
                NextState = S2;
                end
            else if(BTND)begin
                up_down=0;
                en_adjust_time_min = 1;
                en_adjust_time_Hours = 0;
                NextState = S3;
                end
            else
                NextState = S10;
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


 
clock_divider #(250000) clk_200_generate(.clk(clk), .rst(rst),  .clk_out(clk_200));

Sev_segment_display (sel,num,anode,segments);
clock_divider #(50000000) clk_1_generate(.clk(clk), .rst(rst),  .clk_out(clk_1));

//clock_divider #(125000) clk_400_generate(.clk(clk), .rst(rst),  .clk_out(clk_400));
//clock_divider #(285714) clk_175_generate(.clk(clk), .rst(rst),  .clk_out(clk_175));

secounds_mintues_counter(clk_input,rst,en_secs, en_adjust_time_min,en_adjust_time_Hours,up_down,counter_mintue_unites,counter_minutes_tens,counter_hours_units,counter_hours_tens);
 
endmodule
