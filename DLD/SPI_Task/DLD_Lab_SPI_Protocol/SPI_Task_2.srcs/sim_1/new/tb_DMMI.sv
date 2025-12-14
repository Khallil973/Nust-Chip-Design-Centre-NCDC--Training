`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2025 07:45:22 PM
// Design Name: 
// Module Name: tb_DMMI
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


module tb_DMMI;

    // Parameters
    localparam NUM_BEAMS       = 121;
    localparam PARAMS_PER_BEAM = 12;

    // DUT I/O
    logic clk;
    logic rst_n;
    logic [6:0] beam_index;
    logic mode;
    logic data_request;
    logic [7:0] spi_data;
    logic [15:0] spi_addr;
    logic data_valid; 

    // Instantiate DUT
    DMMI dut (
        .clk(clk),
        .rst_n(rst_n),
        .beam_index(beam_index),
        .mode(mode),
        .data_request(data_request),
        .spi_addr(spi_addr),
        .spi_data(spi_data),
        .data_valid(data_valid)
    );

    // Clock generation (50 MHz example)
    always #10 clk = ~clk;

    // Scoreboard
    int pass_count = 0;
    int fail_count = 0;

    // Task to request and check a byte
    task automatic request_and_check(
        input [6:0]  beam,
        input        mode_tx1,
        input [3:0]  param_idx
    );
        logic [7:0] expected;
        begin
            beam_index   = beam;
            mode      = mode_tx1;
            data_request = 1;
            @(posedge clk);
            data_request = 0;
            @(posedge clk);
            if (data_valid) begin
                // Calculate expected value
                if (mode)
                    expected = (8'h80 + beam*PARAMS_PER_BEAM + param_idx) & 8'hFF; // TX dummy pattern
                else
                    expected = (8'h10 + beam*PARAMS_PER_BEAM + param_idx) & 8'hFF; // RX dummy pattern

                if (spi_data === expected) begin
                    pass_count++;
                end else begin
                    $display("FAIL: Mode=%0d Beam=%0d Param=%0d Got=0x%0h Exp=0x%0h",
                             mode, beam, param_idx, spi_data, expected);
                    fail_count++;
                end
            end
        end
    endtask

    // Test sequence
    initial begin
        clk       = 0;
        rst_n   = 0;
        data_request = 0;
        beam_index = 0;
        mode    = 0;

        // Reset sequence
        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(2) @(posedge clk);

        // Loop through all beams in RX and TX
        for (int m = 0; m < 2; m++) begin
            for (int b = 0; b < NUM_BEAMS; b++) begin
                for (int p = 0; p < PARAMS_PER_BEAM; p++) begin
                    request_and_check(b, m, p);
                end
            end
        end

        // Report results
        $display("==================================");
        $display("TEST COMPLETE: Pass=%0d Fail=%0d", pass_count, fail_count);
        $display("==================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED ?");
        else
            $display("SOME TESTS FAILED ?");

        $stop;
    end

endmodule
