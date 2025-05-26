`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2025 12:11:26 AM
// Design Name: 
// Module Name: tb_display
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


module tb_display;
    reg w,x,y,z;
    wire a,b,c,d,e,f,g, an0, an1, an2, an3;
    
    display dut (.w(w), .x(x), .y(y), .z(z), .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .an0(an0), .an1(an1), .an2(an2), .an3(an3));
    
    initial begin
        w=0;x=0;y=0;z=0;
        #10
        w=0;x=0;y=0;z=1;
        #10
        w=0;x=0;y=1;z=0;
        #10
        w=0;x=0;y=1;z=1;
        #10
        w=0;x=1;y=0;z=0;
        #10
        w=0;x=1;y=0;z=1;
        #10
        w=0;x=1;y=1;z=0;
        #10
        w=0;x=1;y=1;z=1;
        #10
        w=1;x=0;y=0;z=0;
        #10
        w=1;x=0;y=0;z=1;
        #10
        w=1;x=0;y=1;z=0;
        #10
        w=1;x=0;y=1;z=1;
        #10
        w=1;x=1;y=0;z=0;
        #10
        w=1;x=1;y=0;z=1;
        #10
        w=1;x=1;y=1;z=0;
        #10
        w=1;x=1;y=1;z=1;
        #10
        $finish;
    end

endmodule
