`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2025 11:30:37 PM
// Design Name: 
// Module Name: clk_div
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
/////////////////////////////////////////////////////////////////////////////////
module freq_div (
    input  logic clk,       // 100 MHz input
    input  logic rst,       // Active-high reset
    output logic out_clk    // ~75 kHz output
);

    // Divide by 1332 (toggle every 666)
    parameter HALF_PERIOD = 666;  
    logic [15:0] count;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            count    <= 0;
            out_clk  <= 0;
        end else begin
            if (count == HALF_PERIOD - 1) begin
                count    <= 0;
                out_clk  <= ~out_clk;  // toggle
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule


