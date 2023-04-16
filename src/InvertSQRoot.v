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
    
    output wire [31:0] DataOut,
    output wire DataValid
    );
    
//************************************************************************//
wire [31:0] InitData, Half_DataIN, Data_result;
wire Valid;

//Init_InvSQRoot
Init_InvSQRoot Init_InvSQRoot(
    .clk(clk),
    .rst(rst),
    .DataIn(DataIn),
    
    .DataOut(InitData),
    .Half_DataIN(Half_DataIN)
    );

//NewtonApprox
NewtonApprox NewtonApprox_1(
    .clk(clk),
    .rst(rst),
    .Data_in1(InitData),
    .Data_in2(Half_DataIN),
    
    .Data_out(Data_result),
    .Valid(Valid)
    );
//Assings    
//**********************************************************************//
assign DataOut = Data_result;
assign DataValid = Valid;

endmodule