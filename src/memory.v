`default_nettype none
`timescale 1ns / 1ps

module mem_cell (
    input        clock,
    input        reset,
    input        rw,
    input  [1:0] addr_in,
    input  [7:0] d_in,
    output reg [7:0] d_out
  );
    reg [7:0] mem0;
    reg [7:0] mem1;
    reg [7:0] mem2;
    reg [7:0] mem3;

    wire [7:0] data_bus;

    always @(posedge clock) begin
      if (reset == 0) begin
        // Reset logic here
        mem0 = 0;
        mem1 = 0;
        mem2 = 0;
        mem3 = 0;
      end

      if (rw) begin
        case (addr_in)
          0: mem0 = data_bus;
          1: mem1 = data_bus;
          2: mem2 = data_bus;
          3: mem3 = data_bus;
          default: mem0 = data_bus;
        endcase
      end else begin
        case (addr_in)
          0: d_out = mem0;
          1: d_out = mem1;
          2: d_out = mem2;
          3: d_out = mem3;
          default: d_out = mem0;
        endcase
      end
    end

    assign data_bus = d_in;

endmodule