`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2025 05:39:01 PM
// Design Name: 
// Module Name: master
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
module master #(
    parameter CPOL = 0,  // Clock polarity (0: idle low, 1: idle high)
    parameter CPHA = 0   // Clock phase (0: sample on first edge, 1: sample on second edge)
)(
    input wire clk,
    input wire rst,
    input wire en,
    output reg cs,
    output reg sck,
    input wire [7:0] ext_command_in,
    input wire [15:0] ext_address_in,
    output reg mosi,
    input wire miso,
    output reg [7:0] ext_data_out
);

    // Internal registers
    logic [23:0] data_save;    // 8-bit cmd + 16-bit addr
    logic [4:0] bit_count;
    logic [7:0] miso_shift;

    // State machine definition
    typedef enum logic [1:0] {
        IDLE   = 2'b00,
        ENABLE = 2'b01,
        DATA   = 2'b10,
        DONE   = 2'b11
    } state_t;
    
    state_t current_state;

    // SCK generation with CPOL control
    always @(posedge clk) begin
        if (rst) begin
            sck <= CPOL;
        end else if (current_state == DATA) begin
            sck <= ~sck;
        end else begin
            sck <= CPOL;
        end
    end

    // MOSI shifting based on CPHA
    always @(negedge sck or posedge rst) if (CPHA == 0) begin
        if (rst) begin
            mosi <= 1'b0;
            data_save <= 24'b0;
        end else if (current_state == DATA && bit_count < 24) begin
            mosi <= data_save[23];
            data_save <= {data_save[22:0], 1'b0};
        end
    end
    
    always @(posedge sck or posedge rst) if (CPHA == 1) begin
        if (rst) begin
            mosi <= 1'b0;
            data_save <= 24'b0;
        end else if (current_state == DATA && bit_count < 24) begin
            mosi <= data_save[23];
            data_save <= {data_save[22:0], 1'b0};
        end
    end

    // MISO sampling based on CPHA
    always @(posedge sck or posedge rst) if (CPHA == 0) begin
        if (rst) begin
            ext_data_out <= 8'b0;
            miso_shift <= 8'b0;
        end else if (current_state == DATA) begin
            if (bit_count >= 16 && bit_count < 24) begin
                miso_shift <= {miso_shift[6:0], miso};
                if (bit_count == 23) begin
                    ext_data_out <= {miso_shift[6:0], miso};
                end
            end
        end
    end
    
    always @(negedge sck or posedge rst) if (CPHA == 1) begin
        if (rst) begin
            ext_data_out <= 8'b0;
            miso_shift <= 8'b0;
        end else if (current_state == DATA) begin
            if (bit_count >= 16 && bit_count < 24) begin
                miso_shift <= {miso_shift[6:0], miso};
                if (bit_count == 23) begin
                    ext_data_out <= {miso_shift[6:0], miso};
                end
            end
        end
    end

    // State machine
    always @(posedge clk) begin
        if (rst) begin
            current_state <= IDLE;
            bit_count <= 0;
            cs <= 1'b1;
        end else begin
            case (current_state)
                IDLE: begin
                    cs <= 1'b1;
                    bit_count <= 0;
                    if (en) begin
                        data_save <= {ext_command_in, ext_address_in};
                        current_state <= ENABLE;
                    end
                end
                
                ENABLE: begin
                    cs <= 1'b0;
                    if (sck == CPOL) begin
                        current_state <= DATA;
                    end
                end
                
                DATA: begin
                    if (bit_count == 24) begin
                        current_state <= DONE;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end
                
                DONE: begin
                    if (sck == CPOL) begin
                        cs <= 1'b1;
                        current_state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule