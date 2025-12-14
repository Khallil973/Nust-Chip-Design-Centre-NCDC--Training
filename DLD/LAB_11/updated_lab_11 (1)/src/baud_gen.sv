`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2025 12:03:59 AM
// Design Name: 
// Module Name: baud_gen
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
module baud_div #(
    parameter CLK_FREQ = 100_000_000   // System clock frequency in Hz
)(
    input  logic sys_clk,              // System clock input
    input  logic arst_n,               // Active-low synchronous reset
    input logic [1:0] baud_sel,        // Baud rate selection
    output logic bclk,                 // Baud rate clock output (1x)
    output logic bclk_x8               // Oversampled baud clock output (8x)
);

    // Define supported baud rates
    localparam BAUD_9600  = 9600;
    localparam BAUD_19200 = 19200;
    localparam BAUD_38400 = 38400;
    localparam BAUD_76800 = 76800;

    // Current selected baud rate
    logic [31:0] selected_baud;
    
    // Baud divisor selection based on baud_sel input
    always_comb begin
        case (baud_sel)
            2'b00: selected_baud = BAUD_9600;
            2'b01: selected_baud = BAUD_19200;
            2'b10: selected_baud = BAUD_38400;
            2'b11: selected_baud = BAUD_76800;
            default: selected_baud = BAUD_9600;
        endcase
    end

    // Calculate divisors using your specified formulas
    logic [31:0] baud_divisor; // sample 1 bit for transmission to directly send the data per baud clk
    logic [31:0] baud_divisor_x8; // samples 8 bits for reciever 
    
    assign baud_divisor = (CLK_FREQ / selected_baud) / 2 - 1; //5207
    assign baud_divisor_x8 = (CLK_FREQ / (selected_baud * 8)) / 2 - 1;
    
    // Counters for baud clocks
    logic [31:0] counter_1x;
    logic [31:0] counter_8x;

    // 1x baud clock generation (for transmitter)
    always_ff @(posedge sys_clk) begin
        if (!arst_n) begin
            counter_1x <= 0;
            bclk <= 0;
        end else begin
            if (counter_1x == baud_divisor) begin
                counter_1x <= 0;
                bclk <= ~bclk;  // toggle baud clock for 50% duty cycle
            end else begin
                counter_1x <= counter_1x + 1;
            end
        end
    end

    // 8x baud clock generation (for receiver)
    always_ff @(posedge sys_clk) begin
        if (!arst_n) begin
            counter_8x <= 0;
            bclk_x8 <= 0;
        end else begin
            if (counter_8x >= baud_divisor_x8) begin
                counter_8x <= 0;
                bclk_x8 <= ~bclk_x8;  // toggle oversampled clock
            end else begin
                counter_8x <= counter_8x + 1;
            end
        end
    end

endmodule
        