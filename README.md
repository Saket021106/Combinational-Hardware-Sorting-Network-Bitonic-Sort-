# Combinational Hardware Sorting Network (Bitonic Sort)

## 📌 Overview
This repository contains the SystemVerilog implementation of a **4-Input Combinational Sorting Network**. Unlike software-based sorting algorithms that execute sequentially, this hardware sorting network evaluates and sorts four 4-bit binary numbers entirely concurrently using pure combinational logic, without the need for a clock or sequential state machines. 

## 📂 Repository Contents
* **`design.sv`**: The main SystemVerilog design file containing the structural and dataflow modeling of the network. It consists of:
  * `sorting_network`: The top-level module that routes the inputs through a 3-stage pipeline of comparator units to produce a fully sorted output.
  * `cas_unit`: The foundational Compare-and-Swap (CAS) unit that compares two 4-bit numbers and conditionally swaps them so the greater value is routed to the `high` output and the lesser to the `low` output.
* **`testbench.sv`**: The testbench file used to apply random and edge-case 4-bit vectors to verify the sorting logic.
* **`waveform.pdf`**: The exported simulation waveform that visually verifies the correct concurrent sorting operation, displaying the unsorted inputs alongside the sorted outputs (`out0` to `out3`).

## ⚙️ Circuit Architecture

### 1. The Compare-and-Swap (CAS) Unit
The core building block of this network is the `cas_unit`. It performs a magnitude comparison between two 4-bit inputs (`A` and `B`):
* It uses bitwise XNOR (`x = ~(A ^ B)`) to check for equality at each bit level.
* A selection signal (`sel`) is generated using combinational logic to evaluate if `A > B`.
* A multiplexing block uses `sel` to route the data:
  * If `A > B` (`sel = 1`), `high = A` and `low = B`.
  * If `A <= B` (`sel = 0`), `high = B` and `low = A`.

### 2. The 3-Stage Sorting Network
To sort four distinct 4-bit inputs (`in0`, `in1`, `in2`, `in3`), the top-level module instantiates six `cas_unit` modules arranged in three distinct stages, mimicking a parallel sorting algorithm (like Bitonic or Odd-Even mergesort):
* **Stage 1 (Initial Pairs):** Compares and sorts adjacent pairs `(in0, in1)` and `(in2, in3)`.
* **Stage 2 (Cross-stage):** Performs cross-comparisons between the outputs of Stage 1, comparing `(s1_w0, s1_w2)` and `(s1_w1, s1_w3)`.
* **Stage 3 (Final Merge):** Executes the final conditional swaps on the intermediate wires to guarantee that the final outputs (`out0`, `out1`, `out2`, `out3`) are completely sorted in descending order (from highest magnitude to lowest).

## 🚀 How to Simulate
You can run and verify this design using any standard Verilog/SystemVerilog simulator such as **ModelSim**, **Xilinx Vivado**, **Icarus Verilog**, or an online platform like **EDA Playground**.

1. Create a new project or workspace in your simulator.
2. Compile both `design.sv` and `testbench.sv`.
3. Set the top-level module to your testbench.
4. Run the simulation and generate the waveform. 
*(Note: You can view the `waveform.pdf` included in this repo to see the verified expected outputs).*
