`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2025 11:38:11 PM
// Design Name: 
// Module Name: dec_bcd_tb
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

module dec_bcd_tb;

    logic [8:0] A;
    logic [3:0] O;

    // Instantiate the DUT (Device Under Test)
    dec_bcd dut (
        .A(A),
        .O(O)
    );

    initial begin

         A = 9'b111111110;
        #10;

        A = 9'b111111101;
        #10;

    
        A = 9'b111111011;
        #10;
 
         A = 9'b111110111;
        #10;

        A = 9'b101111111;
        #10;
      ;

        $finish;
    end

endmodule
