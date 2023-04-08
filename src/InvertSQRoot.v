`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Lukasz Orzel
// Engineer: Jakub Swiebocki
// Module Name: InvertSQRoot
// Project Name: Fast inverse square root 
// Target Devices: ZedBoard
// Tool Versions: Vivado 2018.2
// 
//////////////////////////////////////////////////////////////////////////////////

//************************************************************************//
module InvertSQRoot(
    input wire clk,
    input wire rst,
    input wire [31:0] DataIn,
    
    output wire [31:0] DataOut
    );
    
wire [31:0] InitData, Half_DataIN, Data_mul_square, Data_mul_by_1_5;

//Init_InvSQRoot
//************************************************************************//
Init_InvSQRoot Init_InvSQRoot(
    .clk(clk),
    .rst(rst),
    .DataIn(DataIn),
    
    .DataOut(InitData),
    .Half_DataIN(Half_DataIN)
    );

//Mul y*y
//**********************************************************************//
Multiplication Multiplication_y_by_y(
    .clk(clk),
    .rst(rst),
    .Num_1(InitData),
    .Num_2(InitData),
    
    .NumOut(Data_mul_square)
    );
    
//Mul x2*y
//**********************************************************************//
Multiplication Multiplication_by_1_5(
        .clk(clk),
        .rst(rst),
        .Num_1(Data_mul_square),
        .Num_2(Half_DataIN),
        
        .NumOut(Data_mul_by_1_5)
        );
//Assings    
//**********************************************************************//
assign DataOut = InitData;

endmodule