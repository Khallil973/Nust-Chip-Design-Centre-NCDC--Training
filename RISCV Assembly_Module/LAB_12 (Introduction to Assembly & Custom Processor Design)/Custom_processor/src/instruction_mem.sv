`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2025 05:00:34 PM
// Design Name: 
// Module Name: instruction_mem
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
module instruction_mem #(
    parameter WIDTH = 8,       // Each instruction is 8 bits wide
    parameter DEPTH = 4        // Memory can store 4 instructions
)(
    input logic clk,
    input logic rst,            // Active low reset
    input logic [$clog2(DEPTH)-1:0] A,  // Address input
    output logic [WIDTH-1:0] instruction
);
    
    // Memory declaration with parameterized depth
    logic [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Initialize memory from binary file
    initial begin
        $readmemb("C:/Users/lab/Documents/SV/Lab_12/Lab_12_Custom_Processor/fib_im.mem", mem);
    end
    
    // Memory read operation with reset
    always_comb begin
        if (!rst) begin
            instruction = '0;  // Reset condition
        end
        else begin
            instruction = mem[A];  // Normal operation
        end
    end
    
endmodule


