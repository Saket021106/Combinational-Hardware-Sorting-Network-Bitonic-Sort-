// ============================================================================
// Module: sorting_network
// Description: A 4-element sorting network that sorts four 4-bit values.
//              It routes the highest value to 'out0' and the lowest to 'out3'
//              using a 3-stage Compare-and-Swap (CAS) topology.
// ============================================================================
module sorting_network (
    input  [3:0] in0, in1, in2, in3,  // Four 4-bit unsorted inputs
    output [3:0] out0, out1, out2, out3 // Four 4-bit sorted outputs
);

    // Wires connecting the outputs of Stage 1 to the inputs of Stage 2
    wire [3:0] s1_w0, s1_w1, s1_w2, s1_w3;

    // ------------------------------------------------------------------------
    // STAGE 1: Initial pairwise comparisons
    // ------------------------------------------------------------------------
    
    // Compares in0 and in1
    cas_unit stage1_top (
        .A(in0),
        .B(in1),
        .high(s1_w0), // Max of (in0, in1)
        .low(s1_w1),  // Min of (in0, in1)
        .sel()        // Unconnected (not needed at this level)
    );

    // Compares in2 and in3
    cas_unit stage1_bottom (
        .A(in2),
        .B(in3),
        .high(s1_w3), // Max of (in2, in3)
        .low(s1_w2),  // Min of (in2, in3)
        .sel()
    );

    // Wires connecting the outputs of Stage 2 to the inputs of Stage 3
    wire [3:0] s2_w0, s2_w1, s2_w2, s2_w3;

    // ------------------------------------------------------------------------
    // STAGE 2: Cross-comparisons
    // ------------------------------------------------------------------------
    
    cas_unit stage2_top (
        .A(s1_w0),
        .B(s1_w2),
        .high(s2_w0),
        .low(s2_w1),
        .sel()
    );

    cas_unit stage2_bottom (
        .A(s1_w1),
        .B(s1_w3),
        .high(s2_w2),
        .low(s2_w3),
        .sel()
    );

    // ------------------------------------------------------------------------
    // STAGE 3: Final comparisons to output the fully sorted arrays
    // ------------------------------------------------------------------------
    
    cas_unit stage3_top (
        .A(s2_w0),
        .B(s2_w2),
        .high(out0), // Absolute maximum value goes to out0
        .low(out1),
        .sel()
    );

    cas_unit stage3_bottom (
        .A(s2_w1),
        .B(s2_w3),
        .high(out2),
        .low(out3),  // Absolute minimum value goes to out3
        .sel()
    );

endmodule


// ============================================================================
// Module: cas_unit (Compare-and-Swap Unit)
// Description: Takes two 4-bit inputs and compares them. The greater value
//              is routed to the 'high' output, and the lesser value is 
//              routed to the 'low' output.
// ============================================================================
module cas_unit (
    input      [3:0] A,    // First 4-bit input
    input      [3:0] B,    // Second 4-bit input
    output           sel,  // Selection bit (1 if A > B, 0 otherwise)
    output reg [3:0] high, // Receives the larger of the two inputs
    output reg [3:0] low   // Receives the smaller of the two inputs
);

    // ------------------------------------------------------------------------
    // Magnitude Comparator Logic
    // ------------------------------------------------------------------------
    
    wire [3:0] x;
    
    // Bitwise XNOR: x[i] will be 1 if A[i] and B[i] are equal
    assign x = ~(A ^ B);

    // Determine if A > B by checking bits from most to least significant:
    // 1. A[3] is 1 and B[3] is 0
    // 2. Or bit 3 is equal, and A[2] is 1 while B[2] is 0
    // 3. Or bits 3,2 are equal, and A[1] is 1 while B[1] is 0
    // 4. Or bits 3,2,1 are equal, and A[0] is 1 while B[0] is 0
    assign sel = (A[3] & (~B[3])) | 
                 (x[3] & A[2] & (~B[2])) | 
                 (x[3] & x[2] & A[1] & (~B[1])) | 
                 (x[3] & x[2] & x[1] & A[0] & (~B[0]));
    
    // ------------------------------------------------------------------------
    // Routing Logic (Multiplexer)
    // ------------------------------------------------------------------------
    
    // Route the inputs to high/low outputs based on the comparison (sel)
    always @(*) begin
        case (sel)
            // If A > B
            1'b1 : begin
                high = A; // A is larger
                low  = B; // B is smaller
            end
            
            // If A <= B
            1'b0 : begin
                high = B; // B is larger (or they are equal)
                low  = A; // A is smaller
            end
        endcase
    end

endmodule
