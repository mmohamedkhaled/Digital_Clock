`timescale 1ns / 1ps

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