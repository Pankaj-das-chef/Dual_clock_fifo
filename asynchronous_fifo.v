`timescale 1ns/1ps

// Include the necessary sub-module files
`include "synchronizer.v"
`include "wptr_handler.v"
`include "rptr_handler.v"
`include "fifo_mem.v"

module asynchronous_fifo #(
    parameter DEPTH      = 8,
    parameter DATA_WIDTH = 8
) (
    // Write Clock Domain Inputs
    input                      wclk,
    input                      wrst_n,
    input                      w_en,
    input      [DATA_WIDTH-1:0]  data_in,

    // Read Clock Domain Inputs
    input                      rclk,
    input                      rrst_n,
    input                      r_en,

    // Outputs
    output     [DATA_WIDTH-1:0]  data_out,
    output                     full,
    output                     empty
);

    // Local parameter for pointer width, calculated from DEPTH
    parameter PTR_WIDTH = $clog2(DEPTH);

    // Internal wires to connect the modules
    wire [PTR_WIDTH:0] g_wptr_sync, g_rptr_sync;
    wire [PTR_WIDTH:0] b_wptr, b_rptr;
    wire [PTR_WIDTH:0] g_wptr, g_rptr;

    // Synchronizer for write pointer (write clock domain to read clock domain)
    // Synchronizes the gray-coded write pointer to be used by the read logic.
    synchronizer #(
        .WIDTH(PTR_WIDTH)
    ) sync_wptr (
        .clk(rclk),
        .rst_n(rrst_n),
        .d_in(g_wptr),
        .d_out(g_wptr_sync)
    );

    // Synchronizer for read pointer (read clock domain to write clock domain)
    // Synchronizes the gray-coded read pointer to be used by the write logic.
    synchronizer #(
        .WIDTH(PTR_WIDTH)
    ) sync_rptr (
        .clk(wclk),
        .rst_n(wrst_n),
        .d_in(g_rptr),
        .d_out(g_rptr_sync)
    );

    // Write pointer handler
    // Manages the write pointers and generates the 'full' signal.
    wptr_handler #(
        .PTR_WIDTH(PTR_WIDTH)
    ) wptr_h (
        .wclk(wclk),
        .wrst_n(wrst_n),
        .w_en(w_en),
        .g_rptr_sync(g_rptr_sync),
        .b_wptr(b_wptr),
        .g_wptr(g_wptr),
        .full(full)
    );

    // Read pointer handler
    // Manages the read pointers and generates the 'empty' signal.
    rptr_handler #(
        .PTR_WIDTH(PTR_WIDTH)
    ) rptr_h (
        .rclk(rclk),
        .rrst_n(rrst_n),
        .r_en(r_en),
        .g_wptr_sync(g_wptr_sync),
        .b_rptr(b_rptr),
        .g_rptr(g_rptr),
        .empty(empty)
    );

    // FIFO Memory Block
    // The actual memory that stores the data.
    fifo_mem #(
        .DEPTH(DEPTH),
        .DATA_WIDTH(DATA_WIDTH),
        .PTR_WIDTH(PTR_WIDTH)
    ) fifom (
        .wclk(wclk),
        .w_en(w_en),
        .rclk(rclk),
        .r_en(r_en),
        .b_wptr(b_wptr),
        .b_rptr(b_rptr),
        .data_in(data_in),
        .full(full),
        .empty(empty),
        .data_out(data_out)
    );

endmodule
