`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2024 05:33:48 PM
// Design Name: 
// Module Name: timer_parameter
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


module timer_parameter 
    #(parameter FINAL_VALUE = 255)(
    input clk,
    input reset_n,
    input enable,
    output done
    );
    
    localparam BITS = $clog2(FINAL_VALUE);
    
    reg [BITS - 1:0] Q_reg, Q_next;
    
    always @(posedge clk, negedge reset_n)
    begin 
        if(~reset_n)
            Q_reg <= 'b0;
        else if(enable)
            Q_reg <= Q_next;
        else 
            Q_reg <= Q_reg;
    end
endmodule
