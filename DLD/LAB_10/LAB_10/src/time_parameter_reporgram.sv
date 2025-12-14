`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 04:14:47 PM
// Design Name: 
// Module Name: time_parameter_reporgram
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


module time_parameter_reprogram(
    input logic systemReset, reprogram,
    input logic [1:0] interval, time_parameter_sel,
    input logic [3:0] time_value,
    output logic [3:0] value
);

    logic [3:0] T_ARM_DELAY = 4'b0110, T_DRIVER_DELAY = 4'b1000, T_PASSENGER_DELAY = 4'b1111, T_ALARM_ON = 4'b1010;

    always @(*) begin
        if (systemReset) begin
            T_ARM_DELAY = 4'b0110;
            T_DRIVER_DELAY = 4'b1000;
            T_PASSENGER_DELAY = 4'b1111;
            T_ALARM_ON = 4'b1010;
        end

        if (reprogram) begin
            case (time_parameter_sel)
                2'b00 : T_ARM_DELAY = time_value;
                2'b01 : T_DRIVER_DELAY = time_value;
                2'b10 : T_PASSENGER_DELAY = time_value;
                2'b11 : T_ALARM_ON = time_value;
            endcase
        end

        case (interval)
            2'b00 : value = T_ARM_DELAY;
            2'b01 : value = T_DRIVER_DELAY;
            2'b10 : value = T_PASSENGER_DELAY;
            2'b11 : value = T_ALARM_ON;
        endcase
    end

endmodule