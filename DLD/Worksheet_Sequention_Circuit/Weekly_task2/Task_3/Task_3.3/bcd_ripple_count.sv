`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2025 10:38:26 PM
// Design Name: 
// Module Name: bcd_ripple_count
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


module BCD_Ripple_Counter (
    input  logic clk,
    input  logic rst,
    output logic [3:0] units,
    output logic [3:0] tens,
    output logic [3:0] hundreds
);

    // Counters for each BCD digit
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            units    <= 4'd0;
            tens     <= 4'd0;
            hundreds <= 4'd0;
        end else begin
            // Increment units
            if (units == 4'd9) begin
                units <= 4'd0;
                // Increment tens
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    // Increment hundreds
                    if (hundreds == 4'd9)
                        hundreds <= 4'd0;
                    else
                        hundreds <= hundreds + 1;
                end else begin
                    tens <= tens + 1;
                end
            end else begin
                units <= units + 1;
            end
        end
    end

endmodule

