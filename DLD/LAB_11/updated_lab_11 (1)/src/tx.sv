`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2025 12:22:55 AM
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

//module tx (
//    input  logic sys_clk,          // System clock
//    input  logic arst_n,           // Active-low reset
//    input  logic en,               // Module enable
//    input  logic [7:0] data_in,    // Parallel data input
//    input  logic bclk,             // Baud clock (1x)
//    output logic tx_ready,         // Ready to accept new data
//    output logic tx_busy,          // Transmission in progress
//    output logic Tx                // Serial output
//);

//    // FSM states
//    typedef enum logic [1:0] {
//        IDLE,
//        START,
//        DATA,
//        STOP
//    } state_t;
    
//    state_t current_state, next_state;

//    // Transmission registers
//    logic [2:0] bit_count;       // Counts 0-7 (8 data bits)
//    logic [7:0] shift_reg;       // 8-bit shift register
//    logic tx_out;                // Internal TX signal
    
//    // Baud clock edge detection
//    logic bclk_sync1, bclk_sync2;
//    logic bclk_prev;
//    logic bclk_rise;
    
//    // Triple synchronizer for bclk
//    always_ff @(posedge sys_clk or negedge arst_n) begin
//        if (!arst_n) begin
//            {bclk_sync2, bclk_sync1} <= 2'b00;
//            bclk_prev <= 0;
//        end else begin
//            bclk_sync1 <= bclk;
//            bclk_sync2 <= bclk_sync1;
//            bclk_prev <= bclk_sync2;
//        end
//    end
    
//    assign bclk_rise = ~bclk_prev && bclk_sync2;

//    // Main state register
//    always_ff @(posedge sys_clk or negedge arst_n) begin
//        if (!arst_n) begin
//            current_state <= IDLE;
//            bit_count <= 0;
//            shift_reg <= 8'b0;
//            tx_out <= 1'b1;      // Idle high
//        end else begin
//            current_state <= next_state;
            
//            // Load new data when starting
//            if (current_state == IDLE && next_state == START) begin
//                shift_reg <= data_in;
//                bit_count <= 0;
//            end
//            // Shift data on baud clock edges
//            else if (current_state == DATA && bclk_rise) begin
//                shift_reg <= {1'b0, shift_reg[7:1]};
//                bit_count <= bit_count + 1;
//            end
            
//            // Output generation
//            case (current_state)
//                IDLE:   tx_out <= 1'b1;
//                START:  tx_out <= 1'b0;
//                DATA:   tx_out <= shift_reg[0];
//                STOP:   tx_out <= 1'b1;
//            endcase
//        end
//    end

//    // Next state logic
//    always_comb begin
//        next_state = current_state;
//        tx_ready = 1'b0;
//        tx_busy = 1'b0;
        
//        case (current_state)
//            IDLE: begin
//                tx_ready = 1'b1;
//                if (en) next_state = START;
//            end
            
//            START: begin
//                tx_busy = 1'b1;
//                if (bclk_rise) next_state = DATA;
//            end
            
//            DATA: begin
//                tx_busy = 1'b1;
//                if (bit_count == 7 && bclk_rise) next_state = STOP;
//            end
            
//            STOP: begin
//                tx_busy = 1'b1;
//                if (bclk_rise) next_state = IDLE;
//            end
//        endcase
//    end
    
//    assign Tx = tx_out;

module tx (
    input  logic sys_clk,          // System clock
    input  logic arst_n,           // Active-low reset
    input  logic en,               // Module enable
    input  logic [7:0] data_in,    // Parallel data input
    input  logic bclk,             // Baud clock
    output logic tx_ready,         // Ready to accept new data
    output logic tx_busy,          // Transmission in progress
    output logic Tx                // Serial output
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE,
        START,
        DATA,
        STOP
    } state_t;
    
    state_t current_state, next_state;

    // Transmission registers
    logic [2:0] counter_8;       // Counts 0-7 (8 data bits)
    logic [7:0] shift_reg;       // 8-bit shift register
    logic tx_out;                // Internal TX signal
    
    // Control flags
    logic load_shift_reg;        // Load new data into shift register
    logic shift_enable;          // Enable shifting of data
    
    // Baud clock edge detection with improved synchronization
    logic bclk_sync1, bclk_sync2, bclk_prev;
    logic bclk_rise;
    
    // Triple synchronizer for bclk (better metastability protection)
    always_ff @(posedge sys_clk or negedge arst_n) begin
        if (!arst_n) begin
            {bclk_sync2, bclk_sync1} <= 2'b00;
            bclk_prev <= 0;
        end else begin
            bclk_sync1 <= bclk;
            bclk_sync2 <= bclk_sync1;
            bclk_prev <= bclk_sync2;
        end
    end
    
    assign bclk_rise = ~bclk_prev && bclk_sync2;
    // Inverted for proper edge detection

    // Main state register and data path
    always_ff @(posedge sys_clk or negedge arst_n) begin
        if (!arst_n) begin
            current_state <= IDLE;
            counter_8 <= 0;
            shift_reg <= 8'b0;
            tx_out <= 1'b1;      // Idle high
        end else begin
            current_state <= next_state;
            
            // Load new data when requested
            if (load_shift_reg) begin
                shift_reg <= data_in;
                counter_8 <= 0;
            end
            // Shift data on baud clock edges
            else if (shift_enable && bclk_rise) begin
                shift_reg <= {1'b0, shift_reg[7:1]};
                counter_8 <= counter_8 + 1;
            end
            
            // Output generation
            case (current_state)
                IDLE:   tx_out <= 1'b1;
                START:  tx_out <= 1'b0;  // Start bit
                DATA:   tx_out <= shift_reg[0];
                STOP:   tx_out <= 1'b1;  // Stop bit
            endcase
        end
    end

    // Next state logic (combinational)
    always_comb begin
        // Default values
        next_state = current_state;
        tx_ready = 1'b0;
        tx_busy = 1'b0;
        load_shift_reg = 1'b0;
        shift_enable = 1'b0;
        
        case (current_state)
            IDLE: begin
                tx_ready = 1'b1;
                if (en) begin
                    next_state = START;
                    load_shift_reg = 1'b1;
                end
            end
            
            START: begin
                tx_busy = 1'b1;
                if (bclk_rise) begin
                    next_state = DATA;
                    shift_enable = 1'b1;
                end
            end
            
            DATA: begin
                tx_busy = 1'b1;
                shift_enable = 1'b1;
                if (counter_8 == 7 && bclk_rise) begin
                    next_state = STOP;
                end
            end
            
            STOP: begin
                tx_busy = 1'b1;
                if (bclk_rise) begin
                    next_state = IDLE;
                end
            end
        endcase
    end
    
    assign Tx = tx_out;
endmodule

