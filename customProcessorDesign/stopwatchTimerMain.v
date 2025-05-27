`timescale 1ns / 1ps

module stopwatchTimerMain(
    input startStopButton, resetButton, clk,
    input [1:0] mode,
    input [3:0] dig3_load,
                dig2_load,
    output [6:0] out_seg,
    output [3:0] an,
    output dp
    );
    
    
    //  Divided Clock
    wire msClk;

    msClk msClkDiv (.clk(clk),
                    .msClk(msClk));
    
    wire [3:0] dig3,
               dig2,
               dig1,
               dig0;
               
    wire reset,
         cnt;
    
    
    controller ctrl (.startStopButton(startStopButton),
                     .resetButton(resetButton),
                     .clk(msClk),
                     .reset(reset),
                     .cnt(cnt));
                     
    stopwatchTimer u1 (.clk(msClk),
                           .reset(reset),
                           .cnt(cnt),
                           .mode(mode),
                           .dig3_load(dig3_load),
                           .dig2_load(dig2_load),
                           .dig3(dig3),
                           .dig2(dig2),
                           .dig1(dig1),
                           .dig0(dig0));
    
    wire [6:0] dig3_seg,
               dig2_seg,
               dig1_seg,
               dig0_seg;
                                       
    numToSeg_4b dig3_segConv (.num(dig3), .sseg(dig3_seg)),
                dig2_segConv (.num(dig2), .sseg(dig2_seg)),
                dig1_segConv (.num(dig1), .sseg(dig1_seg)),
                dig0_segConv (.num(dig0), .sseg(dig0_seg));
    
    wire displayClk;
    
    displayClk displayClkDiv (.clk(clk),
                              .displayClk(displayClk));
                                                    
    displayFourDigits disp (.clk(displayClk),
                            .in_seg({dig3_seg, dig2_seg, dig1_seg, dig0_seg}),
                            .out_seg(out_seg),
                            .dp(dp),
                            .an(an));
                              
endmodule
