`default_nettype none

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
  reg [7:0] out_buf;

  memory_block #(.ADDR_BITS(ADDR_BITS)) ram (
    .clock (clock),
    .addr (addr),
    .d_in (mem_in),
    .d_out (mem_out),
    .we (inst[3])
  );

  always @(posedge clock) begin
    if (reset == 0) begin
      out_buf = 'x;
    end else if (inst == 'h1 || inst == 'h2) begin
      out_buf = mem_out;
    end
  end

  assign data_out = out_buf;

endmodule

module memory_block #(parameter ADDR_BITS = 2) (
  input                       clock,
  input  wire [ADDR_BITS-1:0] addr,
  input  wire [7:0]           d_in,
  output wire [7:0]           d_out,
  input  wire                 we
);
  reg [7:0] mem [2**ADDR_BITS];

  always @(posedge clock) begin
    if (we)
      mem[addr] = d_in;
  end
  
  assign d_out = mem[addr];
endmodule
