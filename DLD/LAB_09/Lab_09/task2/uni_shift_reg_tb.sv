`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2025 08:01:18 PM
// Design Name: 
// Module Name: uni_shift_reg_tb
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




module uni_shift_reg_tb();

    logic clk, rst_n;
    logic [1:0] ctrl;
    logic [3:0] parallel_in;
    logic serial_rs, serial_ls;
    logic [3:0] s_out;

    uni_shif_reg uut (
        .clk(clk),
        .rst_n(rst_n),
        .parallel_in(parallel_in),
        .serial_rs(serial_rs),
        .serial_ls(serial_ls),
        .ctrl(ctrl),
        .s_out(s_out)
    );

    always #5 clk = ~clk;

 initial begin
    clk = 0;
    rst_n = 0;
    ctrl = 2'b00;
    parallel_in = 4'b0000;
    serial_rs = 1'b0;
    serial_ls  = 1'b0;

    #10 rst_n = 1; // Release reset

    // Load parallel data
 
    @(posedge clk);
    parallel_in = 4'b1011;
    ctrl = 2'b11;
    @(posedge clk);

    // Hold
    ctrl = 2'b00;
    @(posedge clk);

    // Shift Right with serial_in = 1
    serial_rs = 1'b1;
    ctrl = 2'b01;
    @(posedge clk);

    // Shift Left with serial_in = 0
    serial_ls = 1'b0;
    ctrl = 2'b10;
    @(posedge clk);
    
    $finish;
end

endmodule
