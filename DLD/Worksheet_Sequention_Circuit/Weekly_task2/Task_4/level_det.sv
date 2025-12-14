`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2025 11:23:38 AM
// Design Name: 
// Module Name: level_det
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
module level_det (
    input  logic clk,
    input  logic rst,
    input  logic D,
    output logic Q
);

    logic previous_state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            previous_state   <= 0;
            Q <= 0;
        end else begin
            Q <= D ^ previous_state;
            previous_state  <= D;
        end
    end

endmodule



