`timescale 1ns / 1ps

module tb_sorting_network;

    // Inputs
    reg clk;
    reg [31:0] in [0:3];

    // Outputs
    wire [31:0] out [0:3];

    wire [31:0] debug_in0 = in[0];
    wire [31:0] debug_in1 = in[1];
    wire [31:0] debug_in2 = in[2];
    wire [31:0] debug_in3 = in[3];

    wire [31:0] debug_out0 = out[0];
    wire [31:0] debug_out1 = out[1];
    wire [31:0] debug_out2 = out[2];
    wire [31:0] debug_out3 = out[3];

    sorting_network uut (
        .clk(clk),
        .in(in),
        .out(out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_sorting_network);

        $display("--- Starting Pipelined Sorting Network Simulation ---");

        in[0] = 32'd0; in[1] = 32'd0; in[2] = 32'd0; in[3] = 32'd0;
        #50; 

        in[0] = 32'd89; in[1] = 32'd12; in[2] = 32'd45; in[3] = 32'd4; 
        #50; 
        $display("TC1 (Scrambled):      In=[%d, %d, %d, %d] -> Out=[%d, %d, %d, %d]", in[0], in[1], in[2], in[3], out[0], out[1], out[2], out[3]);

        in[0] = 32'd10; in[1] = 32'd20; in[2] = 32'd30; in[3] = 32'd40; 
        #50;
        $display("TC2 (Already Sorted): In=[%d, %d, %d, %d] -> Out=[%d, %d, %d, %d]", in[0], in[1], in[2], in[3], out[0], out[1], out[2], out[3]);

        in[0] = 32'd100; in[1] = 32'd75; in[2] = 32'd50; in[3] = 32'd25; 
        #50;
        $display("TC3 (Reversed):       In=[%d, %d, %d, %d] -> Out=[%d, %d, %d, %d]", in[0], in[1], in[2], in[3], out[0], out[1], out[2], out[3]);

        in[0] = 32'd7; in[1] = 32'd42; in[2] = 32'd7; in[3] = 32'd18; 
        #50;
        $display("TC4 (Duplicates):     In=[%d, %d, %d, %d] -> Out=[%d, %d, %d, %d]", in[0], in[1], in[2], in[3], out[0], out[1], out[2], out[3]);

        $display("--- Simulation Complete ---");
        $finish;
    end

endmodule
