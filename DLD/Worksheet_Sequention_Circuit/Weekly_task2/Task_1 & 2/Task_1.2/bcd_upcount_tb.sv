`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2025 08:52:09 PM
// Design Name: 
// Module Name: bcd_upcount_tb
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
module bcd_upcount_tb;

    logic clk;
    logic rst;
    logic [3:0] Q;

    // Instantiate the DUT (Design Under Test)
    bcd_upcount uut (
        .clk(clk),
        .rst(rst),
        .Q(Q)
    );

    // Clock generation: toggle every 5 ns
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;

        // Apply reset
        #10;
        rst = 0;

        #200;

        $finish;
    end

endmodule

