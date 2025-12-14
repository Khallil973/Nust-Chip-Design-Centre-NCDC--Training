`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2025 08:37:30 PM
// Design Name: 
// Module Name: SDAC
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

module SDAC #(
    // ADAR1000 readback register addresses (change if memory map differs)
    parameter logic [15:0] ADDR_TEMP = 16'h0033, // ADAR1000 register 0x33 is ADC_OUTPUT in datasheet; adjust if you prefer other reg
    parameter logic [15:0] ADDR_DET1 = 16'h0014, // Detector 1 readback reg (example addresses from earlier discussion)
    parameter logic [15:0] ADDR_DET2 = 16'h0015,
    parameter logic [15:0] ADDR_DET3 = 16'h0016,
    parameter logic [15:0] ADDR_DET4 = 16'h0017
)(
    input  logic        clk,
    input  logic        rst_n,

    // Control interface
    input  logic        start_sample, // pulse to start a new sample sequence
    output logic        busy,         // high while sampling in progress
    output logic        data_ready,   // pulse when temp+detectors available

    // Handshake to/from SPI master (abstracted service)
    output logic        spi_req,      // pulse here to ask SPI master to perform a read
    output logic [15:0] spi_addr,     // address to read (from ADAR1000 RAM/register)
    input  logic        spi_done,     // SPI master pulses when read completed
    input  logic [7:0]  spi_read_data, // data returned by SPI master

    // Outputs: raw detector codes and converted temperature
    output logic [7:0]  det_code [4],   // det_code[0] -> DET1, ... det_code[3] -> DET4
    output logic signed [31:0] temp_centi // temperature in centi-degrees C (signed)
);

    // FSM states
    typedef enum logic [2:0] {
        IDLE,
        REQ_TEMP,
        WAIT_TEMP,
        REQ_DET1,
        WAIT_DET1,
        REQ_DET2,
        WAIT_DET2,
        REQ_DET3,
        WAIT_DET3,
        REQ_DET4,
        WAIT_DET4,
        DONE
    } state_t;

    state_t state, next_state;

    // internal storage
    logic [7:0] temp_raw;
    // det_code array declared in outputs

    // Simple one-cycle pulse generator for spi_req (we hold spi_req high for 1 cycle)
    logic spi_req_int;

    // FSM sequential
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // FSM combinational + control outputs
    always_comb begin
        // defaults
        next_state = state;
        spi_req_int = 1'b0;
        spi_addr = 16'h0000;
        busy = 1'b1;
        data_ready = 1'b0;

        case (state)
            IDLE: begin
                busy = 1'b0;
                if (start_sample) begin
                    next_state = REQ_TEMP;
                end
            end

            // Temperature
            REQ_TEMP: begin
                // request a read from temperature register
                spi_req_int = 1'b1;
                spi_addr = ADDR_TEMP;
                next_state = WAIT_TEMP;
            end
            WAIT_TEMP: begin
                // wait for spi_done and capture data on positive edge (sequential block)
                if (spi_done) next_state = REQ_DET1;
            end

            // Detector 1
            REQ_DET1: begin
                spi_req_int = 1'b1;
                spi_addr = ADDR_DET1;
                next_state = WAIT_DET1;
            end
            WAIT_DET1: begin
                if (spi_done) next_state = REQ_DET2;
            end

            // Detector 2
            REQ_DET2: begin
                spi_req_int = 1'b1;
                spi_addr = ADDR_DET2;
                next_state = WAIT_DET2;
            end
            WAIT_DET2: begin
                if (spi_done) next_state = REQ_DET3;
            end

            // Detector 3
            REQ_DET3: begin
                spi_req_int = 1'b1;
                spi_addr = ADDR_DET3;
                next_state = WAIT_DET3;
            end
            WAIT_DET3: begin
                if (spi_done) next_state = REQ_DET4;
            end

            // Detector 4
            REQ_DET4: begin
                spi_req_int = 1'b1;
                spi_addr = ADDR_DET4;
                next_state = WAIT_DET4;
            end
            WAIT_DET4: begin
                if (spi_done) next_state = DONE;
            end

            DONE: begin
                // signal data ready for one cycle; then go to IDLE
                data_ready = 1'b1;
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Connect spi_req (one-cycle) to external output
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            spi_req <= 1'b0;
        end else begin
            spi_req <= spi_req_int;
        end
    end

    // Capture spi_read_data when spi_done asserted (on rising edge):
    // which register was read is determined by state when the request was made.
    // We'll capture in the state where we were waiting.
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            temp_raw <= 8'h00;
            det_code[0] <= 8'h00;
            det_code[1] <= 8'h00;
            det_code[2] <= 8'h00;
            det_code[3] <= 8'h00;
            temp_centi <= 32'sd0;
        end else begin
            // Default: leave stored values
            if (state == WAIT_TEMP && spi_done) begin
                temp_raw <= spi_read_data;
                // convert immediately to centi-degrees:
                // T_centi = 2500 + (adc_raw - 145) * 125
                // Keep signed arithmetic: expand to signed 32-bit
               temp_centi <= 32'sd2500 + ($signed({1'b0, spi_read_data}) - 32'sd145) * 32'sd125;
            end

            if (state == WAIT_DET1 && spi_done) begin
                det_code[0] <= spi_read_data;
            end
            if (state == WAIT_DET2 && spi_done) begin
                det_code[1] <= spi_read_data;
            end
            if (state == WAIT_DET3 && spi_done) begin
                det_code[2] <= spi_read_data;
            end
            if (state == WAIT_DET4 && spi_done) begin
                det_code[3] <= spi_read_data;
            end
        end
    end

endmodule
