`timescale 1ns / 1ps

module clock_divider #(parameter n = 50000000)(input clk, input rst, output reg clk_out);
parameter WIDTH = $clog2(n);
reg [WIDTH-1:0] count;
// Big enough to hold the maximum possible value// Increment count
always @ (posedge clk, posedge rst) begin
if (rst == 1'b1) 
  count <= 32'b0;
else if (count == n-1)
 count <= 32'b0;
else
 count <= count + 1;
end
// Handle the output clock
always @ (posedge clk, posedge rst) begin
if (rst) // Asynchronous Reset
 clk_out <= 0;
else if (count == n-1)
 clk_out <= ~ clk_out;
end
endmodule 
