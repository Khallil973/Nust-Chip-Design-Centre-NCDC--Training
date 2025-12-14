`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2025 09:22:27 PM
// Design Name: 
// Module Name: ripple_count
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

module jk_flipflop (
    input logic clk,
    input logic rst,
    input logic enable,     // Enable toggling
    output logic Q
);
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            Q <= 0;
        else if (enable)
            Q <= ~Q;
    end
endmodule


module up_down_counter_4bit (
    input logic clk,
    input logic rst,
    input logic M,             // 1 = UP, 0 = DOWN
    output logic [3:0] Q
);

    logic [3:0] enable;

    // Toggle enable logic for each stage
    assign enable[0] = 1; // LSB always toggles

    assign enable[1] = (M) ? (Q[0])         : (~Q[0]);
    assign enable[2] = (M) ? (Q[1] & Q[0])  : (~Q[1] & ~Q[0]);
    assign enable[3] = (M) ? (Q[2] & Q[1] & Q[0]) : (~Q[2] & ~Q[1] & ~Q[0]);

    // Instantiate flip-flops
    jk_flipflop ff0 (.clk(clk), .rst(rst), .enable(enable[0]), .Q(Q[0]));
    jk_flipflop ff1 (.clk(clk), .rst(rst), .enable(enable[1]), .Q(Q[1]));
    jk_flipflop ff2 (.clk(clk), .rst(rst), .enable(enable[2]), .Q(Q[2]));
    jk_flipflop ff3 (.clk(clk), .rst(rst), .enable(enable[3]), .Q(Q[3]));

endmodule

