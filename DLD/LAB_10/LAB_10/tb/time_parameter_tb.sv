`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 11:36:02 AM
// Design Name: 
// Module Name: time_parameter_tb
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

module time_parmeter_tb();

    logic [1:0] interval;
    logic [3:0] time_value;

    time_parameter dut(
        .interval(interval),
        .time_value(time_value)
    );

    initial begin
        interval = 2'b00;
        #10 interval = 2'b01;
        #10 interval = 2'b10;
        #10 interval = 2'b11;
    end

    initial #50 $finish;

endmodule