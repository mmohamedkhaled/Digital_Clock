`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2024 08:51:46 PM
// Design Name: 
// Module Name: Alarm_Counter
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


module Alarm_Counter(input clk_out, input reset, input en, input en1, input en2, input up_down,
 output  [3:0]counter1,output  [2:0]counter2,output  [3:0]counter3,output  [1:0]counter4);
//input load, input [3:0] load_min_unit
//output  [3:0]out_minutes_units,output  [2:0]out_minutes_tens,output  [3:0]out_hours_units,output  [1:0]out_hours_tens
wire[5:0] counter_seconds;
wire rs_hours_units;

//wire [3:0]counter1;
//wire [3:0]counter2;
//wire [3:0]counter3;
//wire [3:0]counter4;

wire w0,w1,w2,w3;



 n_bit_counter #(60,6) seconds(clk_out,reset,en,up_down,counter_seconds); // seconds
assign w0=en? ((counter_seconds == 59) && en): en1;// enable minutes units

 n_bit_counter  #(10,4) minutes_units( clk_out,reset,w0,up_down,counter1); //minutes_units
 
 assign w1=counter1==9 && w0;
 
 n_bit_counter  #(6,3) minutes_tens( {clk_out},reset,w1,up_down,counter2); //minutes_tens
 assign w2=en ? (counter2==5 && w1) : en2; // enable hours units
  
  n_bit_counter  #(10,4) hours_units( {clk_out},reset || rs_hours_units ,w2,up_down,counter3); //hours_units
 
  assign w3=up_down?(counter3==9&&w2): (counter3==0 && w2);  
   
  assign rs_hours_units=up_down? (counter4 == 2 && counter3 == 4) :(counter4==0 && counter3 ==0) ; 

 n_bit_counter  #(3,2) hours_tens( {clk_out},reset||rs_hours_units,w3,up_down,counter4); //hours_tens
 
 

endmodule
