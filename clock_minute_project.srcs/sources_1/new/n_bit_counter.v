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


module n_bit_counter #( parameter n = 4, parameter x = 2)(input clk, input reset, input en,input up_down ,output [x-1:0]counter);

reg [x-1:0] counter;

always @(posedge clk, posedge reset) begin
    if (reset == 1)
            counter <= 0;
        
    else begin
        if(en == 1)begin
            if(up_down == 1)begin
                if(counter == (n-1))
                    counter <= 0;
                else
                    counter <= counter+1;
              end
            else if(up_down == 0)
                if(counter == 0)
                    counter <= n-1;
                else
                    counter <= counter - 1;    
                    
          end
//        else 
//            counter <= counter;        
    end // non-blocking assignment  // normal operation
end

endmodule
