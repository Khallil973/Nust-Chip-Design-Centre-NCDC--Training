`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2025 05:39:49 PM
// Design Name: 
// Module Name: master_tb
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
module master_tb();

    // Test Configuration
    parameter TEST_MODE = 0;  // 0,1,2,3 for different SPI modes
    
    // DUT Parameters
    localparam CPOL = (TEST_MODE == 0 || TEST_MODE == 1) ? 0 : 1;
    localparam CPHA = (TEST_MODE == 0 || TEST_MODE == 2) ? 0 : 1;

    // Inputs
    reg clk;
    reg rst;
    reg en;
    reg [7:0] ext_command_in;
    reg [15:0] ext_address_in;
    reg miso;

    // Outputs
    wire cs;
    wire sck;
    wire mosi;
    wire [7:0] ext_data_out;

    // Instantiate DUT
    master #(
        .CPOL(CPOL),
        .CPHA(CPHA)
    ) uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .cs(cs),
        .sck(sck),
        .ext_command_in(ext_command_in),
        .ext_address_in(ext_address_in),
        .mosi(mosi),
        .miso(miso),
        .ext_data_out(ext_data_out)
    );

    // Clock generation (100 MHz)
    always #5 clk = ~clk;

    // Task to send MISO data with proper timing
    task send_miso_data;
        input [7:0] data;
        integer i;
        begin
            // Wait until read phase starts
            wait(uut.bit_count == 16 && 
                ((CPHA == 0 && sck == CPOL) || 
                 (CPHA == 1 && sck == !CPOL)));
            
            // Send bits with proper timing
            for (i = 0; i < 8; i = i + 1) begin
                if (CPHA == 0) @(negedge sck);
                else @(posedge sck);
                miso = data[i];
            end
        end
    endtask

    // Test procedure
    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        en = 0;
        ext_command_in = 0;
        ext_address_in = 0;
        miso = 0;

        $display("\nTesting SPI Mode %0d (CPOL=%0d, CPHA=%0d)", TEST_MODE, CPOL, CPHA);
        
        // Reset
        #20 rst = 0;
        #10;

        // Test Case 1
        ext_command_in = 8'hA5;
        ext_address_in = 16'h1234;
        fork
            send_miso_data(8'h69);
        join_none
        en = 1; #10; en = 0;
        wait(cs == 1'b1);
        #50;
        if (ext_data_out !== 8'h69)
            $display("Error: Expected 8'h69, got %h", ext_data_out);
        else
            $display("Pass: Received 0x%h", ext_data_out);

        // Test Case 2
        ext_command_in = 8'hC3;
        ext_address_in = 16'hABCD;
        fork
            send_miso_data(8'h5A);
        join_none
        en = 1; #10; en = 0;
        wait(cs == 1'b1);
        #50;
        if (ext_data_out !== 8'h5A)
            $display("Error: Expected 8'h5A, got %h", ext_data_out);
        else
            $display("Pass: Received 0x%h", ext_data_out);

        #100;
        $display("\nTest complete for Mode %0d", TEST_MODE);
        $finish;
    end


endmodule