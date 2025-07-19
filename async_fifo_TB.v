`timescale 1ns/1ps

module async_fifo_TB;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter DEPTH      = 8;
    parameter MAX_WRITE  = 60;

    // DUT I/Os
    wire [DATA_WIDTH-1:0] data_out;
    wire                  full;
    wire                  empty;
    reg  [DATA_WIDTH-1:0] data_in;
    reg                   w_en, wclk, wrst_n;
    reg                   r_en, rclk, rrst_n;

    // Data verification
    reg [DATA_WIDTH-1:0] wdata_q [0:MAX_WRITE-1];
    reg [DATA_WIDTH-1:0] wdata;

    integer write_ptr;
    integer read_ptr;
    integer i;

    // Instantiate DUT (make sure your module exists and matches this)
    asynchronous_fifo #(
        .DEPTH(DEPTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) as_fifo (
        .wclk(wclk),
        .wrst_n(wrst_n),
        .rclk(rclk),
        .rrst_n(rrst_n),
        .w_en(w_en),
        .r_en(r_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    always #10 wclk = ~wclk;
    always #35 rclk = ~rclk;

    // Write Process
    initial begin
        wclk = 0;
        wrst_n = 0;
        w_en = 0;
        data_in = 0;
        write_ptr = 0;

        repeat (10) @(posedge wclk);
        wrst_n = 1;

        repeat (2) begin
            for (i = 0; i < 30; i = i + 1) begin
                @(posedge wclk);
                if (!full) begin
                    w_en = (i % 2 == 0) ? 1'b1 : 1'b0;
                    if (w_en) begin
                        data_in = $random;
                        wdata_q[write_ptr] = data_in;
                        write_ptr = write_ptr + 1;
                    end
                end else begin
                    w_en = 0;
                end
            end
            #50;
        end
        w_en = 0;
    end

    // Read Process
    initial begin
        rclk = 0;
        rrst_n = 0;
        r_en = 0;
        read_ptr = 0;

        repeat (20) @(posedge rclk);
        rrst_n = 1;

        repeat (2) begin
            for (i = 0; i < 30; i = i + 1) begin
                @(posedge rclk);
                if (!empty) begin
                    r_en = (i % 2 == 0) ? 1'b1 : 1'b0;
                    if (r_en) begin
                        wdata = wdata_q[read_ptr];
                        read_ptr = read_ptr + 1;
                        #1; // Wait for data to settle
                        if (data_out !== wdata)
                            $display("Time = %0t:  Mismatch: Expected = %h, Got = %h", $time, wdata, data_out);
                        else
                            $display("Time = %0t:  Match:     Data = %h", $time, data_out);
                    end
                end else begin
                    r_en = 0;
                end
            end
            #50;
        end
        $finish;
    end

endmodule
