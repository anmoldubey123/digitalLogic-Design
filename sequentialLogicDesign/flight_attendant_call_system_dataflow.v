`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2025 05:23:08 AM
// Design Name: 
// Module Name: flight_attendant_call_system_dataflow
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


module flight_attendant_call_system_dataflow(
input wire clk,
input wire call_button,
input wire cancel_button,
output reg light_state

    );
    
wire next_state;

//Combinational Block
assign next_state = call_button || (~cancel_button && light_state);

always @(posedge clk) begin
    light_state <= next_state;
 end
endmodule
