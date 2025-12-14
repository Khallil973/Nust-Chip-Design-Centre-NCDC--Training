`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2025 07:31:55 PM
// Design Name: 
// Module Name: top_module_tb
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
module top_module_tb();

    // Clock & reset signals
    logic clk;
    logic rst;

    // Instantiate DUT (Device Under Test)
    top_module #(
        .IMEM_DEPTH(4),
        .REGF_WIDTH(16),
        .ALU_WIDTH(16),
        .PROG_VALUE(3)
    ) dut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation: 10ns period (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Toggle every 5ns
    end

    // Reset sequence
    initial begin
        rst = 0;         
        #20;              
        rst = 1;          
   // $stop;
   // $stop;
       #100;
    end    

    // Simulation control
    initial begin
       
        #200;
        $display("Simulation finished, check regfile.dump for register contents.");

    end

endmodule

