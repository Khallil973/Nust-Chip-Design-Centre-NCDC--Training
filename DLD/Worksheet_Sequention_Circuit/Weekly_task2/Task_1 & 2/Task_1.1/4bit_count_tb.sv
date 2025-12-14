`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/02/2025 11:30:23 PM
// Design Name: 
// Module Name: 4bit_count_tb
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

module tb_down_counter_dff;

    logic clk;
    logic rst;
    logic [3:0] Q;

    // Instantiate the down counter
    down_counter_dff uut (
        .clk(clk),
        .rst(rst),
        .Q(Q)
    );

    // Generate clock: 10ns period (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Toggle clock every 5ns
    end

    // Stimulus
    initial begin
        // Initial state
        rst = 1;
        #10;            // Wait for 1 clock cycle

        rst = 0;
        #200;           // Let it count for 20 cycles

        $finish;
    end

    // Display the output at every change
    initial begin
        $monitor("Time = %0t ns | Q = %b", $time, Q);
    end

endmodule

