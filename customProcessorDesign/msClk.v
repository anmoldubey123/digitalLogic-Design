`timescale 1ns / 1ps

module msClk(
    input clk,
    output msClk
    );
    
    reg [19:0] count = 0;
    assign msClk = count[19];
    
    always @ (posedge clk)
            count <= count + 1;
    
endmodule
