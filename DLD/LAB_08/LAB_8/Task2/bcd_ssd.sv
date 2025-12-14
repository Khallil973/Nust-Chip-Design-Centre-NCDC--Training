`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2025 10:36:59 PM
// Design Name: 
// Module Name: bcd_ssd
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


module bcd_ssd(
    input logic [3:0] bcd,
    output logic [6:0] seg,
    output logic [7:0] AN
    );
    //Common Anode
    assign AN = 8'b11111110;
  always_comb begin
    case(bcd)
    4'b0000: seg = 7'b1000000; // 0
    4'b0001: seg = 7'b1111001; // 1
    4'b0010: seg = 7'b0100100; // 2
    4'b0011: seg = 7'b0110000; // 3
    4'b0100: seg = 7'b0011001; // 4
    4'b0101: seg = 7'b0010010; // 5
    4'b0110: seg = 7'b0000010; // 6
    4'b0111: seg = 7'b1111000; // 7
    4'b1000: seg = 7'b0000000; // 8
    4'b1001: seg = 7'b0010000; // 9
    default: seg = 7'b1111111; // OFF all segments 
    endcase  
   end
endmodule
