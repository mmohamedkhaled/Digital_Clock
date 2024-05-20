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


module secounds_mintues_counter(input clk_out, input reset, input en, input en1, input en2, input up_down,
 output  [3:0]counter1,output  [2:0]counter2,output  [3:0]counter3,output  [1:0]counter4);
wire[5:0] counter_seconds;
wire rs_hours_units;



wire w0,w1,w2,w3;

reg diff1;
reg diff2;

always@(clk_out) begin

diff1<=counter4;
diff2<=counter2;
end

wire rs_minutes;
 n_bit_counter #(60,6) seconds(clk_out,reset,en,up_down,counter_seconds); // seconds



assign rs_minutes=up_down? 1'b0 :(diff2!=1 &&counter1==0 && counter2 ==0) ; 

assign w0=en? ((counter_seconds == 59) && en): en1;// enable minutes units

 n_bit_counter  #(10,4) minutes_units( clk_out,reset||rs_minutes,w0,up_down,counter1); //minutes_units
 
 assign w1 = up_down ?   counter1==9 && w0 : (counter1==0&&w0) ;
 
 n_bit_counter  #(6,3) minutes_tens( {clk_out},reset||rs_minutes,w1,up_down,counter2); //minutes_tens
 assign w2=en ? (counter2==5 && w1) : en2; // enable hours units
  
  n_bit_counter  #(10,4) hours_units( {clk_out},reset || rs_hours_units ,w2,up_down,counter3); //hours_units
 
  assign w3 = up_down? (counter3==9&&w2) : (counter3 == 0  && w2);  
   
  assign rs_hours_units=up_down? (counter4 == 2 && counter3 == 4) :(diff1!=1 &&counter4==0 && counter3 ==0) ; 
  
 n_bit_counter  #(3,2) hours_tens( {clk_out},reset||rs_hours_units,w3,up_down,counter4); //hours_tens
 
 

endmodule
