# Dual Clock FIFO in Verilog

This project implements a **Dual Clock FIFO (First-In First-Out)** buffer in Verilog that allows **asynchronous write and read operations** using separate clocks. It's a commonly used structure in digital systems that bridge different clock domains.

---

## 📌 Overview

A Dual Clock FIFO enables safe data transfer between two subsystems operating on different clock domains. This Verilog design supports an 8-bit wide, 64-depth FIFO buffer, with flags to indicate full and empty status.

---

## 🚀 Features

- 64-entry deep buffer (`buf_mem[63:0]`)
- 8-bit data width (`[7:0]`)
- Asynchronous read (`clk_r`) and write (`clk_w`) clocks
- Read/Write enable control (`rd_en`, `wr_en`)
- `buf_empty`, `buf_full` flags
- `fifo_counter` to monitor the number of entries
- Resettable using active-high `rst`

---
## Testbench Summary

- Functionality:
- 1. Generates separate clk_w and clk_r
- 2. Applies a reset pulse
- 3. Writes 5 values: 10, 20, 30, 40, 50 using clk_w
- 4. Delays for 30ns
- 5. Reads back 5 values using clk_r
- 6. Monitors fifo_counter, buf_out, buf_full, and buf_empty

Example Output:
- Time=36 | wr_en=1 rd_en=0 | buf_in=14 buf_out=00 | fifo_counter=3 | full=0 empty=0
- Time=84 | wr_en=0 rd_en=1 | buf_in=14 buf_out=10 | fifo_counter=2 | full=0 empty=0
![dual_clk_fifo](https://github.com/user-attachments/assets/d51c65bc-e7bb-4f34-9e21-260d00dae68f)

