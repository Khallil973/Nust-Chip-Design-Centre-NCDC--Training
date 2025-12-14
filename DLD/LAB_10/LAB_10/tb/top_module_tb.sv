`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 07:26:18 PM
// Design Name: 
// Module Name: top_module_tb
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
module top_module_tb();
    logic clk_25mhz;
    logic reset_button;
    logic ignition_switch_raw, driver_door_raw, passenger_door_raw;
    logic brake_pedal_raw, hidden_switch_raw;
    logic reprogram_btn_raw;
    logic [1:0] time_param_selector;
    logic [1:0] time_interval_select;
    logic [3:0] time_value_input;

    wire siren_output;
    wire fuel_pump_power;
    wire status_led;
    wire status_indicator_led;

    wire [3:0] debug_state, debug_countdown, debug_alarm_timer, debug_rearm_timer;
    wire [1:0] debug_blink_counter;
    wire       debug_clk2s;

    top_module uut (
        .clk_25mhz(clk_25mhz),
        .reset_button(reset_button),
        .ignition_switch_raw(ignition_switch_raw),
        .driver_door_raw(driver_door_raw),
        .passenger_door_raw(passenger_door_raw),
        .brake_pedal_raw(brake_pedal_raw),
        .hidden_switch_raw(hidden_switch_raw),
        .reprogram_btn_raw(reprogram_btn_raw),
        .time_param_selector(time_param_selector),
        .time_interval_select(time_interval_select),
        .time_value_input(time_value_input),
        .siren_output(siren_output),
        .fuel_pump_power(fuel_pump_power),
        .status_led(status_led),
        .status_indicator_led(status_indicator_led),
        .debug_state(debug_state),
        .debug_countdown(debug_countdown),
        .debug_alarm_timer(debug_alarm_timer),
        .debug_rearm_timer(debug_rearm_timer),
        .debug_blink_counter(debug_blink_counter),
        .debug_clk2s(debug_clk2s)
    );

    initial clk_25mhz = 0;
    always #5 clk_25mhz = ~clk_25mhz; // 100 MHz

    // Tasks
    task reset();
        reset_button = 1;
        #50;
        reset_button = 0;
    endtask

    task reprogram(input [1:0] sel, input [3:0] value);
        begin
            time_param_selector = sel;
            time_interval_select = sel;
            time_value_input = value;
            reprogram_btn_raw = 1;
            #100;
            reprogram_btn_raw = 0;
        end
    endtask

    initial begin
        // Initialize inputs
        reset_button = 0;
        ignition_switch_raw = 0;
        driver_door_raw = 0;
        passenger_door_raw = 0;
        brake_pedal_raw = 0;
        hidden_switch_raw = 0;
        reprogram_btn_raw = 0;
        time_param_selector = 0;
        time_interval_select = 0;
        time_value_input = 0;

        // === 1. Reset system ===
        reset();
        #500;

        // === 2. Reprogram all time parameters to small values ===
        reprogram(2'b00, 4'd2); // T_ARM_DELAY
        reprogram(2'b01, 4'd3); // T_DRIVER_DELAY
        reprogram(2'b10, 4'd4); // T_PASSENGER_DELAY
        reprogram(2'b11, 4'd3); // T_ALARM_ON
        #500;

        // === 3. Arm system via driver door ===
driver_door_raw = 1; #15000;
driver_door_raw = 0; #15000;


        // === 4. Trigger alarm via driver door ===
        driver_door_raw = 1; #10000;  // Stay open to allow countdown to expire
        driver_door_raw = 0; #5000;

        // === 5. Disarm via ignition before siren ===
        reset(); #1000;
        driver_door_raw = 1; #100;
        driver_door_raw = 0; #5000;
        driver_door_raw = 1;
        ignition_switch_raw = 1; #500;
        driver_door_raw = 0;
        ignition_switch_raw = 0; #1000;

        // === 6. Arm via passenger door (tests longer countdown) ===
        reset(); #1000;
        passenger_door_raw = 1; #100;
        driver_door_raw = 1; #100;
        passenger_door_raw = 0;
        driver_door_raw = 0;
        #10000;

        // === 7. Test fuel pump unlock logic ===
        ignition_switch_raw = 1; #100;
brake_pedal_raw = 1; hidden_switch_raw = 1; #15000;
brake_pedal_raw = 0; hidden_switch_raw = 0; #15000;


        // === End ===
  
        $finish;
    end

endmodule
