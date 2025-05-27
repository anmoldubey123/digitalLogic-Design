`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2025 07:44:16 AM
// Design Name: 
// Module Name: clk_div_disp
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


module clk_div_disp(
    input clk,
    input reset,
    output slow_clk
    );
    
    reg [24:0] COUNT;
    
    assign slow_clk = COUNT[24];
    
    always @(posedge clk)
    begin
    if(reset)
        COUNT = 0;
    else 
        COUNT = COUNT + 1;
    end
endmodule
