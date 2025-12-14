`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 09:49:49 AM
// Design Name: 
// Module Name: debounce
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
module debounce(
    input logic  clk_in,
    input logic  rst_in,
    input logic  noisy_in,
    output logic clean_out,
    output logic [19:0] count_out,
    output logic new_1
);

    logic [19:0] count = 20'b0;
    logic new_input = 1'b0;

    always_ff @(posedge clk_in or posedge rst_in) begin
        if (rst_in) begin 
            new_input <= noisy_in; 
            clean_out <= noisy_in; 
            count <= 0; 
        end
        else if (noisy_in != new_input) begin
            new_input <= noisy_in; 
            count <= 0; 
        end
        else if (count[10]) begin //(count == 1000000)  //Samples will be stable acording to the count to hightest bits, it means when count are same for provided no of cycles so it means it stable and then output the new_input which is noisy input  to clean ou
            clean_out <= new_input;
        end
        else begin 
            count <= count + 1;
        end
    end  

    assign count_out = count; 
    assign new_1 = new_input;
    
    
endmodule

