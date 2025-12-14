`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 04:40:34 PM
// Design Name: 
// Module Name: fuel_pump_tb
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

module fuel_pump_tb();

    logic clock = 0;
    logic ignition = 0;
    logic brake = 0;
    logic hidden = 0;
    logic fuelPumpPower;

    // Instantiate the DUT
    fuel_pump dut (
        .clock(clock),
        .ignition(ignition),
        .brake(brake),
        .hidden(hidden),
        .fuelPumpPower(fuelPumpPower)
    );

    // Generate a clock: 10ns period
    always #5 clock = ~clock;

    initial begin


        #10;

        // Case 1: Turn ignition ON only - pump should stay OFF
        ignition = 1;
        #10;

        // Case 2: Press brake only
        brake = 1;
        #10;

        // Case 3: Press hidden switch too - combo active, pump should turn ON
        hidden = 1;
        #10;

        // Case 4: Release brake & hidden, but keep ignition - pump stays ON (latched)
        brake = 0;
        hidden = 0;
        #20;

        // Case 5: Turn ignition OFF - pump turns OFF
        ignition = 0;
        #10;

        // Case 6: Turn ignition ON again, without combo - pump stays OFF
        ignition = 1;
        #10;

        // Case 7: Activate combo again
        brake = 1;
        hidden = 1;
        #10;

        // Final cleanup
        #20;
        $finish;
    end

endmodule

