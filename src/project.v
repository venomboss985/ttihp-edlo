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

  // parameter n_cells = 4;
  // genvar _cells;
  // generate
  //   wire [7:0] data_bus;
  //   // wire [1:0] addr_bus;

  //   for (_cells = 0; _cells < n_cells; _cells = _cells + 1) begin
  //     mem_cell mem (
  //       .clock (clk),
  //       .reset (rst_n),
  //       .rw (uio_in[2]),
  //       .ADDR (_cells),
  //       .addr (uio_in[1:0]),
  //       .d_in (data_bus),
  //       .d_out (data_bus)
  //     );
  //   end
  // endgenerate

  localparam ADDR_BITS = 2;
  reg [7:0] RAM[2**ADDR_BITS];

  wire [ADDR_BITS-1:0] addr;
  wire [7:0] write_data;
  wire we;

  always @(posedge clk) begin
    if (rst_n == 0) begin
      // Reset logic here
    end

    // if (uio_in[2])
    //   data_bus = ui_in;
    if (we) RAM[addr] <= write_data;
  end

  // assign addr_bus = uio_in[1:0];
  // assign uo_out = data_bus;
  assign we = uio_in[ADDR_BITS];
  assign write_data = ui_in;
  assign addr = uio_in[ADDR_BITS-1:0];
  assign uo_out = RAM[addr];

  // All output pins must be assigned. If not used, assign to 0.
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{uio_in[7:3], ena, clk, rst_n, 1'b0};

endmodule
