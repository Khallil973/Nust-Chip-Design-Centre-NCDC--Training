`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2025 11:20:44 PM
// Design Name: 
// Module Name: alu
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
module ALU (
    input  logic signed [3:0] A, B,
    input  logic [3:0] ALUcontrol, // 4-bit control signal
    output logic signed [3:0] Result,
    output logic CarryOut,
    output logic Overflow
);

    logic signed [4:0] sum_result; // extra bit for carry
    logic signed [3:0] not_B, A_or_B, A_and_B, A_xor_B;
    logic signed [3:0] greater;
    logic signed [3:0] circ_left;

    always_comb begin
        not_B = ~B;
        A_or_B = A | B;
        A_and_B = A & B;
        A_xor_B = A ^ B;
        greater = (A > B) ? A : B;
        circ_left = {A[2:0], A[3]}; // 1-bit circular left shift

        CarryOut = 0;
        Overflow = 0;
        Result = 0;

        case (ALUcontrol)
            4'b0000: begin // Addition
                sum_result = A + B;
                Result = sum_result[3:0];
                CarryOut = sum_result[4];
                Overflow = (A[3] == B[3]) && (Result[3] != A[3]);
            end

            4'b0001: begin // Subtraction
                sum_result = A - B;
                Result = sum_result[3:0];
                CarryOut = sum_result[4];
                Overflow = (A[3] != B[3]) && (Result[3] != A[3]);
            end

            4'b0010: Result = -A;         // 2's Complement (Negation)
            4'b0011: Result = A + 1;      // Increment
            4'b0100: Result = A - 1;      // Decrement
            4'b0101: Result = circ_left;  // 1-bit Circular Left Shift
            4'b0110: Result = A_or_B;     // Bitwise OR
            4'b0111: Result = A_and_B;    // Bitwise AND
            4'b1000: Result = A_xor_B;    // Bitwise XOR
            4'b1001: Result = greater;    // Greater operand
            4'b1010: Result = A;          // Output A
            4'b1011: Result = B;          // Output B
            default: Result = 4'b0000;    // Default
        endcase
    end

endmodule
