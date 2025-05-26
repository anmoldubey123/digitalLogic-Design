`timescale 1ns / 1ps

// Structural
module decoder(
    input e, a, b, c, 
    output d0, d1, d2, d3, d4, d5, d6, d7
);

    wire nota, notb, notc;
    not int1(nota, a);
    not int2(notb, b);
    not int3(notc, c);
    and out0 (d0, e, nota, notb, notc); // 000
    and out1 (d1, e, nota, notb,    c); // 001
    and out2 (d2, e, nota,    b, notc); // 010
    and out3 (d3, e, nota,    b,    c); // 011
    and out4 (d4, e,    a, notb, notc); // 100
    and out5 (d5, e,    a, notb,    c); // 101
    and out6 (d6, e,    a,    b, notc); // 110
    and out7 (d7, e,    a,    b,    c); // 111

endmodule

//// Dataflow
//module decoder(
//    input e, a, b, c, 
//    output d0, d1, d2, d3, d4, d5, d6, d7
//);
//
//    assign d0 = e & ~a & ~b & ~c; // 000
//    assign d1 = e & ~a & ~b &  c; // 001
//    assign d2 = e & ~a &  b & ~c; // 010
//    assign d3 = e & ~a &  b &  c; // 011
//    assign d4 = e &  a & ~b & ~c; // 100
//    assign d5 = e &  a & ~b &  c; // 101
//    assign d6 = e &  a &  b & ~c; // 110
//    assign d7 = e &  a &  b &  c; // 111
//    
//endmodule

//// Behavioral
//module decoder(
//    input e, a, b, c, 
//    output reg d0, d1, d2, d3, d4, d5, d6, d7 // Declare outputs as reg
//);
//
//always @(*) begin
//
//    // Default value for all outputs
//    d0 = 0;
//    d1 = 0;
//    d2 = 0;
//    d3 = 0;
//    d4 = 0;
//    d5 = 0;
//    d6 = 0;
//    d7 = 0;
//
//    // Activate outputs according to the truth table
//    if(e == 1)begin 
//        case({a, b, c}) 
//            3'b000: d0 = 1; 
//            3'b001: d1 = 1; 
//            3'b010: d2 = 1; 
//            3'b011: d3 = 1; 
//            3'b100: d4 = 1; 
//            3'b101: d5 = 1; 
//            3'b110: d6 = 1; 
//            3'b111: d7 = 1; 
//        endcase
//    end
//end    
//
//endmodule

