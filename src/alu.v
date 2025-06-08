`default_nettype none
`timescale 1ns / 1ps

module alu_module (
  input  wire       clock,
  // input  wire       reset,
  input  wire [7:0] in,
  output reg  [7:0] RET,
  input       [3:0] INST
  // output wire busy
);
  reg [7:0] A, B;

  always @(posedge clock) begin
    case (INST)
      'h1: A = in;
      'h2: B = in;
      'h3: RET = A + B;
      // 'h4: RET = A - B;
    endcase
  end

endmodule