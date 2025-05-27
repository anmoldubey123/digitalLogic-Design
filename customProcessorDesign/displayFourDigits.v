`timescale 1ns / 1ps

module displayFourDigits(
    input clk,
    input [27:0] in_seg,
    output reg [6:0] out_seg,
    output reg dp,
    output reg [3:0] an
    );
    
    reg [1:0] index = 0;
    
    always @ (posedge clk) begin
        dp <= 1;
        
        case (index)
            2'd0: begin
                out_seg <= in_seg[6:0];
                an <= 4'b1110;
            end
            
            2'd1: begin
                out_seg <= in_seg[13:7];
                an <= 4'b1101;
            end
            
            2'd2: begin
                out_seg <= in_seg[20:14];
                dp <= 0;
                an <= 4'b1011;
            end
            
            2'd3: begin
                out_seg <= in_seg[27:21];
                an <= 4'b0111;
            end
            
        endcase
        
        index <= index + 1;
    end
    
    
endmodule
