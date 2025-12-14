`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2025 02:50:07 PM
// Design Name: 
// Module Name: Anti_theft_system
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
module Anti_theft_system(
    input logic clk,
    input logic clk_1hz,  // From 1 Hz generator
    input logic system_reset,
    input logic driver_door,
    input logic passenger_door,
    input logic ignition_switch,
    output logic siren_status,
    output logic status_indicator,
    output logic status,
    output logic [3:0] debug_state,
    output logic [3:0] debug_countdown,
    output logic [3:0] debug_alarm_timer,
    output logic [3:0] debug_rearm_timer,
    output logic [1:0] debug_blink_counter,
    output logic debug_clk2s
);

    // FSM States
    typedef enum logic [3:0] {
        ARMED,
        TRIGGERED,
        SIREN,
        SIREN_WAIT,
        DISARMED,
        WAIT_DOOR_OPEN,
        WAIT_DOOR_CLOSE,
        ARM_DELAY
    } state_t;

    state_t state, next_state;

    // Timers
    logic [3:0] countdown;
    logic [3:0] alarm_timer;
    logic [3:0] rearm_timer;

    // Blinking
    logic [1:0] blink_counter;
    logic clk2s;

    // 2-second clock from 1Hz
    always_ff @(posedge clk_1hz or posedge system_reset) begin
        if (system_reset)
            blink_counter <= 0;
        else
            blink_counter <= blink_counter + 1;
    end

    assign clk2s = blink_counter[1];

    // FSM Timer logic (on 1Hz clock)
    always_ff @(posedge clk_1hz or posedge system_reset) begin
        if (system_reset) begin
            countdown    <= 4'd3;
            alarm_timer  <= 4'd5;
            rearm_timer  <= 4'd5;
        end else begin
            // TRIGGERED countdown
            if (state == TRIGGERED && countdown != 0)
                countdown <= countdown - 1;
            else if (state != TRIGGERED)
                countdown <= 4'd3;

            // SIREN_WAIT timer
            if (state == SIREN_WAIT && alarm_timer != 0)
                alarm_timer <= alarm_timer - 1;
            else if (state != SIREN_WAIT)
                alarm_timer <= 4'd5;

            // ARM_DELAY timer
            if (state == ARM_DELAY && rearm_timer != 0)
                rearm_timer <= rearm_timer - 1;
            else if (state != ARM_DELAY)
                rearm_timer <= 4'd5;
        end
    end

    // State Register
    always_ff @(posedge clk or posedge system_reset) begin
        if (system_reset)
            state <= ARMED;
        else
            state <= next_state;
    end

    // Output and Next-State Logic
    always_comb begin
        // Defaults
        siren_status = 0;
        status_indicator = 0;
        status = 0;
        next_state = state;

        case (state)
            // === Mode 1: Armed ===
            ARMED: begin
                status = clk2s;  // Blinking indicator
                if (ignition_switch)
                    next_state = DISARMED;
                else if (driver_door || passenger_door)
                    next_state = TRIGGERED;
            end

            // === Mode 2: Triggered ===
            TRIGGERED: begin
                status_indicator = 1;
                if (ignition_switch)
                    next_state = DISARMED;
                else if (countdown == 0)
                    next_state = SIREN;
            end

            // === Mode 3: Siren ===
            SIREN: begin
                siren_status = 1;
                status_indicator = 1;
                if (ignition_switch)
                    next_state = DISARMED;
                else if (!driver_door && !passenger_door)
                    next_state = SIREN_WAIT;
            end

            // Wait T_ALARM_ON seconds after doors closed
            SIREN_WAIT: begin
                siren_status = 1;
                status_indicator = 1;
                if (ignition_switch)
                    next_state = DISARMED;
                else if (driver_door || passenger_door)
                    next_state = SIREN; // doors reopened
                else if (alarm_timer == 0)
                    next_state = ARMED;
            end

            // === Mode 4: Disarmed ===
            DISARMED: begin
                // Siren and indicator off
                if (!ignition_switch)
                    next_state = WAIT_DOOR_OPEN;
            end

            WAIT_DOOR_OPEN: begin
                if (driver_door)
                    next_state = WAIT_DOOR_CLOSE;
            end

            WAIT_DOOR_CLOSE: begin
                if (!driver_door)
                    next_state = ARM_DELAY;
            end

            ARM_DELAY: begin
                if (rearm_timer == 0)
                    next_state = ARMED;
            end

            default: next_state = ARMED;
        endcase
    end
    
    
    assign debug_state = state;
    assign debug_countdown = countdown;
    assign debug_alarm_timer = alarm_timer;
    assign debug_rearm_timer = rearm_timer;
    assign debug_blink_counter = blink_counter;
    assign debug_clk2s = clk2s;



endmodule
