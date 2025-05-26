`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2025 02:56:53 AM
// Design Name: 
// Module Name: tb_mux
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


module tb_mux;
    reg i0,i1,i2,i3;
    reg s0,s1;
    wire d; //Output wire
    
    mux dut(.i0(i0), .i1(i1), .i2(i2), .i3(i3), .s0(s0), .s1(s1), .d(d));
    
    //Test Cases
    initial begin
        //Set inputs to a value (not 0000 or 1111)
        i0=0; i1=1; i2=0; i3=1;
        #10
        //Test all selector combinations
        s1=0; s0=0;
        #10
        
        s1=0; s0=1;
        #10
        
        s1=1; s0=0;
        #10
        
        s1=1; s0=1;
        #10
        
        //Change input values 
        i0=1; i1=0; i2=1; i3=0;
        
        //Test all selector combinations again
        s1=0; s0=0;
        #10
        
        s1=0; s0=1;
        #10
        
        s1=1; s0=0;
        #10
        
        s1=1; s0=1;
        #10
        
        //End Simulation
        $finish;
    end
endmodule


