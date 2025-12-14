`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2025 08:14:21 PM
// Design Name: 
// Module Name: cla_4bit_tb
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


module cla_4bit_tb;

    logic [3:0] A, B;
    logic       Cin;
    logic [3:0] sum;
    logic  cout;

    // Instantiate the CLA module
    cla_4bit uut (
                   .A(A), 
                   .B(B), 
                   .Cin(Cin),
                   .sum(sum),
                   .cout(cout)
    );

    initial begin
        // Case 1
        A = 4'b0000; 
        B = 4'b0000; 
        Cin = 0;
        #10;
        //Case 2
        A = 4'b0001; 
        B = 4'b0010; 
        Cin = 0;
        #10;
        
        //Case 3
        A = 4'b0101; 
        B = 4'b0011; 
        Cin = 1;
        #10;
        
        //Case 4
        A = 4'b1111; 
        B = 4'b1111; 
        Cin = 0;
        #10;
        
        //Case 5
        A = 4'b1001; 
        B = 4'b0110; 
        Cin = 1;
        #10;
        
        //Case 6
        A = 4'b0011; 
        B = 4'b1100; 
        Cin = 0;
        #10;

        $finish;
    end
    
    
endmodule
