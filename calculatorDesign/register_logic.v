`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2025 11:30:49 PM
// Design Name: 
// Module Name: register_logic
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

module register_logic(
    input clk,
    input enable,
    input [4:0] Data,  // 5-bit input for the sum and carry outputs
    output reg [4:0] Q  // 5-bit register output to hold the result
    );

    // Dataflow description for the register
    always @(posedge clk) begin
        if (enable)  // When enable is high, load the data into the register
            Q <= Data;
    end
endmodule
