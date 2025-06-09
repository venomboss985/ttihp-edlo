`default_nettype none

module alu_module (
  input  wire       clock,
  // input  wire       reset,
  // output wire       busy,
  input  wire [7:0] in,
  output reg  [7:0] RTN,
  input       [3:0] INST
);
  reg [7:0] A, B;

  always @(posedge clock) begin
    case (INST)
      'h1: A = in;
      'h2: B = in;
      'h3: RTN = A + B;
      // 'h4: RET = A - B;
    endcase
  end

endmodule
