`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 04:40:01 PM
// Design Name: 
// Module Name: fuel_pump
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



module fuel_pump(
    input  logic clock,
    input  logic ignition,
    input  logic brake,
    input  logic hidden,
    output logic fuelPumpPower
);

    logic fuelPumpPowerReg;

    // Latch previous value on rising clock edge
    always_ff @(posedge clock) begin
        fuelPumpPowerReg <= fuelPumpPower;
    end

    // Combinational logic for current output
    always_comb begin
        fuelPumpPower = (ignition && fuelPumpPowerReg) || (ignition && brake && hidden);
    end

endmodule
