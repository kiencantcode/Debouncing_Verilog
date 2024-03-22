`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2024 01:44:21 PM
// Design Name: 
// Module Name: debouncing
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debouncing(
    input clk, reset_n,
    input noisy, timer_done,
    input timer_reset, debounced,
    input timer_flag
    );
    
    reg [1:0] state_reg, state_next;
    parameter s0 = 0, s1 = 1, s2 = 2, s3 = 3, s4 = 4;
    
    // Sequential state register
    always @(posedge clk, negedge reset_n)
    begin
        if(~reset_n)
            state_reg <= 0;
        else 
            state_reg <= state_next;
    end
    
    //Next state logic
    always @(*)
    begin 
        state_next = state_reg;
        case (state_reg)
            s0: if(noisy == 0)
                    state_next = s0;
                else if(noisy == 1)
                    state_next = s1;
            s1: if(noisy == 0)
                    state_next = s0;
                else if(noisy == 1 & timer_done == 0)
                    state_next = s1;
                else if(noisy == 1 & timer_done == 1)
                    state_next = s2;
            s2: if(noisy == 0)
                    state_next = s3;
                else if(noisy == 1)
                    state_next = s2;
            s3: if(noisy == 1)
                    state_next = s2;
                else if(noisy == 0 & timer_done == 0)
                    state_next = s3;
                else if(noisy == 0 & timer_done == 1)
                    state_next = s4;
            s4:
                if (noisy == 0 && timer_flag == 1)
                    state_next = s0;
                else if(noisy == 0)
                    state_next = s4;
            default: state_next = s0;
        endcase
    end
    
    //Output logic
    assign timer_reset = (state_reg == s0) | (state_reg == s2); 
    assign debounced = (state_reg == s2) | (state_reg == s4); 
endmodule
