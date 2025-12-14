`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 10:36:10 AM
// Design Name: 
// Module Name: debounce_tb
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
module debounce_tb();

    logic clk_in;
    logic rst_in;
    logic noisy_in;
    logic clean_out;
    logic [19:0] count_out;
    logic new_1;

    // Instantiate the DUT
    debounce uut (
        .clk_in(clk_in),
        .rst_in(rst_in),
        .noisy_in(noisy_in),
        .clean_out(clean_out),
        .count_out(count_out),   
        .new_1(new_1)  
    );

    // Clock generation (10ns period = 100MHz)
    initial clk_in = 0;
    always #5 clk_in = ~clk_in;

    // Stimulus
    initial begin


        // Reset
        rst_in = 1;
        noisy_in = 0;
        #20;
        rst_in = 0;
        @(posedge clk_in);

        // Simulate bouncing (toggle every 10ns for 40ns)
        noisy_in = 1; #10;
        noisy_in = 0; #10;
        noisy_in = 1; #10;
        noisy_in = 0; #10;


        noisy_in = 1;
        #1_100_000;  

   
        noisy_in = 0;
        #1_100_000;

        $finish;
    end

endmodule
