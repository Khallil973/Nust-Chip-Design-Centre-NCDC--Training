`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2025 04:59:26 PM
// Design Name: 
// Module Name: gate_mux
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

module gate_mux(
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    input logic [1:0]s,
    output logic y
);
    logic s0, s1;
    logic gate_a;
    logic gate_b;
    logic gate_c;
    logic gate_d;

    not (s0, s[0]); // s0 = ~s[0]
    not (s1, s[1]); // s1 = ~s[1]
//MSB TO LSB
    and (gate_a, a, s1, s0);           // 00
    and (gate_b, b, s1, s[0]);         // 01
    and (gate_c, c, s[1], s0);         // 10
    and (gate_d, d, s[1], s[0]);       // 11       

    or (y, gate_a, gate_b, gate_c, gate_d);
    
    
endmodule