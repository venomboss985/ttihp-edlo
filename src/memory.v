`default_nettype none
`include "define.v"

module memory_controller #(parameter ADDR_BITS = 2) (
  input  wire                 clock,
  input  wire                 reset,
  input  wire [ADDR_BITS-1:0] addr,
  input  wire [7:0]           data_in,
  output wire [7:0]           data_out,
  input  wire [3:0]           inst,

  input       [7:0]           mem_in,
  output      [7:0]           mem_out
);
  // Internal wire/buffers
  reg [7:0] out_buf;
  wire [7:0] mem_bus;
  wire mem_we;

  // RAM instance
  memory_block #(.ADDR_BITS(ADDR_BITS)) ram (
    .clock (clock),
    .addr (addr),
    .d_in (mem_bus),
    .d_out (mem_out),
    .we (mem_we)
  );

  // Run instruction every clock cycle
  always @(posedge clock) begin
    if (reset == 0) begin
      out_buf = 'x;
    end else begin
      case (inst)
        `LDR, `LDA, `LDB, `LDAR, `LDBR: out_buf = mem_out;
        `LDRN: out_buf = mem_in;
      endcase
    end
  end

  // Internal wire/buffer assignments
  assign mem_bus = (inst == `STRN) ? mem_in : data_in;
  assign mem_we = inst == `STR || inst == `STRN;
  assign data_out = out_buf;

endmodule

module memory_block #(parameter ADDR_BITS = 2) (
  input                       clock,
  input  wire [ADDR_BITS-1:0] addr,
  input  wire [7:0]           d_in,
  output wire [7:0]           d_out,
  input  wire                 we
);
  // Memory cells
  reg [7:0] mem [2**ADDR_BITS];

  // Store input memory if write enable is high
  always @(posedge clock) begin
    if (we)
      mem[addr] = d_in;
  end
  
  // Internal wire assignments
  assign d_out = mem[addr];

endmodule
