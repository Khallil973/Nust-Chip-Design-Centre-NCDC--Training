`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2025 11:24:05 AM
// Design Name: 
// Module Name: level_det_tb
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

module level_det_tb;

    // Declare testbench signals
    logic clk;
    logic rst;
    logic D;
    logic Q;

    // Instantiate the DUT
    level_det uut (
        .clk(clk),
        .rst(rst),
        .D(D),
        .Q(Q)
    );

    // Clock generation: 10ns period (100MHz)
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        $display("Time\tclk\trst\tinput\toutput");

        // Initialize
        clk = 0;
        rst = 1;
        D = 0;

        // Reset pulse
        #10;
        rst = 0;

        // Wait and then change input
        #10; D = 1;  // Rising edge (0 -> 1)
        #10; D = 1;  // No change
        #10; D = 0;  // Falling edge (1 -> 0)
        #10; D = 0;  // No change
        #10; D = 1;  // Rising edge
        #10; D = 0;  // Falling edge
        #10; D = 0;  // No change
        #10;

        $finish;
    end


  
//  initial begin 
//    $dumpfile("dump.vcd");
//    $dumpvars(0);
    
//  end 

endmodule



