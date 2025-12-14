`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2025 07:41:41 PM
// Design Name: 
// Module Name: uni_shif_reg
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


module uni_shif_reg(
    input clk, rst_n,
    input [1:0] ctrl,
    input logic serial_ls, serial_rs,//serial right , serial left shift
    input logic [3:0] parallel_in,
    output [3:0] s_out
    );
    
    //register
    logic [3:0] shift_reg;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            shift_reg <= 4'b0;
        end
        else begin
        case(ctrl) 
            2'b00 : shift_reg <= shift_reg;
            2'b01 : shift_reg <= {serial_rs, shift_reg[3:1]};
            2'b10 : shift_reg <= {shift_reg[2:0], serial_ls};
            2'b11 : shift_reg <= parallel_in;
            endcase
        end
     
    end
    
    assign s_out = shift_reg;    
    
endmodule
