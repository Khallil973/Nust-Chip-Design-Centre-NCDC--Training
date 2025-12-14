`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2025 11:21:05 PM
// Design Name: 
// Module Name: alu_tb
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

module ALU_tb;

    // Inputs
    logic signed [3:0] A, B;
    logic [3:0] ALUcontrol;

    // Outputs
    logic signed [3:0] Result;
    logic CarryOut, Overflow;

  
    ALU uut (
        .A(A),
        .B(B),
        .ALUcontrol(ALUcontrol),
        .Result(Result),
        .CarryOut(CarryOut),
        .Overflow(Overflow)
    );

 
    initial begin
    
        // Default values
        A = 4'd0;
        B = 4'd0;
        ALUcontrol = 4'd0;
        #10;
        
        // Test 1: Addition (3 + 4)
        A = 4'd3;
        B = 4'd4;
        ALUcontrol = 4'b0000;
        #10;

        // Test 2: Subtraction (5 - 7)
        A = 4'd5;
        B = 4'd7;
        ALUcontrol = 4'b0001;
        #10;

        // Test 3: 2's Complement of -3
        A = -4'd3;
        ALUcontrol = 4'b0010;
        #10;

        // Test 4: Increment A = 2
        A = 4'd2;
        ALUcontrol = 4'b0011;
        #10;

        // Test 5: Decrement A = 1
        A = 4'd1;
        ALUcontrol = 4'b0100;
        #10;

        // Test 6: 1-bit Left Circular Shift A = 1011
        A = 4'b1011;
        ALUcontrol = 4'b0101;
        #10;

        // Test 7: Bitwise OR (3 | 6)
        A = 4'd3;
        B = 4'd6;
        ALUcontrol = 4'b0110;
        #10;

        // Test 8: Bitwise AND (3 & 6)
        ALUcontrol = 4'b0111;
        #10;

        // Test 9: Bitwise XOR (3 ^ 6)
        ALUcontrol = 4'b1000;
        #10;

        // Test 10: Greater of -2 and 1
        A = -4'd2;
        B = 4'd1;
        ALUcontrol = 4'b1001;
        #10;

        // Test 11: Output A
        ALUcontrol = 4'b1010;
        #10;

        // Test 12: Output B
        ALUcontrol = 4'b1011;
        #10;

        $finish;
    end

endmodule

