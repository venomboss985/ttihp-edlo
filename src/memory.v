`default_nettype none
`timescale 1ns / 1ps

module mem_cell (
    input        clock,
    input        reset,
    input        wr,
    input  [1:0] addr_in,
    input  [7:0] d_in,
    output [7:0] d_out
  );
    reg [7:0] mem0;
    reg [7:0] mem1;
    reg [7:0] mem2;
    reg [7:0] mem3;

    reg [7:0] mem_out;

    always @(posedge clock) begin
      if (reset == 0) begin
        // Reset logic here
        mem0 = 0;
        mem1 = 0;
        mem2 = 0;
        mem3 = 0;
      end

      if (wr) begin
        case (addr_in)
          0: mem0 = d_in;
          1: mem1 = d_in;
          2: mem2 = d_in;
          3: mem3 = d_in;
          default: mem0 = d_in;
        endcase
      end else begin
        case (addr_in)
          0: mem_out = mem0;
          1: mem_out = mem1;
          2: mem_out = mem2;
          3: mem_out = mem3;
          default: mem_out = mem0;
        endcase
      end
    end

    assign d_out = (!wr) ? mem_out : 8'b0;

endmodule