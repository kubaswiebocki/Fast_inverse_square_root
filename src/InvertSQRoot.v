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

//Conncet and Register + Params
//////////////////////////////////////////////////////////////////////////////////
module InvertSQRoot(
    output reg  [31:0] DataOut,
    
    input wire [31:0] DataIn,
    input wire clk,
    input wire rst
    );
    
reg  [31:0] Data_temp, Data_temp_nxt;
reg  [31:0] DataOut_nxt;
reg         Data_sign;
reg  [7:0]  exp;
reg  [31:0] mantysa;

//////////////////////////////////////////////////////////////////////////////////

//Zegar
//////////////////////////////////////////////////////////////////////////////////
always@ (posedge clk) begin
    if(rst) begin
        DataOut <= 0;
        end
    else begin
        DataOut <= DataOut_nxt;
        Data_temp <= Data_temp_nxt;
        end
    end
//////////////////////////////////////////////////////////////////////////////////

//Algorytm InverSQRoot
//////////////////////////////////////////////////////////////////////////////////
always@* begin
    Data_sign = DataIn[31];
    exp = DataIn[30:23] - 127;
    mantysa = DataIn[22:0] | {1'b1, 23'h0};
    if (exp >= 0)
        Data_temp_nxt = {1'b1, mantysa[22:0]};
    else
        Data_temp_nxt = {1'b1, mantysa[14:0], {(-exp)-{1'b0}}};
    Data_temp_nxt = Data_temp_nxt >> 1;  
    Data_temp_nxt[30:23] = Data_temp_nxt[30:23] - 127 + 16;
    Data_temp_nxt[31] = Data_sign;
    DataOut = Data_temp_nxt;
    end
//////////////////////////////////////////////////////////////////////////////////
endmodule
