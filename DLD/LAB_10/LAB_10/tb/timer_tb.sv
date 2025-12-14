`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 11:53:30 AM
// Design Name: 
// Module Name: timer_tb
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


module timer_tb();

    // Testbench signals
    logic clk_25;
    logic rst;
    logic start_time;
    logic [3:0] time_value;
    logic [24:0] count_out;
    logic clk_1;
    logic expired;

    timer uut (
        .clk_25(clk_25),
        .rst(rst),
        .start_time(start_time),
        .time_value(time_value),
        .count_out(count_out),
        .clk_1(clk_1),
        .expired(expired)
    );

    // Generate 25 MHz clock (period = 40ns)
    always #20 clk_25 = ~clk_25;

    // Stimulus
    initial begin
        clk_25 = 0;
        rst = 1;
        start_time = 0;
        time_value = 4'd0;

        // Hold reset for some time
        #100;
        rst = 0;

        // Start timer with 4 seconds
        #100;
        time_value = 4'd4;
        start_time = 1;
        #40;
        start_time = 0;

        // Wait for countdown to complete (simulate enough time)
        // 4 seconds * 25,000,000 cycles = 100,000,000 cycles
        // 1 cycle = 40 ns --> total = 4s = 100 million * 40 ns = 4s
        wait (expired == 1);

        // Add another test case (e.g., 6 seconds)
        #100;
        time_value = 4'd6;
        start_time = 1;
        #40;
        start_time = 0;

        wait (expired == 1);


        $finish;
    end

endmodule
