`default_nettype none
`include "define.v"

module alu_module (
  input  wire       clock,
  input  wire       reset,
  input  wire [7:0] data_in,
  input  wire [7:0] ram_in,
  output reg  [7:0] RTN,
  input       [3:0] INST
);
  // Internal A/B registers
  reg [7:0] A, B;

  // Run instruction every clock cycle
  always @(posedge clock) begin
    if (reset == 0) begin
      A = 'x;
      B = 'x;
      RTN = 'x;
    end else begin
      case (INST)
        `LDA: A = data_in;
        `LDB: B = data_in;
        `LDAR: A = ram_in;
        `LDBR: B = ram_in;
        `ADD: RTN = A + B;
        `SUB: RTN = A - B;
      endcase
    end
  end

endmodule
