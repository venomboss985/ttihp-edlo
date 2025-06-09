/*
 * Copyright (c) 2024 Jake T.
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
// `timescale 1ns / 1ps

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
  wire [7:0] ram_bus;
  wire [7:0] rtn_bus;

  alu_module ALU (
    .clock (clk),
    // .reset (rst_n),
    .in (ram_bus),
    .RTN (rtn_bus),
    .INST (uio_in[7:4])
    // .busy (alu_busy)
  );

  localparam ADDR_BITS = 4;
  memory_controller #(.ADDR_BITS(ADDR_BITS)) mem_ctrl (
    .clock (clk),
    .addr (uio_in[3:0]),
    .data_in (ui_in),
    .data_out (uo_out),
    .inst (uio_in[7:4]),

    .mem_in (rtn_bus),
    .mem_out (ram_bus)
  );

  always @(posedge clk) begin
    if (rst_n == 0) begin
      // Reset logic here
    end
  end

  // All output pins must be assigned. If not used, assign to 0.
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
