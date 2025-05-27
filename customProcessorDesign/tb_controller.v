`timescale 1ns / 1ps

module tb_controller;

    reg startStopButton,
        resetButton,
        clk;
        
    wire reset,
         cnt;
    
    controller DUT (.startStopButton(startStopButton),
                    .resetButton(resetButton),
                    .clk(clk),
                    .reset(reset),
                    .cnt(cnt));
                     
    initial begin
        startStopButton = 0;
        resetButton = 0;
        clk = 0;
        #2
        
        resetButton = 1;
        #2
        
        resetButton = 0;
        #10
        
        //  Current: State 0 (initial)
        
        startStopButton = 1;
        #10
        
        //  Current: State 1 (waitForRelease)
        
        startStopButton = 0;
        #10
        
        // Current: State 2 (count)
        
        startStopButton = 1;
        #10
        
        //  Current: State 3 (pause)
        
        startStopButton = 0;
        #10
        
        //  Current: State 4 (pauseWaitForPress)
        
        startStopButton = 1;
        #10
        
        //  Current: State 5 (pauseWaitForRelease)
        
        startStopButton = 0;
        #50
        
        //  Current: State 1 (count)
        
        resetButton = 1;
        #10
        
        //  Current: State 0 (initial)
        
        resetButton = 0;
        #10
        
        startStopButton = 1;
        #10
        
        //  Current: State 1 (waitForRelease)
        
        startStopButton = 0;
        #50
        
        //  Current: State 2 (count)
        
        
        $finish;
    end
    
    always #1 clk = ~clk;
    
endmodule
