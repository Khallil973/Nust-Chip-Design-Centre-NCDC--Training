`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2025 11:37:46 PM
// Design Name: 
// Module Name: dec_bcd
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
module dec_bcd(
    input  logic [8:0] A,   
    output logic [3:0] O    // Active-low output
);

    always_comb begin
        // Default output (all HIGH = no input active which represents BCD 0 in active-low)
        O = 4'b1111;
        if (!A[8]) begin
            O = 4'b1110;   
        end 
            else if (!A[7]) begin
            O = 4'b1101;   
        end 
            else if (!A[6]) begin
            O = 4'b1100; 
        end     
            else if (!A[5]) begin
            O = 4'b1011;   
        end 
            else if (!A[4]) begin
            O = 4'b1010;   
        end 
            else if (!A[3]) begin
            O = 4'b1001;   
        end 
            else if (!A[2]) begin
            O = 4'b1000;  
        end 
            else if (!A[1]) begin
            O = 4'b0111;  
        end 
            else if (!A[0]) begin
            O = 4'b0110; 
        end
    end

endmodule



