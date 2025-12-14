`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 05:51:54 PM
// Design Name: 
// Module Name: siren_genereator_tb
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


module SirenGenerator_tb;

    logic clock;
    logic siren;
    logic speaker;

    SirenGenerator uut (
        .clock(clock),
        .siren(siren),
        .speaker(speaker)
    );

    // 50MHz clock generation
    initial begin
        clock = 0;
        forever #10 clock = ~clock; // 20ns period = 50MHz
    end

    // Stimulus
    initial begin
        siren = 0;
        #100;         // 100ns
        siren = 1;     // Turn on siren
        #10_000_000;   // Run for 10ms
        siren = 0;
        #1_000_000;
        $finish;
    end


endmodule

