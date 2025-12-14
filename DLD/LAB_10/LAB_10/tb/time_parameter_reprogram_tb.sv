`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 04:15:09 PM
// Design Name: 
// Module Name: time_parameter_reprogram_tb
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


module time_parameter_reprogram_tb();

    logic systemReset, reprogram;
    logic [1:0] interval, time_parameter_sel;
    logic [3:0] time_value;
    logic [3:0] value;

    time_parameter_reprogram dut (
        .systemReset(systemReset), 
        .reprogram(reprogram), 
        .interval(interval), 
        .time_parameter_sel(time_parameter_sel), 
        .time_value(time_value), 
        .value(value)
    );

    initial begin
        systemReset = 1'b1;
        #10 systemReset = 1'b0;
        reprogram = 1'b0;
        interval = 2'b00;
        time_parameter_sel = 2'b00; 
        time_value = 4'b0000; 
        #10 interval = 2'b01;
        #10 interval = 2'b10;
        #10 interval = 2'b11;
        #10 interval = 2'b00; 
        time_parameter_sel = 2'b00;
        time_value = 4'b0111;
        #10 reprogram = 1'b1;
        #10 reprogram = 1'b0;
        time_parameter_sel = 2'b01;
        time_value = 4'b0100;
        #10 reprogram = 1'b1;
        #10 reprogram = 1'b0;
        time_parameter_sel = 2'b10;
        time_value = 4'b1110;
        #10 reprogram = 1'b1;
        #10 reprogram = 1'b0;
        time_parameter_sel = 2'b11;
        time_value = 4'b1001;
        #10 reprogram = 1'b1;
        #10 reprogram = 1'b0;
        time_parameter_sel = 2'b00; 
        time_value = 4'b0000; 
        interval = 2'b00;
        #10 interval = 2'b01;
        #10 interval = 2'b10;
        #10 interval = 2'b11;
    end

    initial #200 $finish;

endmodule
