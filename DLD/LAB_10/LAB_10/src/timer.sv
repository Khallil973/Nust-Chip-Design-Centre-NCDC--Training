`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 11:53:12 AM
// Design Name: 
// Module Name: timer
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
module timer (
    input  logic        clk_25,       // 25 MHz clock
    input  logic        rst,          // Reset signal
    input  logic        start_time,   // Start countdown
    input  logic [3:0]  time_value,   // Countdown start value
    output logic [24:0] count_out,    // Debug: divider counter output
    output logic        clk_1,        // 1 Hz pulse
    output logic        expired       // Goes high when timer reaches 0
);

    // Divider to generate 1Hz pulse from 25MHz
    logic [24:0] clk_count = 25'd0;
    logic clk_1hz_enable = 1'b0;

    // Countdown timer
    logic [3:0] countdown = 4'd0;
    logic count_working = 1'b0;

    // Frequency Divider (resets on start_time)
    always_ff @(posedge clk_25 or posedge rst) begin
        if (rst) begin
            clk_count <= 25'd0;
            clk_1hz_enable <= 1'b0;
        end else if (clk_count == 25_000_000 - 1) begin
            clk_count <= 25'd0;
            clk_1hz_enable <= 1'b1; // Pulse for one cycle
        end else begin
            clk_count <= clk_count + 1;
            clk_1hz_enable <= 1'b0;
        end
    end

    assign count_out = clk_count;
    assign clk_1 = clk_1hz_enable;

    // Countdown Logic
    always_ff @(posedge clk_25 or posedge rst) begin
        if (rst) begin
            countdown <= 4'd0;
            expired <= 1'b0;
            count_working <= 1'b0;
        end else if (start_time) begin
            countdown <= time_value;
            expired <= 1'b0;
            count_working <= 1'b1;
        end else if (clk_1hz_enable && count_working) begin
            if (countdown > 0) begin
                countdown <= countdown - 1;
                expired <= 1'b0;
            end else begin
                expired <= 1'b1;
                count_working <= 1'b0;
            end
        end
    end

endmodule
