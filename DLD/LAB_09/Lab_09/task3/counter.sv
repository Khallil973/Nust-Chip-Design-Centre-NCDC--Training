`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2025 10:12:34 PM
// Design Name: 
// Module Name: counter
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


module counter(
    input logic clk,
    input logic arst_n,
    output logic [3:0] out
    );
    
    logic [3:0] count;
    
    always_ff @(posedge clk or negedge arst_n) begin
        if(!arst_n) begin
            count <= 4'd0; 
        end
        else begin
            count <= count + 4'd1; 
        end
    end
    
    
    always_comb begin   
       case(count)
        4'd0 : out = 4'd0;
        4'd1 : out = 4'd2;
        4'd2 : out = 4'd4;
        4'd3 : out = 4'd6;
        4'd4 : out = 4'd1;
        4'd5 : out = 4'd3;
        4'd6 : out = 4'd5;
        4'd7 : out = 4'd7;
        default : out = 4'd0;
        endcase
      
    end  
    
endmodule
