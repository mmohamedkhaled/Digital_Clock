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


module secounds_mintues_counter(input clk_out, input reset, input en, input load, input [3:0] load_min_unit,
 input [3:0] load_min_tens,input [3:0] load_hour_units, input [3:0] load_hour_tens
,output  [3:0]out_minutes_units,output  [2:0]out_minutes_tens,output  [3:0]out_hours_units,output  [1:0]out_hours_tens );

wire[5:0] counter_seconds;
wire rs_hours_units;

wire [3:0]counter1;
wire [3:0]counter2;
wire [3:0]counter3;
wire [3:0]counter4;

wire w0,w1,w2,w3;



 n_bit_counter #(60,6) seconds(clk_out,reset,en,counter_seconds); // seconds
assign w0= counter_seconds == 59 && en;

 n_bit_counter  #(10,4) minutes_units( clk_out,reset,w0,counter1); //minutes_units
 
 assign w1=counter1==9 && w0;
 
 n_bit_counter  #(6,3) minutes_tens( {clk_out},reset,w1,counter2); //minutes_tens
 assign w2=counter2==5 && w1; 
  
  n_bit_counter  #(10,4) hours_units( {clk_out},reset || rs_hours_units ,w2,counter3); //hours_units
  assign w3= counter3==9 && w2  ;   
  assign rs_hours_units= counter4==2 && counter3 ==4; 

 n_bit_counter  #(3,2) hours_tens( {clk_out},reset||rs_hours_units,w3,counter4); //hours_tens
 
 

endmodule
