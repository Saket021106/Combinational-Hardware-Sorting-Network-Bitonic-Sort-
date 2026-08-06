`timescale 1ns / 1ps

module tb_sorting_network;

    // Inputs (Registers to hold the test values)
    reg [3:0] in0, in1, in2, in3;

    // Outputs (Wires to observe the network's result)
    wire [3:0] out0, out1, out2, out3;

    // Instantiate the Top-Level Module (Unit Under Test)
    sorting_network uut (
        .in0(in0), 
        .in1(in1), 
        .in2(in2), 
        .in3(in3),
        .out0(out0), 
        .out1(out1), 
        .out2(out2), 
        .out3(out3)
    );

    initial begin
        // Tell the simulator to dump waveform data for GTKWave
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_sorting_network);

        $display("--- Starting Combinational Sorting Network Simulation ---");

        // Test Case 1: Already Sorted (Descending)
        in0 = 4'd9; in1 = 4'd7; in2 = 4'd4; in3 = 4'd2; 
        #10; // Wait 10ns for propagation
        $display("TC1 (Already Sorted): In=[%d, %d, %d, %d] -> Out=[%d, %d, %d, %d]", in0, in1, in2, in3, out0, out1, out2, out3);

        // Test Case 2: Completely Reversed (Ascending)
        in0 = 4'd1; in1 = 4'd3; in2 = 4'd8; in3 = 4'd15; 
        #10;
        $display("TC2 (Reversed):       In=[%d, %d, %d, %d] -> Out=[%d, %d, %d, %d]", in0, in1, in2, in3, out0, out1, out2, out3);

        // Test Case 3: Randomly Scrambled
        in0 = 4'd6; in1 = 4'd12; in2 = 4'd2; in3 = 4'd10; 
        #10;
        $display("TC3 (Scrambled):      In=[%d, %d, %d, %d] -> Out=[%d, %d, %d, %d]", in0, in1, in2, in3, out0, out1, out2, out3);

        // Test Case 4: Duplicate Values
        in0 = 4'd5; in1 = 4'd11; in2 = 4'd5; in3 = 4'd5; 
        #10;
        $display("TC4 (Duplicates):     In=[%d, %d, %d, %d] -> Out=[%d, %d, %d, %d]", in0, in1, in2, in3, out0, out1, out2, out3);

        $display("--- Simulation Complete ---");
        $finish;
    end

endmodule
