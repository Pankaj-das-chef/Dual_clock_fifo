`timescale 1ns / 1ps

module dual_clock_fifo_tb;


    reg clk_w;
    reg clk_r;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [7:0] buf_in;

    wire [7:0] buf_out;
    wire buf_empty;
    wire buf_full;
    wire [7:0] fifo_counter;

    dual_clk_fifo uut (
        .clk_r(clk_r),
        .clk_w(clk_w),
        .rst(rst),
        .buf_in(buf_in),
        .buf_out(buf_out),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .buf_empty(buf_empty),
        .buf_full(buf_full),
        .fifo_counter(fifo_counter)
    );

    // Clock generation
    initial begin
        clk_w = 0;
        forever #4 clk_w = ~clk_w;  // Write clock: 8ns period (125 MHz)
    end

    initial begin
        clk_r = 0;
        forever #6 clk_r = ~clk_r;  // Read clock: 12ns period (83.3 MHz)
    end

    // Test sequence
    initial begin
        // Initialize
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        buf_in = 8'd0;

        // Reset pulse
        #10 rst = 0;

        // Write 5 values into FIFO
        repeat (5) begin
            @(posedge clk_w);
            wr_en = 1;
            buf_in = buf_in + 8'd10;  // 10, 20, 30, ...
        end

        @(posedge clk_w);
        wr_en = 0;

        // Wait a few cycles before reading
        #30;

        // Read 5 values from FIFO
        repeat (5) begin
            @(posedge clk_r);
            rd_en = 1;
        end

        @(posedge clk_r);
        rd_en = 0;

        // Finish simulation
        #50 $finish;
    end

endmodule
