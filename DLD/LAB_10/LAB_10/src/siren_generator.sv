`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 05:16:39 PM
// Design Name: 
// Module Name: siren_generator
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
module SirenGenerator (
    input  logic clock,
    input  logic siren,
    output logic speaker
);

    logic [17:0] counter;

    // Use fixed divider for testing: for 880 Hz square wave from 50 MHz clock
    // One toggle every 56,818 clocks ? 880 Hz full wave
    localparam int CLOCK_DIVIDER = 18'd28409;

    always_ff @(posedge clock) begin
        if (!siren) begin
            speaker <= 1'b0;
            counter <= CLOCK_DIVIDER;
        end else begin
            if (counter == 18'd0) begin
                counter <= CLOCK_DIVIDER;
                speaker <= ~speaker; // Toggle square wave
            end else begin
                counter <= counter - 18'd1;
            end
        end
    end

endmodule

