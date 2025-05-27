`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2025 10:57:05 PM
// Design Name: 
// Module Name: RCA_4bits
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RCA_4bits(
    input clk,
    input enable,
    input [3:0] A,B,
    input Cin,
    output[4:0] Q // Load registers, should contain the 4 sum bits and Cout
    );
    
    wire [3:0] Sum;   // 4-bit sum output
    wire [3:1] Carry; // Internal carry wires
    wire Cout;        // Final carry-out
    
    full_adder FA0 (.A(A[0]), .B(B[0]), .Cin(Cin), .S(Sum[0]), .Cout(Carry[1]));
    full_adder FA1 (.A(A[1]), .B(B[1]), .Cin(Carry[1]), .S(Sum[1]), .Cout(Carry[2]));
    full_adder FA2 (.A(A[2]), .B(B[2]), .Cin(Carry[2]), .S(Sum[2]), .Cout(Carry[3]));
    full_adder FA3 (.A(A[3]), .B(B[3]), .Cin(Carry[3]), .S(Sum[3]), .Cout(Cout));
    
    register_logic REG (.clk(clk), .enable(enable), .Data({Cout, Sum}), .Q(Q));
endmodule
