`timescale 1ns / 1ps

module tb_stopwatchTimer;
    
    reg clk,
        reset,
        cnt;
    
    reg [1:0] mode;
    
    reg [3:0] dig3_load,
              dig2_load;
              
    wire [3:0] dig3,
               dig2,
               dig1,
               dig0;
               
    stopwatchTimer DUT (.clk(clk),
                        .reset(reset),
                        .cnt(cnt),
                        .mode(mode),
                        .dig3_load(dig3_load),
                        .dig2_load(dig2_load),
                        .dig3(dig3),
                        .dig2(dig2),
                        .dig1(dig1),
                        .dig0(dig0));
                        
    initial begin
        clk = 0;
        reset = 0;
        cnt = 0;
        mode = 0;
        dig3_load = 4'd4;
        dig2_load = 4'd3;
        #2
        
        //  Testing Mode 1: Stopwatch
        mode = 0;
        reset = 1;
        cnt = 0;
        #2
        
        reset = 0;
        #10
        
        cnt = 1;
        #50
        
        //  Testing Mode 2: Stopwatch with External Load
        mode = 1;
        reset = 1;
        cnt = 0;
        #2
        
        reset = 0;
        #10
        
        cnt = 1;
        #50
        
        //  Testing Mode 3: Timer
        mode = 2;
        reset = 1;
        cnt = 0;
        #2
        
        reset = 0;
        #10
        
        cnt = 1;
        #50
        
        //  Testing Mode 4: Timer with External Load
        mode = 3;
        reset = 1;
        cnt = 0;
        #2
        
        reset = 0;
        #10
        
        cnt = 1;
        #50
        
        $finish;
    end
    
    always #1 clk = ~clk;
    
endmodule
