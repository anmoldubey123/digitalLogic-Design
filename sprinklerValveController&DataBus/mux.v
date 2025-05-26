`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2025 02:32:58 AM
// Design Name: 
// Module Name: mux
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

/*
//Structural
module mux(
    input i0,i1,i2,i3,
    input s0,s1,
    output d

    );
    
    wire ns0, ns1; //Complement of select lines
    wire y0,y1,y2,y3; //Intermediate AND gate outputs
    
    not(ns0, s0); 
    not(ns1, s1);
    
    //AND Gates to select the correct output
    and(y0, i0, ns1, ns0); //i0 selected when s1s0 = 00
    and(y1, i1, ns1, s0);  //i1 selected when s1s0 = 01
    and(y2, i2, s1, ns0);  //i2 selected when s1s0 = 10
    and(y3, i3, s1, s0);   //i3 selected when s1s0 = 11
    
    //OR Gate to produce final output
    or(d, y0, y1, y2, y3);
    
endmodule
*/

//Behavioral
module mux(
    input i0,i1,i2,i3, //Data inputs
    input s0,s1,       //Select Lines
    output reg d       //Output
);

always @(*) begin
    case({s1, s0})
        2'b00: d = i0; //When s1s0 = 00, output i0
        2'b01: d = i1; //When s1s0 = 01, output i1
        2'b10: d = i2; //When s1s0 = 10, output i2
        2'b11: d = i3; //When s1s0 = 11, output i3
    endcase
end

endmodule


