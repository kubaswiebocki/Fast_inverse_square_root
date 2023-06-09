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
    input wire ce,
    input wire [31:0] DataIn,
    
    output reg [31:0] DataOut,
    output reg DataValid
    );
    
//************************************************************************//
wire [31:0] InitData, Half_DataIN, Data_result;
wire Valid, ce_1;

//Init_InvSQRoot
Init_InvSQRoot Init_InvSQRoot(
    .clk(clk),
    .rst(rst),
    .ce(ce),
    .DataIn(DataIn),
    
    .DataOut(InitData),
    .Half_DataIN(Half_DataIN),
    .ce_out(ce_1)
    );

//NewtonApprox
NewtonApprox NewtonApprox_1(
    .clk(clk),
    .rst(rst),
    .ce(ce_1),
    .Data_in1(InitData),
    .Data_in2(Half_DataIN),
    
    .Data_out(Data_result),
    .Valid(Valid)
    );
//Assings    
//**********************************************************************//
always@ (posedge clk) begin
    if(rst) begin
        end
    else if(!Valid) begin
        DataOut <= DataOut;
        DataValid <= Valid;
        end
    else begin
        DataOut  <= Data_result;
        DataValid <= Valid;
        end
    end

endmodule