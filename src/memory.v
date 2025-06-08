`default_nettype none
`timescale 1ns / 1ps

module memory_module #(parameter ADDR_BITS = 2) (
  input clock,
  input wire [ADDR_BITS-1:0] addr,
  input wire [7:0] d_in,
  output wire [7:0] d_out,
  input wire we
);
  reg [7:0] mem [2**ADDR_BITS];

  always @(posedge clock) begin
    if (we)
      mem[addr] = d_in;
  end
  
  assign d_out = mem[addr];
endmodule