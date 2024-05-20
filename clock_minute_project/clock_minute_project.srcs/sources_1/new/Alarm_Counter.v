`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2024 01:47:27 PM
// Design Name: 
// Module Name: secounds_mintues_counter
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


module Alarm_Counter(input clk_out, input reset, input en_minutes, input en_hours, input up_down,
 output  [3:0]minutes_units,output  [2:0]minutes_tens,output  [3:0]hours_units,output  [1:0]hours_tens);
 
wire[5:0] minutes;
wire[4:0] hours;

 n_bit_counter  #(60,6) minutes_counter( clk_out,reset,en_minutes,up_down,minutes); //minutes_units
 
 
  assign minutes_tens=minutes/10;
  assign minutes_units=minutes%10;
  
  assign hours_tens=hours/10;
  assign hours_units=hours%10;
  
  n_bit_counter  #(24,5) hours_counter( clk_out,reset,en_hours,up_down,hours); //hours_units  
 
 

endmodule
