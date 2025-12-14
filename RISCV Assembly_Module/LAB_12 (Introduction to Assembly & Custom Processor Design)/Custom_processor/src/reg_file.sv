`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2025 04:07:03 PM
// Design Name: 
// Module Name: reg_file
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
module reg_file #(parameter WIDTH = 16)(
    input logic clk,
    input logic rst,
    input logic WE, //write enable
    input logic [WIDTH-1:0] WD, //write data
    input logic [1:0] rs1,
    input logic [1:0] rs2,
    input logic [1:0] rd,    
    output logic [WIDTH-1:0] rs1_out,
    output logic [WIDTH-1:0] rs2_out  
);
    //memory
    logic [WIDTH-1:0] register [0:3];
    
//    initial begin
//        register[0] = '0;
//        $readmemb("C:\Users\lab\Documents\SV\Lab_12\Lab_12_Custom_Processor\fib_rf", register[1:3]);
//    end

   // Logging vars
    integer fd;
    integer i;

    // Load register file from binary file
    initial begin
        $readmemb("C:/Users/lab/Documents/SV/Lab_12/Lab_12_Custom_Processor/fib_rf.mem", register);
        register[0] = '0; // Keep R0 = 0
        fd = $fopen("regfile.dump", "w");
        #100; // adjust simulation time
        $fclose(fd);
    end

    // Write register contents to file each clock cycle
    always @(posedge clk) begin
        for (i = 0; i < 4; i = i + 1) begin
            $fdisplay(fd, register[i]);
        end
    end    
    //read functionality (corrected output signals)
    assign rs1_out = register[rs1];
    assign rs2_out = register[rs2];
    
    //write enable functionality
    always_ff @(posedge clk or posedge rst) begin
        if (WE && rd != 2'b00) begin
            register[rd] <= WD;
        end
    end
    


endmodule