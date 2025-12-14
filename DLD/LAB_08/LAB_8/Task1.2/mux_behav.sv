`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2025 08:57:48 PM
// Design Name: 
// Module Name: mux_behav
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


module mux_behav(
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    input logic [1:0] s,
    output logic y
);
//Behavorial Level
    always_comb begin
        if (s == 2'b00)
            y = a;
        else if (s == 2'b01)
            y = b;
        else if (s == 2'b10)
            y = c;
        else
            y = d;
    end
endmodule
