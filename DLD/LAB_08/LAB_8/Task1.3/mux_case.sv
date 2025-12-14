`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2025 02:53:37 PM
// Design Name: 
// Module Name: mux_case
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

module Mux4x1(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    input  logic [1:0] s,
    output logic y
);



//Gate Level Modeling
//    always_comb begin
//        case (s)
//            2'b00: y = a;
//            2'b01: y = b;
//            2'b10: y = c;
//            2'b11: y = d;
//            default: y = 1'b0; 
//        endcase
//    end
    
    
    
endmodule

