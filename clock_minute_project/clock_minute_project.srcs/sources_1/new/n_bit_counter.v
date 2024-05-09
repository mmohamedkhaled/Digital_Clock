`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2024 09:31:44 AM
// Design Name: 
// Module Name: n_bit_counter
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


module n_bit_counter #( parameter n = 4, parameter x = 2)(input clk, input reset, input en ,output [x-1:0]counter);

reg [x-1:0] counter;

always @(posedge clk, posedge reset) begin
 if (reset == 1)
 counter <= 32'd0; // non-blocking assignment  // initialize flip flop here
 else begin
 if(en==1)begin
 if(counter==(n-1))begin
 counter=0;
 end
 else begin
  counter <= counter + 1;
  end
  end

 end // non-blocking assignment  // normal operation
end

endmodule
