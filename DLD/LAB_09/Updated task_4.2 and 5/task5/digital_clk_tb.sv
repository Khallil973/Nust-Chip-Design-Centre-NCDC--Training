`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2025 05:17:10 PM
// Design Name: 
// Module Name: digital_clk_tb
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
module digital_clk_tb;

    logic clk_50 = 0;
    logic rst;
    logic [25:0] count_out;
    logic clk_1;
    logic [5:0] sec, min;
    logic [4:0] hr;

    // Instantiate DUT
    digital_clk dut (
        .clk_50(clk_50),
        .rst(rst),
        .count_out(count_out),
        .clk_1(clk_1),
        .sec(sec),
        .min(min),
        .hr(hr)
    );

   
    always #10 clk_50 = ~clk_50;

    initial begin
        rst = 1;
        #40;
        rst = 0;
        
        #5_000_000;
        $stop;
    end

endmodule

