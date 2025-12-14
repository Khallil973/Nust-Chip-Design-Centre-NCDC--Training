`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2025 11:05:00 PM
// Design Name: 
// Module Name: freq_div
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


module freq_div(
    input logic clk,
    input logic rst,
    output logic out_clk
    );
    
    logic [1:0] count;
    
    
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            count <= 0;
            out_clk <=  0;
        end
        else begin 
            count <= count + 1;
            if (count == 2) begin
                out_clk <= ~out_clk;
            end
        end
    end
    
endmodule
