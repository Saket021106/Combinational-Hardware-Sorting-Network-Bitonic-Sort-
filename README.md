# Parameterized & Pipelined Hardware Sorting Network (Bitonic Sort)

## Overview
This repository contains a fully **parameterized and pipelined SystemVerilog implementation** of a Bitonic Sorting Network. 

Unlike a purely combinational approach, this V2.0 architecture utilizes synchronous pipeline registers between sorting stages to achieve higher throughput, shorter critical paths, and better timing closure. Built with dynamic `generate` blocks and `$clog2` logic, the RTL automatically scales to instantiate the required hardware for any power-of-two inputs.

### What's New in V2.0
* **Full Parameterization:** The network dynamically scales using `NUM_INPUTS` and `DATA_WIDTH` top-level parameters.
* **Synchronous Pipelining:** `always_ff` registers isolate every comparison stage, allowing the network to process a new set of data every single clock cycle after the initial latency.
* **Verified Scalability:** The default repository simulation demonstrates a 4-input, 32-bit configuration operating with a verified 3-clock-cycle latency.

## Repository Contents
* **`design.sv`**: The main SystemVerilog design file. It consists of:
  * `sorting_network`: The top-level parameterized module that uses nested `generate` loops to automatically wire Compare-and-Swap (CAS) units and pipeline registers based on the requested `NUM_INPUTS`.
  * `cas_unit`: The foundational purely combinational Compare-and-Swap logic block.
* **`testbench.sv`**: A clock-driven testbench that applies test vectors to the network, accounts for pipeline latency, and verifies the sorted 32-bit outputs.
* **`waveform.pdf` & `result.pdf`**: Exported simulation waveforms and logs verifying the concurrent sorting operation and the exact 3-cycle propagation delay from `in` to `out`.

## Theoretical Characteristics
* **Data-Independent Control Flow:** The sequence of comparisons is exactly the same regardless of the input data. There are no conditional branches, making this algorithm perfectly suited for pipelined ASICs and FPGAs.
* **Massive Parallelism:** Multiple comparators operate simultaneously within the same clock cycle across different pairs of data paths.
* **RTL Scalability:** While a synthesized bitstream has a fixed hardware size, this SystemVerilog RTL can generate a sorting network for any 2^n inputs without rewriting the underlying logic. 

## Circuit Architecture

### 1. The Core Module: Compare & Swap (CAS)
The fundamental combinational building block of the network.
* **Inputs:** Two parameterized N-bit binary numbers (`A` and `B`).
* **Outputs:** Two N-bit binary lines labeled `high` and `low`.
* **Logic:** Uses continuous assignment to evaluate `A > B`. Based on the boolean result, a multiplexer routes the larger value to `high` and the smaller value to `low`.

### 2. The Top Module: The Pipelined Network
This module handles the structural generation and synchronous data movement.
* **Automatic Scaling:** Calculates the required number of stages using `(M * (M + 1)) / 2` where `M = $clog2(NUM_INPUTS)`.
* **Pipeline Registers:** Instantiates a 2D array of flip-flops (`pipeline_regs`) to hold data between combinational stages.
* **Generate Blocks:** Uses recursive `for` loops to instantiate and wire the correct ascending/descending CAS units into the `comb_wires` arrays for each specific stage of the bitonic sequence.

## Performance Metrics
* **Latency (Depth):** Measured in clock cycles. A 4-input network has a 3-cycle latency. An 8-input network has a 6-cycle latency.
* **Throughput:** 1 fully sorted array per clock cycle (post-latency).
* **Area (Size):** Scales dynamically. The architecture dictates the exact number of comparators and D-flip-flops synthesized based on the `NUM_INPUTS` parameter.

## Applications
Pipelined sorting networks are highly efficient hardware accelerators primarily applied in:
1. **Network Routers:** For high-speed packet scheduling and QoS prioritization.
2. **Digital Signal Processing (DSP):** For non-linear median filtering.
3. **Database Accelerators:** For rapidly sorting keys in memory arrays.

## How to Simulate
You can run and verify this design using standard SystemVerilog simulators such as **ModelSim**, **Xilinx Vivado**, **Icarus Verilog**, or **EDA Playground**.

1. Create a new project in your simulator.
2. Compile both `design.sv` and `testbench.sv`.
3. Ensure your simulator is configured to support SystemVerilog-2012 (for `always_ff`, `always_comb`, and multi-dimensional arrays).
4. Run the simulation. The testbench will generate the clock signal and drive the pipeline automatically.
