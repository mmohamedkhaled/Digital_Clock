`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2024 10:25:20 AM
// Design Name: 
// Module Name: synchronizer
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


module synchronizer(
  input  signal,
  input  clock,
  output  sync_signal
);

  reg reg1; 
  reg reg2; 

  always @(posedge clock) begin
    reg1 <= signal;
    reg2 <= reg1;
  end

  assign sync_signal = reg2; 

endmodule