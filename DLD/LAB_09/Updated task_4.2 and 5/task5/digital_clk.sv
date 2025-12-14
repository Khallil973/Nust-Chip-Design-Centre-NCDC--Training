`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2025 05:16:35 PM
// Design Name: 
// Module Name: digital_clk
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

//module freq_div(
//    input logic clk_50,
//    input logic rst,
//    output [25:0] count_out,
//    output logic clk_1
//    );

//    //For 50MHZ to 1Hz so according to calculation we required 25.57 count so we take register to count for approx 26
//    logic [25:0] count;
    
//    always_ff @(posedge clk or posedge rst) begin
//        if(rst) begin
//            count <= 0;
//            clk_1 <= 0;
//        end
//        else begin 
//            count <= count + 1;
//    end
    
//    assign count_out = count;
//    assign clk_1 = count[25];
    
    
    
//endmodule
 
 

module digital_clk (
    input logic clk_50,
    input logic rst,
   // input  logic clk,         // 1Hz clock
    //input  logic rst,         // Active-high synchronous reset
    output logic [25:0] count_out,
    output logic clk_1,
    output logic [5:0] sec,   // 0-59
    output logic [5:0] min,   // 0-59
    output logic [4:0] hr     // 0-23
  //  input logic clk
);

    //For 50MHZ to 1Hz so according to calculation we required 25.57 count so we take register to count for approx 26
    logic [25:0] count;
    
    always_ff @(posedge clk_50 or posedge rst) begin
        if(rst) begin
            count <= 0;
        end
        else begin 
            count <= count + 1;
        end    
    end
    
    assign count_out = count;
    assign clk_1 = count[0];
    

    always_ff @(posedge clk_1 or posedge rst) begin
        if (rst) begin
            sec <= 0;
            min <= 0;
            hr  <= 0;
        end else begin
            // Count seconds
            if (sec == 59) begin
                sec <= 0;

                // Count minutes
                if (min == 59) begin
                    min <= 0;

                    // Count hours
                    if (hr == 23)
                        hr <= 0;
                    else
                        hr <= hr + 1;

                end else begin
                    min <= min + 1;
                end

            end else begin
                sec <= sec + 1;
            end
        end
    end

endmodule


