`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2025 10:13:02 PM
// Design Name: 
// Module Name: counter_tb
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

module counter_tb;
    logic clk;
    logic arst_n;
    logic [3:0] out;


    counter uut (
        .clk(clk),
        .arst_n(arst_n),
        .out(out)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        arst_n = 0;
        #10;        
        arst_n = 1;  
        @(posedge clk);

        #120;
        $finish;
    end

endmodule

