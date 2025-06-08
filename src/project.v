/*
 * Copyright (c) 2024 Jake T.
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
`timescale 1ns / 1ps

module mem_cell (
    input        clock,
    input        reset,
    input  [1:0] d_in,
    output [1:0] d_out,
    input  [1:0] addr_in,
    input  [1:0] ADDR
  );
    reg [1:0] mem;

    always @(posedge clock) begin
      if (reset == 0) begin
        // Reset logic here
        mem = 0;
      end

      if (addr_in == ADDR) begin
        mem = d_in;
      end
    end

    assign d_out = mem;
endmodule

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

  parameter n_cells = 4;
  genvar cells;
  generate
    for  (cells = 0; cells < n_cells; cells = cells + 1) begin
      mem_cell memory (
        .clock (clk),
        .reset (rst_n),
        .d_in (ui_in[1:0]),
        .d_out (uo_out[1+(cells*2):0+(cells*2)]),
        .addr_in (ui_in[3:2]),
        .ADDR (cells)
      );
    end
  endgenerate

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
