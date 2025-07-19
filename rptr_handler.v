`timescale 1ns/1ps

`timescale 1ns/1ps

module rptr_handler #(
    parameter PTR_WIDTH = 3
) (
    input                   rclk,
    input                   rrst_n,
    input                   r_en,
    input      [PTR_WIDTH:0] g_wptr_sync,
    output reg [PTR_WIDTH:0] b_rptr,
    output reg [PTR_WIDTH:0] g_rptr,
    output reg              empty
);

    // Internal wires for pointer and empty logic
    wire [PTR_WIDTH:0] b_rptr_next;
    wire [PTR_WIDTH:0] g_rptr_next;
    wire               rempty;

    // Logic to calculate the next binary and gray read pointers
    assign b_rptr_next = b_rptr + (r_en & !empty);
    assign g_rptr_next = (b_rptr_next >> 1) ^ b_rptr_next;

    // Combinational logic to determine if the FIFO is empty
    assign rempty = (g_wptr_sync == g_rptr_next);

    // Sequential logic for updating binary and gray read pointers
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            b_rptr <= 0; // Reset binary read pointer
            g_rptr <= 0; // Reset gray read pointer
        end else begin
            b_rptr <= b_rptr_next; // Increment binary read pointer
            g_rptr <= g_rptr_next; // Increment gray read pointer
        end
    end

    // Sequential logic for updating the 'empty' flag
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            empty <= 1'b1; // FIFO is empty on reset
        end else begin
            empty <= rempty;
        end
    end

endmodule
