`timescale 1ns / 1ps

module secounds_mintues_counter(input clk_out, input reset, input en, input en1, input en2, input up_down,
 output  [3:0]counter1,output  [2:0]counter2,output  [3:0]counter3,output  [1:0]counter4, output [5:0] counter_seconds);
wire rs_hours_units;



wire w0,w1,w2,w3;



wire rs_sec;
wire rs_hrs;
 n_bit_counter #(60,6) seconds(clk_out,reset,en,up_down,counter_seconds); // seconds

assign rs_sec = counter4 == 2 & counter3 == 3 & counter2 ==5& counter1==9 & counter_seconds == 59;
assign rs_hrs = counter4 == 2 & counter3 == 4 ;
assign w0=en? ((counter_seconds == 59) && en): en1;// enable minutes units

n_bit_counter  #(10,4) minutes_units( clk_out,reset|rs_sec,w0,up_down,counter1); //minutes_units

assign w1 = en ? (counter1==9&&w0) : (up_down ?  counter1 == 9 & en1 : (counter1==0 ? en1 : 0));

n_bit_counter  #(6,3) minutes_tens( {clk_out},reset|rs_sec,w1,up_down,counter2); //minutes_tens

assign w2=en ? (counter2==5 && w1) : en2; // enable hours units

n_bit_counter  #(10,4) hours_units( {clk_out},reset | (en ? rs_sec : rs_hrs)
 ,w2,up_down,counter3); //hours_units

assign w3 = en ? (counter3==9&&w2) : (up_down ?  counter3 == 9 & en2 : ((counter4 == 0 & counter3==0) ? 0 : (counter3==0 ? en2 : 0)));  


n_bit_counter  #(3,2) hours_tens( {clk_out},reset|(en ? rs_sec : rs_hrs),w3,up_down,counter4); //hours_tens
 
 

endmodule
