`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2025 10:37:29 PM
// Design Name: 
// Module Name: bcd_ssd_tb
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


module bcd_ssd_tb;
    logic [3:0] bcd;
    logic [6:0] seg;
    
    bcd_ssd dut(
        .bcd(bcd),
        .seg(seg) 
   );
   
 initial begin
          // Test BCD 0
          bcd = 4'b0000;
          #10;
  
          // Test BCD 1
          bcd = 4'b0001;
          #10;
  
          // Test BCD 2
          bcd = 4'b0010;
          #10;
  
          // Test BCD 3
          bcd = 4'b0011;
          #10;
  
          $finish;
      end

endmodule
