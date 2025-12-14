`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2025 03:00:46 PM
// Design Name: 
// Module Name: barrel_shift_tb
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


module barrel_shift_tb;

    logic [3:0] A, B;
    logic [1:0] sel;
    logic Y;
    logic [3:0] out;

    barrel_shift_top dut4 (
        .A(A),
        .B(B),
        .s(sel),
        .Y(Y),
        .out(out)
    );

    initial begin
        // Left Shift Test
        Y = 0;
        A = 4'b1011;
        B = 4'b0000; // not used in left shift
        sel = 2'b00; 
        #10;
        sel = 2'b01; 
        #10;
        sel = 2'b10; 
        #10;
        sel = 2'b11; 
        #10;

        // Right Shift Test
        Y = 1;
        A = 4'b0000;
        B = 4'b1011;
        sel = 2'b00; 
        #10;
        sel = 2'b01; 
        #10;
        sel = 2'b10; 
        #10;
        sel = 2'b11; 
        #10;
        $finish;
    end
endmodule

//module barrel_shift_tb;

//     logic [3:0] A;
//     logic [1:0] sel;
//     logic [3:0] out;

//    barrel_shifter dut(
//                    .A(A),
//                    .sel(sel),
//                    .out(out)
//    );  
   
  
//   initial begin
//    A = 4'b1011;
//    sel = 2'b00;
//    #100;
   
//    sel = 2'b01;
//   #100;
   
//   sel = 2'b10;
//   #100;
   
//   sel = 2'b11;
//   #100;
//   $finish;
//   end
   
//endmodule
