`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// 
// Create Date: 08/08/2025 12:23:35 AM// Engineer: 

// Design Name: 
// Module Name: rx
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

module rx (
    input  logic sys_clk,          // System clock
    input  logic arst_n,           // Active-low reset
    input  logic Rx,               // Serial input
    input  logic bclk_x8,          // Oversampled baud clock (8x)
    output logic [7:0] data_out,   // Parallel data output
    output logic data_valid,       // Data valid strobe
    output logic rx_busy           // Reception in progress
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE,
        START,
        DATA,
        STOP
    } state_t;
    
    state_t current_state, next_state;

    // Reception registers
    logic [2:0] bit_count;       // Counts 0-7 (8 data bits)
    logic [7:0] shift_reg;       // 8-bit shift register
    logic [2:0] sample_count;    // Oversampling counter (0-7)
    logic rx_sync1, rx_sync2;    // Synchronizer for Rx input
    
    // Baud clock edge detection
    logic bclk_x8_sync1, bclk_x8_sync2;
    logic bclk_x8_prev;
    logic bclk_x8_rise;
    
    // Triple synchronizer for bclk_x8
    always_ff @(posedge sys_clk or negedge arst_n) begin
        if (!arst_n) begin
            {bclk_x8_sync2, bclk_x8_sync1} <= 2'b00;
            bclk_x8_prev <= 0;
        end else begin
            bclk_x8_sync1 <= bclk_x8;
            bclk_x8_sync2 <= bclk_x8_sync1;
            bclk_x8_prev <= bclk_x8_sync2;
        end
    end
    
    assign bclk_x8_rise = ~bclk_x8_prev && bclk_x8_sync2;

    // Rx input synchronizer
    always_ff @(posedge sys_clk or negedge arst_n) begin
        if (!arst_n) begin
            rx_sync1 <= 1'b1;
            rx_sync2 <= 1'b1;
        end else begin
            rx_sync1 <= Rx;
            rx_sync2 <= rx_sync1;
        end
    end

    // Main state register
    always_ff @(posedge sys_clk or negedge arst_n) begin
        if (!arst_n) begin
            current_state <= IDLE;
            bit_count <= 0;
            shift_reg <= 8'b0;
            sample_count <= 0;
            data_out <= 8'b0;
            data_valid <= 1'b0;
        end else begin
            current_state <= next_state;
            data_valid <= 1'b0;
            
            if (bclk_x8_rise) begin
                case (current_state)
                    IDLE: begin
                        sample_count <= 0;
                    end
                    
                    START: begin
                        if (sample_count == 3'b111) begin
                            sample_count <= 0;
                        end else begin
                            sample_count <= sample_count + 1;
                        end
                    end
                    
                    DATA: begin
                        if (sample_count == 3'b111) begin
                            shift_reg <= {rx_sync2, shift_reg[7:1]};
                            bit_count <= bit_count + 1;
                            sample_count <= 0;
                        end else begin
                            sample_count <= sample_count + 1;
                        end
                    end
                    
                    STOP: begin
                        if (sample_count == 3'b111) begin
                            data_out <= shift_reg;
                            data_valid <= 1'b1;
                        end
                        sample_count <= sample_count + 1;
                    end
                endcase
            end
        end
    end

    // Next state logic
    always_comb begin
        next_state = current_state;
        rx_busy = 1'b0;
        
        case (current_state)
            IDLE: begin
                if (rx_sync2 == 1'b0) next_state = START;
            end
            
            START: begin
                rx_busy = 1'b1;
                if (bclk_x8_rise && sample_count == 3'b111) begin
                    next_state = DATA;
                end
            end
            
            DATA: begin
                rx_busy = 1'b1;
                if (bit_count == 7 && bclk_x8_rise && sample_count == 3'b111) begin
                    next_state = STOP;
                end
            end
            
            STOP: begin
                rx_busy = 1'b1;
                if (bclk_x8_rise && sample_count == 3'b111) begin
                    next_state = IDLE;
                end
            end
        endcase
    end
endmodule