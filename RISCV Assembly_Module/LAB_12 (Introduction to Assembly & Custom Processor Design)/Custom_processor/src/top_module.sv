`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2025 05:53:26 PM
// Design Name: 
// Module Name: top_module
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
module top_module#(
    parameter IMEM_DEPTH = 4,     // Instruction Memory Depth
    parameter REGF_WIDTH = 16,    // Register File Width
    parameter ALU_WIDTH = 16,     // ALU Width
    parameter PROG_VALUE = 3      // Program Counter Max Value
    )(
    
    input logic clk,
    input logic rst
    
);

//Connection
logic [2:0] pc_update;
logic [7:0] instruction_out;
logic [REGF_WIDTH-1:0] rs1_in,rs2_in, alu_out_in;
logic [REGF_WIDTH-1:0] rs1_out, rs2_out;
//logic WE_regfile;

//PC
program_counter #(
    .PROG_VALUE(PROG_VALUE),
    .WIDTH(3) // Maximum counter       
)pc(
    .clk(clk),
    .rst(rst),          
    .pc(pc_update + 1),  //increment
    .pc_out(pc_update)   
);


//Instruction Mem
instruction_mem #(
    .WIDTH(8),       // Each instruction is 8 bits wide
   .DEPTH(IMEM_DEPTH)       // Memory can store 32 instructions
)dut1(
    .clk(clk),
    .rst(rst),            // Active low reset
    .A(pc_update),  // Address input
    .instruction(instruction_out)
);
   //Register File
reg_file #(
   .WIDTH(REGF_WIDTH)
   )dut2(
    .clk(clk),
    .rst(rst),
    .WE(instruction_out[0]), //write enable or need to check
    .WD(alu_out_in), //write data
    .rs1(instruction_out[3:2]),
    .rs2(instruction_out[5:4]),
    .rd(instruction_out[7:6]),    
    .rs1_out(rs1_out),
    .rs2_out(rs2_out)  
);


alu #(
    .WIDTH(ALU_WIDTH)
   )dut3(
    .A(rs1_out),
    .B(rs2_out),
    .opcode(instruction_out[1:0]),
    .alu_out(alu_out_in)
 );
 
assign rs1_in = rs1_out;
assign rs2_in = rs2_out;
    
endmodule
