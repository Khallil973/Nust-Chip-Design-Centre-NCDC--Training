`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2025 12:21:21 PM
// Design Name: 
// Module Name: bit_comp_tb
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


module tb_bit_comp;

    // Inputs
    logic clk;
    logic rst;
    logic A;
    logic sel;

    // Output
    logic out;

    // Instantiate the Unit Under Test (UUT)
    bit_comp uut (
        .clk(clk),
        .rst(rst),
        .A(A),
        .sel(sel),
        .out(out)
    );

    // Clock generation: 10 time units period
    always #5 clk = ~clk;

    // Apply test inputs
    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        sel = 0;
        A = 0;
        @(posedge clk);
        
        // Reset pulse
        #10;
        rst = 0;
        
        // Test 1: Pass-through mode
        sel = 0;
        A = 0; #10;
        A = 0; #10;
        A = 1; #10;
        A = 1; #10;
        A = 0; #10;
        A = 1; #10;

        // Reset before second test
        rst = 1; #10; rst = 0;

        // Test 2: 2's complement mode
        sel = 1;
        A = 0; #10;
        A = 0; #10;
        A = 1; #10;
        A = 1; #10;
        A = 0; #10;
        A = 1; #10;
        $finish;
    end

endmodule
