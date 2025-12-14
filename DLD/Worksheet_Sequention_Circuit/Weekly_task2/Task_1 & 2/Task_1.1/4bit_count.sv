`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/02/2025 11:29:58 PM
// Design Name: 
// Module Name: 4bit_count
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




//module bit_count_4 (
//    input logic clk,
//    input logic rst,
//    output logic [3:0] Q
//);

//    always_ff @(posedge clk) begin
//        if (rst) begin
//            Q <= 4'b0000;
//        end
//        else begin 
//            Q[0] <= (Q[1] & ~Q[0]) |
//                    (~Q[3] & Q[1] & ~Q[0]) |
//                    (Q[3] & Q[1] & ~Q[0]) |
//                    (Q[3] & Q[2] & ~Q[1] & ~Q[0]);

//            Q[1] <= Q[0] & Q[1];

//            Q[2] <= (Q[2] & Q[0]) |
//                    (Q[2] & Q[1] & ~Q[0]) |
//                    (~Q[2] & ~Q[1] & ~Q[0]);

//            Q[3] <= Q[3] ^ (~Q[1] & ~Q[0]); // or adjust as needed
//        end
//    end

//endmodule

//module down_counter_dff(
//    input logic clk, rst,
//    output logic [3:0] Q
//);

//    logic [3:0] D;

//    // D equations from logic above
//    always_comb begin
//        D[3] = Q[3] | (~Q[1] & ~Q[0]);
//        D[2] = (Q[2] & Q[0]) | (Q[2] & Q[1] & ~Q[0]) | (~Q[2] & ~Q[1] & ~Q[0]);
//        D[1] = (~Q[1] & ~Q[0]) | (Q[1] & Q[0]);
//        D[0] = (Q[1] & ~Q[0]) | (~Q[3] & ~Q[1] & ~Q[0]) | 
//               (~Q[3] & Q[1] & ~Q[0]) | (Q[3] & Q[2] & ~Q[1] & ~Q[0]);
//    end

//always_ff @(posedge clk or posedge rst) begin
//    if (rst)
//        Q <= 4'b1111;
//    else if (Q == 4'b0000)
//        Q <= 4'b1111;
//    else
//        Q <= D;
//end
//endmodule
module down_counter_dff (
    input  logic clk,
    input  logic rst,
    output logic [3:0] Q
);

//    logic [3:0] D;

//    input logic for DOWN counter
//    assign D[0] = ~Q[0];
//    assign D[1] = Q[1] ^ Q[0];
//    assign D[2] = Q[2] ^ (Q[1] | Q[0]);
//    assign D[3] = Q[3] ^ (Q[2] | (Q[1] & Q[0]));

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            Q <= 4'b1111;  // Start from 15
        else if (Q == 4'b0000)
            Q <= 4'b1111;  
        else
            Q <= Q - 1;    // Down count
    end
endmodule





