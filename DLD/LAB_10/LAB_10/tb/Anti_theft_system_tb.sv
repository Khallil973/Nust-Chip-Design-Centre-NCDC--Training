`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2025 05:11:33 PM
// Design Name: 
// Module Name: Anti_theft_system_tb
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



module Anti_theft_system_tb();

    logic clk;
    logic clk_1hz;
    logic system_reset;
    logic driver_door;
    logic passenger_door;
    logic ignition_switch;

    logic siren_status;
    logic status_indicator;
    logic status;
    logic [3:0] debug_state;
    logic [3:0] debug_countdown;
    logic [3:0] debug_alarm_timer;
    logic [3:0] debug_rearm_timer;
     logic [1:0] debug_blink_counter;
    logic debug_clk2s;

    // Instantiate the DUT
    Anti_theft_system dut (
        .clk(clk),
        .clk_1hz(clk_1hz),
        .system_reset(system_reset),
        .driver_door(driver_door),
        .passenger_door(passenger_door),
        .ignition_switch(ignition_switch),
        .siren_status(siren_status),
        .status_indicator(status_indicator),
        .status(status),
        .debug_state(debug_state),
        .debug_countdown(debug_countdown),
        .debug_alarm_timer(debug_alarm_timer),
        .debug_rearm_timer(debug_rearm_timer),
        .debug_blink_counter(debug_blink_counter),
        .debug_clk2s(debug_clk2s)
    );

    // 100MHz Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // 1Hz Clock
    initial begin
        clk_1hz = 0;
        forever begin
            #5 clk_1hz = ~clk_1hz;
        end
    end

    // Test sequence
    initial begin

        // Reset system
        system_reset = 1;
        driver_door = 0;
        passenger_door = 0;
        ignition_switch = 0;
        #20 system_reset = 0;


        // --- Test 1: System starts in ARMED ---
        #20;

        // --- Test 2: Door opens, countdown starts (TRIGGERED) ---
        driver_door = 1;

        #60; // Wait 3 x 1Hz cycles = 3s countdown (assuming default countdown is 3)

        // --- Test 3: Ignition not on, siren should start (SIREN state) ---
        driver_door = 0;
        #20;

        // --- Test 4: Turn ignition ON ? go to DISARMED ---
        ignition_switch = 1;
        #20;

        // --- Test 5: Ignition OFF ? open/close door ? ARM_DELAY ? ARMED ---
        ignition_switch = 0;
        driver_door = 1;
        #20;
        driver_door = 0;
        #100; // Wait enough for ARM_DELAY to finish

        // End simulation
        #50;
        $display("Simulation completed.");
        $finish;
    end

endmodule
