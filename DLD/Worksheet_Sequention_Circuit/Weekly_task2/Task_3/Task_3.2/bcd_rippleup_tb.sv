`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2025 10:23:19 PM
// Design Name: 
// Module Name: bcd_rippleup_tb
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

module bcd_ripple_up_counter_tb;

    logic clk;
    logic rst;
    logic [3:0] Q;

    // Instantiate the counter module
    bcd_ripple_up_counter uut (
        .clk(clk),
        .rst(rst),
        .Q(Q)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize
        clk = 0;
        rst = 1;

        // Hold reset for a few cycles
        #10;
        rst = 0;

        // Let the counter run for a few cycles
        #200;

        // Apply another reset in between
        rst = 1;
        #10;
        rst = 0;

        // Run again
        #100;

        $finish;
    end

endmodule
