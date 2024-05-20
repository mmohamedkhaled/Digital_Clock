`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2024 01:51:48 PM
// Design Name: 
// Module Name: module_6counter
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


module module_6counter(input clk, input reset, input en ,output [3:0]counter);

wire clk_out;
clock_divider #(50000000) p1(.clk(clk), .rst(reset),  .clk_out(clk_out));
n_bit_counter  #(6,4) f1( clk_out,reset,en,counter);

endmodule
