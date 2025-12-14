`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2025 10:39:11 PM
// Design Name: 
// Module Name: bcd_ripple_count_tb
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


module tb_BCD_Ripple_Counter();

    logic clk, rst;
    logic [3:0] units, tens, hundreds;

    // Instantiate the counter
    BCD_Ripple_Counter uut (
        .clk(clk),
        .rst(rst),
        .units(units),
        .tens(tens),
        .hundreds(hundreds)
    );

    // Generate clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10-time unit period
    end

    // Test sequence
    initial begin
        $display("Time\tHundreds Tens Units");
        $monitor("%0t\t\t%0d\t%0d\t%0d", $time, hundreds, tens, units);
        
        rst = 1;
        #10 rst = 0;

        // Run simulation for a few cycles
        #2000;
        $finish;
    end

endmodule

