`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 07:24:51 PM
// Design Name: 
// Module Name: top_module
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


module top_module (
    input  logic clk_25mhz,            // Main 25 MHz clock
    input  logic reset_button,         // Active high reset
    input  logic ignition_switch_raw,
    input  logic driver_door_raw,
    input  logic passenger_door_raw,
    input  logic brake_pedal_raw,
    input  logic hidden_switch_raw,
    input  logic reprogram_btn_raw,
    input  logic [1:0] time_param_selector,
    input  logic [1:0] time_interval_select,
    input  logic [3:0] time_value_input,
    
    output logic siren_output,
    output logic fuel_pump_power,
    output logic status_led,
    output logic status_indicator_led,
    
    // Debug Outputs
    output logic [3:0] debug_state,
    output logic [3:0] debug_countdown,
    output logic [3:0] debug_alarm_timer,
    output logic [3:0] debug_rearm_timer,
    output logic [1:0] debug_blink_counter,
    output logic       debug_clk2s
);

    logic ignition_switch, driver_door, passenger_door, brake_pedal, hidden_switch, reprogram_btn;
    logic [19:0] unused_count;
    logic unused_new1;

  // Dummy wires to avoid multiple drivers
logic [19:0] count_ign, count_drv, count_pass, count_brk, count_hid, count_rep;
logic        new_ign, new_drv, new_pass, new_brk, new_hid, new_rep;

	debounce db_ignition (.clk_in(clk_25mhz), .rst_in(reset_button), .noisy_in(ignition_switch_raw), 
                      .clean_out(ignition_switch), .count_out(count_ign), .new_1(new_ign));

	debounce db_driver   (.clk_in(clk_25mhz), .rst_in(reset_button), .noisy_in(driver_door_raw),     
                      .clean_out(driver_door), .count_out(count_drv), .new_1(new_drv));

	debounce db_pass     (.clk_in(clk_25mhz), .rst_in(reset_button), .noisy_in(passenger_door_raw),  
                      .clean_out(passenger_door), .count_out(count_pass), .new_1(new_pass));

	debounce db_brake    (.clk_in(clk_25mhz), .rst_in(reset_button), .noisy_in(brake_pedal_raw),     
                      .clean_out(brake_pedal), .count_out(count_brk), .new_1(new_brk));

	debounce db_hidden   (.clk_in(clk_25mhz), .rst_in(reset_button), .noisy_in(hidden_switch_raw),   
                      .clean_out(hidden_switch), .count_out(count_hid), .new_1(new_hid));

	debounce db_reprog   (.clk_in(clk_25mhz), .rst_in(reset_button), .noisy_in(reprogram_btn_raw),   
                      .clean_out(reprogram_btn), .count_out(count_rep), .new_1(new_rep));


    // Timer signals
    logic clk_1hz;
    logic timer_expired;
    logic [24:0] timer_count_out;

    // Timer for 1Hz and expiration
    timer counter(
        .clk_25(clk_25mhz),
        .rst(reset_button),
        .start_time(1'b0),        
        .time_value(4'd0),        
        .count_out(timer_count_out),
        .clk_1(clk_1hz),
        .expired(timer_expired)
    );

    // Time parameter logic
    logic [3:0] selected_time_value;
    
    time_parameter_reprogram time_config (
        .systemReset(reset_button),
        .reprogram(reprogram_btn),
        .interval(time_interval_select),
        .time_parameter_sel(time_param_selector),
        .time_value(time_value_input),
        .value(selected_time_value)
    );

    // Main FSM
    logic siren_status;
    
    Anti_theft_system dut1 (
        .clk(clk_25mhz),
        .clk_1hz(clk_1hz),
        .system_reset(reset_button),
        .driver_door(driver_door),
        .passenger_door(passenger_door),
        .ignition_switch(ignition_switch),
        .siren_status(siren_status),
        .status_indicator(status_indicator_led),
        .status(status_led),
        .debug_state(debug_state),
        .debug_countdown(debug_countdown),
        .debug_alarm_timer(debug_alarm_timer),
        .debug_rearm_timer(debug_rearm_timer),
        .debug_blink_counter(debug_blink_counter),
        .debug_clk2s(debug_clk2s)
    );

    // Fuel pump logic
    fuel_pump dut4(
        .clock(clk_25mhz),
        .ignition(ignition_switch),
        .brake(brake_pedal),
        .hidden(hidden_switch),
        .fuelPumpPower(fuel_pump_power)
    );

    // Siren Generator (audio tone toggle)
    SirenGenerator siren_gen (
        .clock(clk_25mhz),
        .siren(siren_status),
        .speaker(siren_output)
    );

endmodule
