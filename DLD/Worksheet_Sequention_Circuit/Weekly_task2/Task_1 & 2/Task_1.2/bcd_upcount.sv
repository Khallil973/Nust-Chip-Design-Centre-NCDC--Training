`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2025 08:51:40 PM
// Design Name: 
// Module Name: bcd_upcount
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
module bcd_upcount (
    input  logic clk,
    input  logic rst,
    output logic [3:0] Q
);

    logic [3:0] T;

    // Toggle inputs derived from BCD counter K-maps
    assign T[0] = 1'b1;
    assign T[1] = (~Q[3]) & Q[0];
    assign T[2] = Q[1] & Q[0];
    assign T[3] = (Q[3] & Q[0]) | (Q[2] & Q[1] & Q[0]);

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            Q <= 4'b0000;
        else begin
            //Toggle every input & output
            Q[0] <= Q[0] ^ T[0];
            Q[1] <= Q[1] ^ T[1];
            Q[2] <= Q[2] ^ T[2];
            Q[3] <= Q[3] ^ T[3];
        end
    end

endmodule
