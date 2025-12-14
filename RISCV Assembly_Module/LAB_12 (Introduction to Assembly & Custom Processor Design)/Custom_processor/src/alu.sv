`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2025 03:44:03 PM
// Design Name: 
// Module Name: alu
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
module alu #(parameter WIDTH = 16)(
   input logic [WIDTH-1:0] A,
   input logic [WIDTH-1:0] B,
   input logic [1:0] opcode ,
   output logic [WIDTH-1:0] alu_out
 );
 
 always_comb begin
    case(opcode) 
        2'b00 : alu_out = A + B;
        2'b01 : alu_out = A - B;
        2'b10 : alu_out = A & B;
        2'b11 : alu_out = A | B;
        default: alu_out = 16'b0 ;
    endcase
 end
    
endmodule
