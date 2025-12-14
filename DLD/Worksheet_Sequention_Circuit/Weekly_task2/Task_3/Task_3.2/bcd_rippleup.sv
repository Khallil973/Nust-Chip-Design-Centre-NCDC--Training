`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2025 10:22:38 PM
// Design Name: 
// Module Name: bcd_rippleup
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
module bcd_ripple_up_counter (
    input  logic clk,
    input  logic rst,        // Active high asynchronous reset
    output logic [3:0] Q     // 4-bit BCD output
);

    logic [3:0] T;

    // Toggle inputs logic
    assign T[0] = 1'b1;                           // T0
    assign T[1] = Q[0];                           // T1
    assign T[2] = Q[1] & Q[0];                    // T2
    assign T[3] = Q[2] & Q[1] & Q[0];             // T3

    // Detect BCD reset condition (when Q == 4'b1010 or decimal 10)
    logic reset_bcd = (Q == 4'b1010);

    // Main always block using T-flip-flop behavior
    always_ff @(posedge clk or posedge rst or posedge reset_bcd) begin
        if (rst || reset_bcd)
            Q <= 4'b0000;
        else begin
            if (T[0]) Q[0] <= ~Q[0];
            if (T[1]) Q[1] <= ~Q[1];
            if (T[2]) Q[2] <= ~Q[2];
            if (T[3]) Q[3] <= ~Q[3];
        end
    end

endmodule

