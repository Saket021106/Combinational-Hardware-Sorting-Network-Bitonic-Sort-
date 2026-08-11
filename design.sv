module sorting_network #(
    parameter NUM_INPUTS = 4,
    parameter DATA_WIDTH = 32
)(
    input  logic clk,
    input  logic [DATA_WIDTH-1:0] in  [0:NUM_INPUTS-1],
    output logic [DATA_WIDTH-1:0] out [0:NUM_INPUTS-1]
);

    localparam M = $clog2(NUM_INPUTS);
    localparam NUM_STAGES = (M * (M + 1)) / 2;

    logic [DATA_WIDTH-1:0] pipeline_regs [0:NUM_STAGES][0:NUM_INPUTS-1];
    logic [DATA_WIDTH-1:0] comb_wires    [0:NUM_STAGES-1][0:NUM_INPUTS-1];

    always_ff @(posedge clk) begin
        for (int n = 0; n < NUM_INPUTS; n++) begin
            pipeline_regs[0][n] <= in[n];
        end
        
        for (int i = 0; i < NUM_STAGES; i++) begin
            for (int n = 0; n < NUM_INPUTS; n++) begin
                pipeline_regs[i+1][n] <= comb_wires[i][n];
            end
        end
    end

    always_comb begin
        for (int n = 0; n < NUM_INPUTS; n++) begin
            out[n] = pipeline_regs[NUM_STAGES][n];
        end
    end

    genvar p, q, idx;

    generate
        for(p = 1; p <= M; p = p + 1) begin : stage_outer
            for(q = p - 1; q >= 0; q = q - 1) begin : stage_inner
                
                localparam stage = (p * (p - 1)) / 2 + (p - 1 - q);
                localparam j = 1 << q;
                localparam k = 1 << p;

                for(idx = 0; idx < NUM_INPUTS; idx = idx + 1) begin : comp_loop
                    if((idx & j) == 0) begin : instantiate_cas
                        if((idx & k) == 0) begin : sort_asc
                            cas_unit #(DATA_WIDTH) CAS_asc (
                                .A(pipeline_regs[stage][idx]),
                                .B(pipeline_regs[stage][idx | j]),
                                .high(comb_wires[stage][idx | j]),
                                .low(comb_wires[stage][idx]),
                                .sel()
                            );
                        end else begin : sort_desc
                            cas_unit #(DATA_WIDTH) CAS_desc (
                                .A(pipeline_regs[stage][idx]),
                                .B(pipeline_regs[stage][idx | j]),
                                .high(comb_wires[stage][idx]),
                                .low(comb_wires[stage][idx | j]),
                                .sel()
                            );
                        end
                    end
                end
            end
        end
    endgenerate

endmodule


module cas_unit #(
    parameter WIDTH = 32
)(
    input  logic [WIDTH-1:0] A, B,
    output logic sel,
    output logic [WIDTH-1:0] high, low
);

    assign sel = (A > B);

    always_comb begin
        case (sel) 
            1'b1 : begin
                high = A;
                low  = B;
            end
            1'b0 : begin
                high = B;
                low  = A;
            end
            default : begin
                high = 'x; 
                low  = 'x;
            end
        endcase
    end

endmodule
