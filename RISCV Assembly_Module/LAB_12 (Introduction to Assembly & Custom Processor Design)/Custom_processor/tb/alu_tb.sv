`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2025 12:58:34 AM
// Design Name: 
// Module Name: alu_tb
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
module alu_tb;

  // Parameters
  parameter WIDTH = 16;

  // Testbench signals
  logic [WIDTH-1:0] A, B;
  logic [1:0] opcode;
  logic [WIDTH-1:0] alu_out;

  // Instantiate ALU
  alu #(WIDTH) uut (
    .A(A),
    .B(B),
    .opcode(opcode),
    .alu_out(alu_out)
  );

  initial begin
    // Apply test cases
    A = 16'd10;  B = 16'd5;   opcode = 2'b00; #10; // ADD
    A = 16'd10;  B = 16'd5;   opcode = 2'b01; #10; // SUB
    A = 16'hF0F0; B = 16'h0FF0; opcode = 2'b10; #10; // AND
    A = 16'hF0F0; B = 16'h0FF0; opcode = 2'b11; #10; // OR

    // Finish simulation
    #10 $stop;
  end

endmodule

