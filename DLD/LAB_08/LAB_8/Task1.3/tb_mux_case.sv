`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2025 02:54:44 PM
// Design Name: 
// Module Name: tb_mux_case
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


module tb_mux;
    logic a,b,c,d;
    logic [1:0] s;
    logic y;
    
    
   Mux4x1 dut(
         .a(a),
         .b(b),
         .c(c),
         .d(d),
         .s(s),
         .y(y)
     ); 
     
 //stimulus
 initial begin
    a = 1;
    b = 0;
    c = 0;
    d = 0;  
    s = 2'b00;
    #100;
    
    a = 0;
    b = 1;
    c = 0;
    d = 0;  
    s = 2'b01;
    #100; 
    
    a = 0;
    b = 0;
    c = 1;
    d = 0;  
    s = 2'b10;
    #100;
    
    a = 0;
    b = 0;
    c = 0;
    d = 1;  
    s = 2'b11;
    #100;
    $finish;
 end
////Declaring the Dump file
//   initial begin
//       $dumpfile("dump.vcd");
//       $dumpvars(0);
    
//   end
 
 
endmodule