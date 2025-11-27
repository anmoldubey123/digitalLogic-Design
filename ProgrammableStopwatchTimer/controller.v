`timescale 1ns / 1ps

module controller(
    input startStopButton,
          resetButton,
          clk,
    output reg reset, cnt
    );
    
    
    //  Defining States
    parameter s0 = 3'b000,     //  S0: initial
              s1 = 3'b001,     //  S1: waitForRelease
              s2 = 3'b010,     //  S2: count
              s3 = 3'b011,     //  S3: pause
              s4 = 3'b100,     //  S4: pauseWaitForPress
              s5 = 3'b101,     //  S5: pauseWaitForRelease
              s6 = 3'b110,     //  Unused State
              s7 = 3'b111;     //  Unused State
   
    
    //  4-bit State Registers
    reg [2:0] state;
    reg [2:0] nextState;
    
    
    //  Next-State and Reset Logic
    always @ (posedge clk or posedge resetButton) begin
        if (resetButton)
            state <= s0;
        else
            state <= nextState; 
    end
    
    
    //  Set Outputs and Determine Next State
    always @ (*) begin
        case (state)
        
            //  State 0: init
            s0: begin
                reset = 1;
                cnt = 0;
                
                if (startStopButton)
                    nextState = s1;
                else
                    nextState = s0;
            end
            
            //  State 1: waitForRelease
            s1: begin
                reset = 0;
                cnt = 0;
                
                if (!startStopButton)
                    nextState = s2;
                else
                    nextState = s1;
            end
            
            //  State 2: count
            s2: begin
                reset = 0;
                cnt = 1;
                
                if (startStopButton)
                    nextState = s3;
                else
                    nextState = s2;
            end
            
            //  State 3: pause
            s3: begin
                reset = 0;
                cnt = 0;
                
                if (!startStopButton)
                    nextState = s4;
                else
                    nextState = s3;
            end
            
            //  State 4: pauseWaitForPress
            s4: begin
                reset = 0;
                cnt = 0;
                
                if (startStopButton)
                    nextState = s5;
                else
                    nextState = s4;
            end
            
            //  State 5: pauseWaitForRelease
            s5: begin
                reset = 0;
                cnt = 0;
                
                if (!startStopButton)
                    nextState = s2;
                else
                    nextState = s5;
            end
            
            //  Unused States
            default: begin
                reset = 0;
                cnt = 0;
                
                nextState = s0; 
            end
            
        endcase
    end
    
endmodule
