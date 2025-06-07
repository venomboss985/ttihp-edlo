/*
 * Copyright (c) 2024 Jake T.
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
`timescale 1ns / 1ps

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

  reg [1:0] mem0;
  reg [1:0] mem1;
  reg [1:0] mem2;
  reg [1:0] mem3;

  always @(posedge clk) begin
    if (rst_n == 0) begin
      // Reset logic here
      mem0 = 0;
      mem1 = 0;
      mem2 = 0;
      mem3 = 0;
    end

    case (ui_in[3:2])
      2'd0: mem0 = ui_in[1:0];
      2'd1: mem1 = ui_in[1:0];
      2'd2: mem2 = ui_in[1:0];
      2'd3: mem3 = ui_in[1:0];
      default: mem0 = ui_in[1:0];
    endcase
  end

  // Internal memory output
  assign uo_out[1:0] = mem0;
  assign uo_out[3:2] = mem1;
  assign uo_out[5:4] = mem2;
  assign uo_out[7:6] = mem3;

  // All output pins must be assigned. If not used, assign to 0.
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
