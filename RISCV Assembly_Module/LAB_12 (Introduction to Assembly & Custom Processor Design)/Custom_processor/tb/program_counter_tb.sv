`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2025 05:43:47 PM
// Design Name: 
// Module Name: program_counter_tb
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
module program_counter_tb;
    // Test signals
    logic clk = 0;
    logic rst = 1;
    logic [2:0] pc;
    logic [2:0] pc_out;
    
    // Clock generation (100MHz)
    always #5 clk = ~clk;
    
    // Instantiate DUT
    program_counter dut (.*);
    
    // Main test
    initial begin
        $display("Starting Program Counter Test");
        
        // Test 1: Reset check
        rst = 0; #10;
        $display("Reset: pc_out = %b (should be 000)", pc_out);
        
        // Test 2: Normal operation
        rst = 1;
        pc = 3'b001; #10;
        $display("Input 001: pc_out = %b", pc_out);
        
        pc = 3'b010; #10;
        $display("Input 010: pc_out = %b", pc_out);
        
        pc = 3'b100; #10;
        $display("Input 100: pc_out = %b", pc_out);
        
        // Test 3: Reset during operation
        pc = 3'b111; #5;
        rst = 0; #5;
        $display("Reset during op: pc_out = %b (should be 000)", pc_out);
        
        $display("Test completed");
        $finish;
    end
endmodule
