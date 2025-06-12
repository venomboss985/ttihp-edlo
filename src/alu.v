`default_nettype none

module alu_module (
  input  wire       clock,
  input  wire       reset,
  input  wire [7:0] data_in,
  input  wire [7:0] ram_in,
  output reg  [7:0] RTN,
  input       [3:0] INST
);
  reg [7:0] A, B;

  always @(posedge clock) begin
    if (reset == 0) begin
      A = 'x;
      B = 'x;
      RTN = 'x;
    end else begin
      case (INST)
        'h3: A = data_in;
        'h4: B = data_in;
        'h5: A = ram_in;
        'h6: B = ram_in;
        'h7: RTN = A + B;
        'h8: RTN = A - B;
      endcase
    end
  end

endmodule
