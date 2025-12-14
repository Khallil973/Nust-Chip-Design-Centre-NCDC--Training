`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2025 09:37:55 AM
// Design Name: 
// Module Name: barrel_shifter
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


module barrel_shifter_left(
    input logic [3:0] A,
    input logic [1:0] sel1,
    output logic [3:0] out1
    );
    
    //Shift Left
    always_comb begin
        case(sel1) 
            2'b00 : out1 = A;
            2'b01 : out1 = {A[2:0], 1'b0};
            2'b10 : out1 = {A[1:0], 2'b00};
            2'b11 : out1 = {A[0], 3'b000};
            
        endcase
    
    
    end
    
    
endmodule


module barrel_shifter_right(
    input logic [3:0] B,
    input logic [1:0] sel2,
    output logic [3:0] out2
    );
    
    //Shift Left
    always_comb begin
        case(sel2) 
            2'b00 : out2 = B;
            2'b01 : out2 = {1'b0, B[3:1]};
            2'b10 : out2 = {2'b00, B[3:2]};
            2'b11 : out2 = {3'b000, B[3]};
            
        endcase
    
    
    end
    
    
endmodule


module mux2x1(
    input logic [3:0] in0,
    input logic [3:0] in1,
    input logic mux_sel,
    output logic [3:0] mux_out
);


    assign mux_out = (mux_sel == 0) ? in0 : in1;
    
endmodule





module barrel_shift_top(
    input logic [3:0] A,
    input logic [3:0] B,
    input logic [1:0] s, //for mux sel
    input logic Y, //sel left or right shift
    output logic [3:0] out
);

    logic [3:0] left_shift;
    logic [3:0] right_shift;
    
    
   barrel_shifter_left dut1(
                           .A(A),
                           .sel1(s),
                           .out1(left_shift)
    );

    barrel_shifter_right dut2(
                           .B(B),
                           .sel2(s),
                           .out2(right_shift)
    );
    


    mux2x1 dut3(
                        .in0(left_shift),
                        .in1(right_shift),
                        .mux_sel(Y),
                        .mux_out(out)
);


endmodule 