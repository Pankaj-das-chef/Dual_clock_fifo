`timescale 1ns/1ps

module fifo_mem #(
    parameter DEPTH      = 8,
    parameter DATA_WIDTH = 8,
    parameter PTR_WIDTH  = 3
) (
    input                   wclk,
    input                   w_en,
    input                   rclk,
    input                   r_en,
    input      [PTR_WIDTH:0]  b_wptr,
    input      [PTR_WIDTH:0]  b_rptr,
    input      [DATA_WIDTH-1:0] data_in,
    input                   full,
    input                   empty,
    output wire [DATA_WIDTH-1:0] data_out
);

    // Memory array for the FIFO
    reg [DATA_WIDTH-1:0] fifo[0:DEPTH-1];

    // Write logic: write data to FIFO on wclk edge if write is enabled and not full
    always @(posedge wclk) begin
        if (w_en & !full) begin
            fifo[b_wptr[PTR_WIDTH-1:0]] <= data_in;
        end
    end

    // Read logic: combinational read from the FIFO
    // The output data_out will change as soon as the read pointer (b_rptr) changes.
    assign data_out = fifo[b_rptr[PTR_WIDTH-1:0]];

    /*
    // Alternative registered read logic:
    // The output data_out is registered and changes only on the rclk edge.
    always @(posedge rclk) begin
        if (r_en & !empty) begin
            data_out <= fifo[b_rptr[PTR_WIDTH-1:0]];
        end
    end
    */

endmodule
