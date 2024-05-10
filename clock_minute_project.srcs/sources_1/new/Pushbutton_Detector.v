`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2024 10:12:23 AM
// Design Name: 
// Module Name: Pushbutton_Detector
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


module Pushbutton_Detector(
input clk, rst,
input x,
output z
);
wire w1,w2;
debouncer D1 (.clk(clk), .rst(rst), .in(x),.out(w1));  
synchronizer s1(.signal(w1),.clock(clk),.sync_signal(w2));
ex1_Rising_Edge_Detector R1 (.clk(clk), .rst(rst), .w(w2),.z(z));
endmodule
