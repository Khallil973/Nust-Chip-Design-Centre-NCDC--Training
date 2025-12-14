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
    input  logic rst,       
    output logic out_clk,
    output logic [11:0] count_out
);


   // parameter HALF_PERIOD = 666;  
    logic [11:0] count;
    assign count_out = count;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            count    <= 0;
           // out_clk  <= 0;
        end else begin
            count <= count + 1;
        end
    end
    
    assign out_clk = count[11];

endmodule


