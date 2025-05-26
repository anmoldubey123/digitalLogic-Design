`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2025 10:38:46 PM
// Design Name: 
// Module Name: display
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

//Structural
module display(
    input w,x,y,z,
    output a,b,c,d,e,f,g, an0, an1, an2, an3
    );
    
    //Instantiating and defining inverted output variables
    wire notw, notx, noty, notz;
    not n1(notw, w);
    not n2(notx, x);
    not n3(noty, y);
    not n4(notz, z);
    
    //Activate an0, deactivate an1-an3
    assign an3 = 1;
    assign an2 = 1;
    assign an1 = 1;
    assign an0 = 0;
    
    //Detect Invalid Input (Greater than 9)
    and invalidInput1(invalid1, w, x); 
    and invalidInput2(invalid2, w, y);
    or invalidOutput(invalid, invalid1, invalid2);
    
    //Output A
    and a1(w1, w, x);
    and a2(w2, w, y);
    and a3(w3, x, noty, notz);
    and a4(w4, notw, notx, noty, z);
    or out1Pre(aPre, w1, w2, w3, w4); 
    
    //Force output A to 1 if input is invalid
    or out1(a, aPre, invalid);
    
    //Output B
    and a5(w5, w, x);
    and a6(w6, w, y);
    and a7(w7, x, noty, z);
    and a8(w8, x, y, notz);
    or out2Pre(bPre, w5, w6, w7, w8);
    
    or out2(b, bPre, invalid);
    
    //Output C
    and a9(w9, w, x);
    and a10(w10, w, y);
    and a11(w11, notx, y, notz);
    or out3Pre(cPre, w9, w10, w11);
    
    or out3(c, cPre, invalid);
    
    //Output D
    and a12(w12, w, x);
    and a13(w13, w, y);
    and a14(w14, x, noty, notz);
    and a15(w15, x, y, z);
    and a16(w16, notw, notx, noty, z);
    or out4Pre(dPre, w12, w13, w14, w15, w16);
    
    or out4(d,dPre, invalid);
    
    //Output E
    and a17(w17, x, noty);
    and a18(w18, w, y);
    or out5Pre(ePre, w17, w18, z);
    
    or out5(e, ePre, invalid);
    
    //Output F
    and a19(w19, w, x);
    and a20(w20, notx, y);
    and a21(w21, y, z);
    and a22(w22, notw, notx, z);
    or out6Pre(fPre, w19, w20, w21, w22);
    
    or out6(f, fPre, invalid);
    
    //Output G
    and a23(w23, w, x);
    and a24(w24, w, y);
    and a25(w25, x, y, z);
    and a26(w26, notw, notx, noty);
    or out7Pre(gPre, w23, w24, w25, w26);
    
    or out7(g, gPre, invalid);
    
    
    
    
    
    
endmodule
