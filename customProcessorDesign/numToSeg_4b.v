`timescale 1ns / 1ps


module numToSeg_4b(
    input [3:0] num,
    output reg [6:0] sseg
    );
    
    always @ (*) begin
        case (num)
            4'd0 : sseg = 7'b0000001;
            4'd1 : sseg = 7'b1001111;
            4'd2 : sseg = 7'b0010010;
            4'd3 : sseg = 7'b0000110;
            4'd4 : sseg = 7'b1001100;
            4'd5 : sseg = 7'b0100100;
            4'd6 : sseg = 7'b0100000;
            4'd7 : sseg = 7'b0001111;
            4'd8 : sseg = 7'b0000000;
            4'd9 : sseg = 7'b0000100;

            //  Unused
            default : sseg = 7'b1111111;
        endcase
    end
    
    
endmodule
