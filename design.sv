module sorting_network (
    input [3:0] in0, in1, in2, in3,
    output [3:0] out0, out1, out2, out3
);

    wire [3:0] s1_w0, s1_w1, s1_w2, s1_w3;

    cas_unit stage1_top (
        .A(in0),
        .B(in1),
        .high(s1_w0),
        .low(s1_w1),
        .sel()
    );

    cas_unit stage1_bottom (
        .A(in2),
        .B(in3),
        .high(s1_w3),
        .low(s1_w2),
        .sel()
    );

    wire [3:0] s2_w0, s2_w1, s2_w2, s2_w3;

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

    cas_unit stage3_top (
        .A(s2_w0),
        .B(s2_w2),
        .high(out0),
        .low(out1),
        .sel()
    );

    cas_unit stage3_bottom (
        .A(s2_w1),
        .B(s2_w3),
        .high(out2),
        .low(out3),
        .sel()
    );

endmodule


module cas_unit (
    input [3:0] A,
    input [3:0] B,
    output sel,
    output reg [3:0] high,
    output reg [3:0] low
);

    wire [3:0] x;
    assign x = ~(A ^ B);

    assign sel = (A[3] & (~B[3])) | (x[3] & A[2] & (~B[2])) | (x[3] & x[2] & A[1] & (~B[1])) | (x[3] & x[2] & x[1] & A[0] & (~B[0]));
    
    always @(*) begin
        case (sel)
            1'b1 : begin
                high = A;
                low = B;
            end
            1'b0 : begin
                high = B;
                low = A;
            end
        endcase
    end

endmodule
