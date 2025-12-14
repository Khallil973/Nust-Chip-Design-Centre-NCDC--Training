`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2025 08:13:57 PM
// Design Name: 
// Module Name: cla_4bit
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


module cla_4bit(
    input logic [3:0] A,
    input logic [3:0] B,
    input logic Cin,
    output logic [3:0] sum,
    output logic cout
    );
    
    logic [3:0] P, G;
    logic [4:0] C;
    
    
    assign P = A ^ B; //Propagate
    assign G = A & B; // Generate
    
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & G[0]);
    assign C[2] = G[1] | (G[0] & P[1]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (G[1] & P[2]) | (G[0] & P[2] & P[1]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (G[2] & P[3]) | (G[1] & P[3] & P[2]) | (G[0] & P[3] & P[2] & P[1]) | (P[3] & P[2] & P[1] & P[0] & C[0]);
    
    assign sum = P ^ C[3:0]; //sum = propagate xor with carry in 
    assign cout = C[4];
    
endmodule
