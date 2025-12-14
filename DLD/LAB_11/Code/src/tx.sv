`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2025 05:39:48 PM
// Design Name: 
// Module Name: tx
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
module tx(
    input logic sys_clk,         
    input logic arst_n,        
    input logic en,          
    input logic [7:0] data_in,
    input logic baud_tick,   
    output logic Tx              
);

    // Oversampling counter
    logic [3:0] counter_16; 
    logic counter_16_ind; 

    // Baud clock counter
    logic [7:0] shift_reg;
    logic [2:0] counter_8; 
    logic counter_8_ind;


    // Counter for oversampling
    always_ff @(posedge sys_clk or negedge arst_n) begin
        if (!arst_n) begin
            counter_16 <= 0;
            counter_16_ind <= 0;
        end
        else if (en && baud_tick) begin
            if (current_state != IDLE) begin
                if (counter_16 == 15) begin
                    counter_16 <= 0;
                    counter_16_ind <= 1;     
                end else begin
                    counter_16 <= counter_16 + 1;
                    counter_16_ind <= 0;
                end
            end else begin
                counter_16 <= 0;
                counter_16_ind <= 0;
            end
        end else begin
            counter_16 <= counter_16;
            counter_16_ind <= 0;
        end
    end

    // Shift register and baud counter
    always_ff @(posedge sys_clk or negedge arst_n) begin
        if (!arst_n) begin
            counter_8 <= 0;
            shift_reg <= 0;
            counter_8_ind <= 0;
        end
        else if (en && baud_tick && counter_16 == 15) begin
            if (current_state == DATA) begin
                if (counter_8 == 7) begin
                    counter_8 <= 0;
                    counter_8_ind <= 1;
                    shift_reg <= shift_reg;
                end else begin
                    counter_8 <= counter_8 + 1;
                    counter_8_ind <= 0;
                    shift_reg <= {shift_reg[6:0], 1'b0};
                end
            end else begin
                counter_8 <= 0;
                counter_8_ind <= 0;
                shift_reg <= data_in;
            end
        end
    end


       //FSM 
    typedef enum logic[1:0] {
         IDLE,
         START,
         DATA,
         STOP
    }state;
    
    state current_state, next_state;
   


    // FSM: State Transition
    always_ff @(posedge sys_clk or negedge arst_n) begin
        if (!arst_n) begin
            current_state <= IDLE;
        end else begin 
                if(en) begin
            current_state <= next_state;
                end else begin
                current_state <= IDLE;
                end
        end 
    end

    always_comb begin
        next_state = current_state; // Default to current state
        case (current_state)
            IDLE: begin
                if (en && baud_tick == 1) next_state = START;
            end
            START: begin
                if (counter_16_ind) next_state = DATA;
            end
            DATA: begin
                if (counter_8_ind) next_state = STOP;
            end
            STOP: begin
                if (counter_16_ind) next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic (Moore FSM)
    always_comb begin
        case (current_state)
            IDLE:    Tx = 1'b1;
            START:   Tx = 1'b0;
            DATA:    Tx = shift_reg[7];
            STOP:    Tx = 1'b1;
            default: Tx = 1'b1;
        endcase
    end

endmodule
