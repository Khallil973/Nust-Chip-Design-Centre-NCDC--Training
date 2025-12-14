`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2025 12:29:38 AM
// Design Name: 
// Module Name: top_module
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
module top_module #(
    parameter CLK_FREQ = 100_000_000  // System clock frequency in Hz
)(
    input  logic clk,            // System clock
    input  logic reset_n,        // Active-low reset
    input  logic [1:0] baud_sel, // Baud rate selection
    // Transmitter interface
    input  logic tx_en,          // Transmit enable
    input  logic [7:0] tx_data,  // Data to transmit
    output logic tx_ready,       // Transmitter ready
    output logic tx_busy,        // Transmitter busy
    output logic Tx,             // Serial transmit output
    // Receiver interface
    input  logic Rx,             // Serial receive input
    output logic [7:0] rx_data,  // Received data
    output logic rx_valid,       // Received data valid
    output logic rx_busy         // Receiver busy
);

    // Baud rate generator signals
    logic bclk;     // 1x baud clock (for transmitter)
    logic bclk_x8;  // 8x baud clock (for receiver)

    // Instantiate baud rate generator
    baud_div #(
        .CLK_FREQ(CLK_FREQ)
    ) baud_gen (
        .sys_clk(clk),
        .arst_n(reset_n),
        .baud_sel(baud_sel),
        .bclk(bclk),
        .bclk_x8(bclk_x8)
    );

    // Instantiate transmitter
    tx uart_tx (
        .sys_clk(clk),
        .arst_n(reset_n),
        .en(tx_en),
        .data_in(tx_data),
        .bclk(bclk),
        .tx_ready(tx_ready),
        .tx_busy(tx_busy),
        .Tx(Tx)
    );

// Instantiate receiver
    rx uart_rx (
        .sys_clk(clk),
        .arst_n(reset_n),
        .Rx(Rx),
        .bclk_x8(bclk_x8),
        .data_out(rx_data),
        .data_valid(rx_valid),
        .rx_busy(rx_busy)
    );
endmodule