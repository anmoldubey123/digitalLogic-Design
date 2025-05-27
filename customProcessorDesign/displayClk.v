`timescale 1ns / 1ps

module displayClk(
    input clk,
    output displayClk
    );

    reg [13:0] count = 0;
    assign displayClk = count[13];
    
    always @ (posedge clk)
            count <= count + 1;
    
endmodule
