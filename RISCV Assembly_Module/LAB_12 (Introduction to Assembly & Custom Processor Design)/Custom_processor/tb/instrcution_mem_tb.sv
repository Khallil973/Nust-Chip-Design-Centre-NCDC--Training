`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2025 01:15:10 AM
// Design Name: 
// Module Name: instrcution_mem_tb
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
module instruction_mem_tb;

  parameter WIDTH = 8;
  parameter DEPTH = 4;

  // Testbench signals
  logic clk;
  logic rst;
  logic [$clog2(DEPTH)-1:0] A;
  logic [WIDTH-1:0] instruction;

  // Instantiate the instruction memory
  instruction_mem #(WIDTH, DEPTH) uut (
    .clk(clk),
    .rst(rst),
    .A(A),
    .instruction(instruction)
  );

  // Clock generation (10ns period)
  always #5 clk = ~clk;

  initial begin
    // Initial values
    clk = 0;
    rst = 0;
    A   = 0;

    // Hold reset low
    #10;
    rst = 1; // release reset

    // Read instruction at address 0
    A = 0; #10;

    // Read instruction at address 1
    A = 1; #10;

    // Read instruction at address 2
    A = 2; #10;

    // Read instruction at address 3
    A = 3; #10;

    // Reset again to see cleared output
    rst = 0; #10;
    rst = 1; #10;

    // Finish simulation
    #10 $stop;
  end

endmodule

