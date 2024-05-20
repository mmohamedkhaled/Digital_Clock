`timescale 1ns / 1ps

module Pushbutton_Detector(
input clk, rst,
input x,
output z
);
wire w1,w2;
debouncer D1 (.clk(clk), .rst(rst), .in(x),.out(w1));  
synchronizer s1(.signal(w1),.clock(clk),.sync_signal(w2));
Rising_Edge_Detector R1 (.clk(clk), .rst(rst), .w(w2),.z(z));
endmodule
