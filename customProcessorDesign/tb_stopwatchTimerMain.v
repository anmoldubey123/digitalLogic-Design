`timescale 1ns / 1ps

module tb_stopwatchTimerMain;
    
    reg startStopButton,
        resetButton,
        clk;
        
    reg [1:0] mode;
    
    reg [3:0] dig3_load,
              dig2_load;
    
    wire [6:0] out_seg;
    wire [3:0] an;
    wire dp;
               
    stopwatchTimerMain DUT (.startStopButton(startStopButton),
                            .resetButton(resetButton),
                            .clk(clk),
                            .mode(mode),
                            .dig3_load(dig3_load),
                            .dig2_load(dig2_load),
                            .out_seg(out_seg),
                            .an(an),
                            .dp(dp));
                            
                            
    initial begin
        startStopButton = 0;
        resetButton = 0;
        clk = 0;
        mode = 0;
        dig3_load = 0;
        dig2_load = 0;
        #2
        
        resetButton = 1;
        #2
        
        resetButton = 0;
        #2
        
        startStopButton = 1;
        #2
        
        startStopButton = 0;
        #1000
        
        $finish;
    end
    
    always #1 clk = ~clk;
    
endmodule
