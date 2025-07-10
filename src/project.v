/*
 * Copyright (c) 2024 Jake T.
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_venom_edlo (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
  // Internal buses
  wire [7:0] input_bus;
  wire [7:0] output_bus;
  wire [3:0] address_bus;
  wire [3:0] instruction_bus;
  wire [7:0] ram_bus;
  wire [7:0] rtn_bus;

  // ALU module instance
  alu_module ALU (
    .clock (clk),
    .reset (rst_n),
    .data_in (input_bus),
    .ram_in (ram_bus),
    .RTN (rtn_bus),
    .INST (instruction_bus)
  );

  // Memory Controller + RAM instance
  localparam ADDR_BITS = 4;
  memory_controller #(.ADDR_BITS(ADDR_BITS)) mem_ctrl (
    .clock (clk),
    .addr (address_bus),
    .data_in (input_bus),
    .data_out (output_bus),
    .inst (instruction_bus),

    .mem_in (rtn_bus),
    .mem_out (ram_bus)
  );

  // Reset + clock pulse logic
  always @(posedge clk) begin
    if (rst_n == 0) begin
      // Reset logic here
    end
  end

  // IO assignments
  assign input_bus = ui_in;
  assign uo_out = output_bus;
  assign address_bus = uio_in[3:0];
  assign instruction_bus = uio_in[7:4];

  // Unused assignments
  assign uio_out = 0;
  assign uio_oe  = 0;
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
