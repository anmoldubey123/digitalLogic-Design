`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2025 06:11:12 AM
// Design Name: 
// Module Name: tb_rising_edge_detector
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


module tb_rising_edge_detector;
    reg clk;
    reg signal;
    reg reset;
    wire outedge;

    rising_edge_detector u1(
    .clk(clk),
    .signal(signal),
    .reset(reset),
    .outedge(outedge)
    );
    
initial
begin

clk = 0;
signal = 0;
reset = 1;

#40;

signal = 0;
reset = 0;

#40;

signal = 1;

#40;

signal = 1;

#40; 

signal = 0;

#40;

signal = 1;

#40;

signal = 0;

#40;

signal = 1;

#40;

signal = 0;

#40;

signal = 1;

#40;

signal = 0;

#40;

signal = 1;

#40;


end

always 
#5 clk = ~clk ;

endmodule
