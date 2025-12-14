`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2025 05:43:44 PM
// Design Name: 
// Module Name: top_module_tb
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
module top_module_tb;
   
    logic sys_clk;
    logic arst_n;
    logic baud_tick;
//    logic Rx; 
    logic [1:0] baud_sel;
    logic [7:0] data_out;
    logic Tx;

/*
    rx uut (
        .clk (clk),
        .arst_n(arst_n),
        .baud_tick(baud_tick),
        .Rx(Rx),
        .en(en),
        .data_out(data_out)
    );
*/
    logic en;
    logic [7:0] data_in;


    top_module dut (
                    .sys_clk(sys_clk),
                    .arst_n(arst_n),
                    .en(en),
                    .baud_sel(baud_sel),
                  //  .Rx(Tx),
                    .data_in(data_in),
                    .baud_tick(baud_tick),
                    .data_out(data_out),
                    .Tx(Tx)
    );

/*
    tx tx_uut (
        .clk(clk),
        .arst_n(arst_n),
        .baud_tick(baud_tick),
        .data_in(data_in),
        .en(en),
        .Tx(Rx)
    );

   // Instantiate the baud rate generator
    baud_gen baud_gen_uut (
        .clk(clk),
        .arst_n(arst_n),
        .en(en),        // Always enabled for baud generation
        .baud_div(130),   // Configure baud rate divisor
        .baud_tick(baud_tick)
    );
*/


    initial sys_clk = 0;
    always #25 sys_clk = ~sys_clk;
/*
    // Test stimulus
    initial begin
        arst_n = 0; en = 0; data_in = 8'b0; // Initialize all signals
        #20 arst_n = 1;                     // Release asynchronous reset
        #100 en = 1;                        // Enable transmission
        data_in = 8'b1010_1010;             // Load first data byte
        #5000;                              // Wait for data to transmit
        en = 0;                             // Disable transmission
        #1000 data_in = 8'b1100_1100;       // Load second data byte
        en = 1;                             // Re-enable transmission
        #5000;                              // Wait for data to transmit
        en = 0;                             // Disable transmission
        #10000 $finish;                     // End simulation
    end
*/
initial begin
    arst_n = 0;
    en = 0;
    data_in = 8'b0;
    baud_sel = 2'b00;
    #50 arst_n = 1;
    #500 en = 1;
    #500 data_in = 8'b1011_0100;  // Send first byte
    #2000000 en = 0;              // Wait enough for TX/RX to finish
    #1000 data_in = 8'b1010_0101; // Prepare next byte
    #100 en = 1;
    #2000000 en = 0;
    #1000 $finish;
end

endmodule

