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
