`timescale 1ns / 1ps

module CLA_4bits(
    input clk,
    input enable,
    input [3:0] A, B,
    input Cin,
    output reg [4:0] Q  // Register output (Cout + Sum)
    );

    wire [3:0] G, P, Sum; // Generate, Propagate, and Sum bits
    wire [4:0] C; // Carry bits

    // Carry-in
    assign C[0] = Cin;

    // Generate (G) and Propagate (P) calculations
    assign G = A & B;        // Gi = Ai * Bi
    assign P = A ^ B;        // Pi = Ai ⊕ Bi

    // Carry Lookahead Equations
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);

    // Sum calculation
    assign Sum = P ^ C[3:0]; // Si = Pi ⊕ Ci

    // Register Logic - Store the result on clock edge when enabled
    always @(posedge clk) begin
        if (enable)
            Q <= {C[4], Sum}; // Store Cout (C[4]) and Sum in Q
    end

endmodule
