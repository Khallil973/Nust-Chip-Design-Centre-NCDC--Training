`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 11:35:34 AM
// Design Name: 
// Module Name: time_parameter
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


module time_parameter(
    input logic [1:0] interval,
    output logic [3:0] time_value
    );
    
    
    always_comb begin
    case(interval) 
        2'b00 : time_value = 4'b0110; //T_ARM_DELAY
        2'b01 : time_value = 4'b1000; //T_DRIVER_DELAY
        2'b10 : time_value = 4'b1111; //T_PASSENGER_DELAY
        2'b11 : time_value = 4'b1010; //T_ALARM_ON 
        default : time_value =  4'b0000; //Optional safe default
    endcase
    end
        
endmodule
