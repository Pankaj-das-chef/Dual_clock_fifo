`timescale 1ns/1ps

module wptr_handler #(
    parameter PTR_WIDTH = 3
) (
    input                   wclk,
    input                   wrst_n,
    input                   w_en,
    input      [PTR_WIDTH:0] g_rptr_sync,
    output reg [PTR_WIDTH:0] b_wptr,
    output reg [PTR_WIDTH:0] g_wptr,
    output reg              full
);

    // Internal registers and wires for pointer logic
    wire [PTR_WIDTH:0] b_wptr_next;
    wire [PTR_WIDTH:0] g_wptr_next;
    wire               wfull;

    // Logic to calculate the next binary and gray write pointers
    assign b_wptr_next = b_wptr + (w_en & !full);
    assign g_wptr_next = (b_wptr_next >> 1) ^ b_wptr_next;

    // Sequential logic for updating binary and gray write pointers
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            b_wptr <= 0; // Reset binary write pointer
            g_wptr <= 0; // Reset gray write pointer
        end else begin
            b_wptr <= b_wptr_next; // Increment binary write pointer
            g_wptr <= g_wptr_next; // Increment gray write pointer
        end
    end

    // Sequential logic for updating the 'full' flag
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            full <= 1'b0;
        end else begin
            full <= wfull;
        end
    end

    // Combinational logic to determine if the FIFO is full
    // Full condition: next gray write pointer matches the synchronized gray read pointer,
    // with the two most significant bits inverted.
    assign wfull = (g_wptr_next == {~g_rptr_sync[PTR_WIDTH], ~g_rptr_sync[PTR_WIDTH-1], g_rptr_sync[PTR_WIDTH-2:0]});

endmodule
