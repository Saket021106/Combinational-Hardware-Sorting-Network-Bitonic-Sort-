# Combinational Hardware Sorting Network (Bitonic Sort)

## 📌 Overview
This repository contains the SystemVerilog implementation of a **4-Input Combinational Sorting Network**. A combinational hardware sorting network is a specialized digital circuit designed to sort a fixed number of inputs into a specific order (ascending or descending) purely through combinational logic.

Unlike software sorting algorithms that rely on a CPU, loops, and conditional branching, a sorting network processes data simultaneously through hardwired, fixed paths. Because there are no clocks, registers, or memory elements involved in the sorting logic itself, the data simply flows from input pins to the output pins in a single propagation delay. 

## 📂 Repository Contents
* **`design.sv`**: The main SystemVerilog design file containing the structural and dataflow modeling of the network. It consists of:
  * `sorting_network`: The top-level module that routes the inputs through a 3-stage pipeline of comparator units to produce a fully sorted output.
  * `cas_unit`: The foundational Compare-and-Swap (CAS) unit.
* **`testbench.sv`**: The testbench file used to apply random and edge-case 4-bit vectors to verify the sorting logic.
* **`waveform.pdf`**: The exported simulation waveform that visually verifies the correct concurrent sorting operation, displaying the unsorted inputs alongside the sorted outputs (`out0` to `out3`).

## 🧠 Theoretical Characteristics
* **Data-independent control flow:** The sequence of comparisons is exactly the same regardless of what the input is. There are no if/then branches that change the execution path. This makes sorting networks perfectly suited for hardware implementation.
* **Massive parallelism:** Because the comparison paths are predetermined, multiple comparators can operate at the exact same time on different pairs of wires.
* **Fixed input size:** A specific sorting network is built for a strict, predetermined number of inputs (N). A network built to sort 8 numbers cannot directly sort 9 numbers without being entirely redesigned.
* **Components:** Sorting networks are constructed using only two components:
  * **Wires:** These carry the data values from left to right.
  * **Comparators:** This is a small logic block that connects two wires. It compares the values on both wires and outputs them in sorted order. For an ascending network, the smaller value is routed on the top wire, and the larger value is routed on the bottom wire. If the values are already in the correct order, they pass through unchanged.

## ⚙️ Circuit Architecture

### 1. The Core Module: The Compare & Swap (CAS)
This is the fundamental building block of your network.
* **Inputs:** Two N-bit binary numbers (`A` and `B`).
* **Outputs:** Two N-bit binary lines labeled High and Low.
* **The Comparator:** Uses magnitude comparator logic from your covered topics to evaluate if `A > B`. This output controls a single control bit (1 or 0).
* **The Router & Logic:** Connect the output of your comparator to select lines of a 2-mux. If the comparator reads high, the multiplexer routes `A` to the high output and `B` to low. If the comparator reads low, they route `B` to high and `A` to low.

### 2. The Top Module: The Sorting Network
This is where you wire multiple CAS units together. You won't write any new logic gates here; you are simply declaring wires and plugging them into instantiated CAS blocks.
* **Determine the size:** Pick a fixed number of inputs to sort, such as a 4-input sorting network.
* **Research the diagram:** Look up a 4-element bitonic sort network.
* **Instantiate and wire:** For a 4-input network, you will instantiate CAS 5 times (or 6 depending on your specific parallel layout), mapping the output of the first stage into the second stage. *(Note: The code in this repository utilizes a 6-comparator topology arranged in three distinct cross-comparison stages for maximum parallel efficiency).*

## 📊 Performance Metrics
* **Depth (Latency):** This is the maximum number of comparators a single value must pass through from input to output. Depth dictates the total propagation delay.
* **Size (Area):** This is the total number of comparators in the entire network. Size determines how much silicon area the circuit will consume and how much power it will draw.

## 💡 Applications
Combinational sorting networks are highly efficient and are primarily applied in:
1. **Network routers:** For high-speed packet scheduling.
2. **Graphics processing**.
3. **Database accelerators**.

## 🚀 How to Simulate
You can run and verify this design using any standard Verilog/SystemVerilog simulator such as **ModelSim**, **Xilinx Vivado**, **Icarus Verilog**, or an online platform like **EDA Playground**.

1. Create a new project or workspace in your simulator.
2. Compile both `design.sv` and `testbench.sv`.
3. Set the top-level module to your testbench.
4. Run the simulation and generate the waveform. 
*(Note: You can view the `waveform.pdf` included in this repo to see the verified expected outputs).*
