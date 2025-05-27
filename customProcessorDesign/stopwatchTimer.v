`timescale 1ns / 1ps

module stopwatchTimer(
    input clk,
          reset,
          cnt,
    input [1:0] mode,
    input [3:0] dig3_load,
                dig2_load,
    output reg [3:0] dig3,
                     dig2,
                     dig1,
                     dig0
    );
    
    
    //  Internal Registers
    reg [3:0] terminalCount;
    reg [3:0] rollOver;
    reg [3:0] increment;
    
    
    //  Logic
    always @ (posedge clk) begin
        if (reset) begin
            case (mode)
            
                //  Mode 1: Stopwatch
                2'd0: begin
                    dig3 <= 4'd0;
                    dig2 <= 4'd0;
                    dig1 <= 4'd0;
                    dig0 <= 4'd0;
                    terminalCount <= 9;
                    rollOver <= 0;
                    increment <= 1;
                end
                
                //  Mode 2: Stopwatch with External Load
                2'd1: begin
                    dig3 <= dig3_load;
                    dig2 <= dig2_load;
                    dig1 <= 4'd0;
                    dig0 <= 4'd0;
                    terminalCount <= 9;
                    rollOver <= 0;
                    increment <= 1;
                end
                
                //  Mode 3: Timer
                2'd2: begin
                    dig3 <= 4'd9;
                    dig2 <= 4'd9;
                    dig1 <= 4'd9;
                    dig0 <= 4'd9;
                    terminalCount <= 0;
                    rollOver <= 9;
                    increment <= -1;
                end
                
                //  Mode 4: Timer with External Load
                2'd3: begin
                    dig3 <= dig3_load;
                    dig2 <= dig2_load;
                    dig1 <= 4'd0;
                    dig0 <= 4'd0;
                    terminalCount <= 0;
                    rollOver <= 9;
                    increment <= -1;
                end
            endcase
        end
        
        else if (cnt) begin
            if (dig0 == terminalCount) begin
                dig0 <= rollOver;
                
                if (dig1 == terminalCount) begin
                    dig1 <= rollOver;
                    
                    if (dig2 == terminalCount) begin
                        dig2 <= rollOver;
                        
                        if (dig3 == terminalCount) begin
                            increment <= 0;
                        end
                        
                        else begin
                            dig3 <= dig3 + increment;
                        end
                        
                    end
                    
                    else begin
                        dig2 <= dig2 + increment;
                    end
                    
                end
                
                else begin
                    dig1 <= dig1 + increment;
                end
                
            end
            
            else begin
                dig0 <= dig0 + increment;
            end
        end
            
    end
    
endmodule
