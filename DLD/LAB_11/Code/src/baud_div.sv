`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 06:47:22 PM
// Design Name: 
// Module Name: baud_div
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

module baud_div(
    input logic sys_clk,
    input logic [1:0] baud_sel,
    input logic arst_n,
    input logic en,
//output logic [31:0] selected_baud, // baud_div or baud_output
    output logic baud_tick,
    output logic [31:0] count_out
    );
    
    logic [31:0] selected_baud;
    logic [31:0] count;//baud_rate counter
    
    //Formual baud_div = sys_clk/8 * baud_rate
   
    always_comb begin
       case(baud_sel) 
           2'b00: selected_baud = 32'd130;   // For 9600 baud
           2'b01: selected_baud = 32'd65;    // For 19200 baud
           2'b10: selected_baud = 32'd32;    // For 38400 baud
           2'b11: selected_baud = 32'd16;    // For 76800 baud
           default: selected_baud = 32'd130; // Default to 9600
       endcase
       end
       
    //baud div = 131 so directly give the input through tb  
    always_ff @(posedge sys_clk) begin
        if(!arst_n) begin
            baud_tick <= 0;
            count <= 0;
        end
        else if (en) begin
            if(count == selected_baud - 1) begin
                count <= 0;
                baud_tick <= 1'b1;
                //two clks for one cycle like 20 for pos and 20 for neg
                
           end
           else begin
            count <= count + 1;
            baud_tick <= 1'b0;
           end
       end    
      else begin 
        baud_tick <= 1'b0;
        count <= 0;
        
      end
        
    end 
    
assign count_out = count;
   
endmodule

