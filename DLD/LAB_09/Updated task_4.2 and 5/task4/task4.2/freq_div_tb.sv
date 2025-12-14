`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2025 11:31:14 PM
// Design Name: 
// Module Name: freq_div_tb
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

module freq_div_tb;

    logic clk;
    logic rst;
    logic [11:0]count_out;
    logic out_clk;

    freq_div dut (
        .clk(clk),
        .rst(rst),
        .count_out(count_out),
        .out_clk(out_clk)
    );

    // Generate 100 MHz clock => 10ns period
    always #5 clk =~clk;
    
    initial begin
        clk = 0;
        rst = 1;
        #10;
        
        rst = 0;
        #100000; // run for 200us (15 full cycles)
        $finish;
    end

endmodule


