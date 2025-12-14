`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2025 05:31:57 PM
// Design Name: 
// Module Name: program_counter
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
module program_counter #(
    parameter PROG_VALUE = 3, //max counter
    parameter WIDTH = 3 // Maximum counter width   
)(
    input logic clk,
    input logic rst,          
    input logic [WIDTH-1:0] pc,  
    output logic [WIDTH-1:0] pc_out   // Current PC value
);
    
    always_ff @(posedge clk or posedge rst) begin
        if (!rst) begin         
            pc_out <= 3'b0;      
        end
        else begin
            pc_out <= (pc > PROG_VALUE) ? PROG_VALUE : pc;
           // pc_out <= pc;
        end
    end
    
endmodule