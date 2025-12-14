`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2025 09:22:04 PM
// Design Name: 
// Module Name: ripple_count_tb
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

module tb_up_down_counter;

    logic clk, rst, M;
    logic [3:0] Q;

    up_down_counter_4bit uut (
        .clk(clk),
        .rst(rst),
        .M(M),
        .Q(Q)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        rst = 1; 
        M = 1; 
        #10;
        rst = 0;

        // Count UP
        repeat (20) #10;

        // Switch to DOWN
        M = 0;
        repeat (20) #10;

        $finish;
    end

endmodule
