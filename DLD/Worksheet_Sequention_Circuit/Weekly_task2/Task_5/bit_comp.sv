`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2025 12:22:20 PM
// Design Name: 
// Module Name: bit_comp
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


module bit_comp(
    input logic clk,
    input logic rst,
    input logic A,
    input logic sel,
    output logic out
    );
    
    logic bit_1;
        
    
    always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        bit_1 <= 0;
        out <= 0;
    end
    else begin
        if(sel == 0) begin
            out <= A;
            bit_1 <= 0;
        end
        else if(!bit_1) begin
                if(A == 1) begin
                    out <= 1;
                    bit_1 <= 1;
                end 
                else begin
                    out <= 0;
                end
        end else begin
                out <= ~A;
                end
        end
    end

 
endmodule
