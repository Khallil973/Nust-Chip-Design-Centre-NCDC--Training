`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2025 05:41:46 PM
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
module top_module (
    input logic sys_clk,          
    input logic arst_n,        
    input logic en,            
    input logic [1:0] baud_sel,
    input logic  Rx,           
    input logic [7:0] data_in, 
    output logic baud_tick, 
    output logic [7:0] data_out,
    output logic Tx     

);
    // Instantiate baud rate generator
    baud_div uut(
            .sys_clk(sys_clk),
            .baud_sel(baud_sel),
            .arst_n(arst_n),
            .en(en),
            .baud_tick(baud_tick)
    );
    

//TX
    tx tx_uut1 (
        .sys_clk(sys_clk),
        .arst_n(arst_n),
        .en(en),
        .baud_tick(baud_tick),
        .data_in(data_in),
        .Tx(Tx)
    );


//RX
    rx rx_uut2 (
        .sys_clk(sys_clk),
        .arst_n(arst_n),
        .en(en),
        .baud_tick(baud_tick),
        .Rx(Tx),             
        .data_out(data_out)
    );
//assign Rx = Tx;
endmodule


