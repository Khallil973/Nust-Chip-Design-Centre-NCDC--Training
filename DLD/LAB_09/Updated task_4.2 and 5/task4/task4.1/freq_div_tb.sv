`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2025 11:05:42 PM
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


module freq_div_tb();
    logic clk;
    logic rst;
    logic out_clk;
 
 freq_div dut(
                .clk(clk),
                .rst(rst),
                .out_clk(out_clk)
        );
        
        
   always #5 clk = ~clk;
   
   initial begin
           clk = 0;
           rst = 1;
   
           // Hold reset for 20 ns
           #20;
           rst = 0;
   
           // Run for 200 ns
           #200;
   
           $finish;
       end

endmodule
