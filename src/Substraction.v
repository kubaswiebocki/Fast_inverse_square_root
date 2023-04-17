`timescale 1ns / 1ps
// Registers
//////////////////////////////////////////////////////////////////////////////////
module Substraction(
    input wire clk,
    input wire rst,
    input wire ce,
    input wire [31:0] NumB,
    input wire [31:0] Init,
    
    output reg [31:0] NumOut,
    output reg [31:0] Init_data
);

reg [31:0] NumOut_nxt, Init_temp, Init_temp1;
reg [23:0] Sub_mantissa, Sub_mantissa_nxt, M_Norm, M_Norm_nxt;
reg [7:0]  E_Norm, E_Norm_nxt;
 
localparam OneAndHalf = {1'b0, 8'b01111111, 23'b10000000000000000000000};
localparam E_max = 8'b01111111;
localparam Sign = 1'b0;

// Always
//////////////////////////////////////////////////////////////////////////////////
always@ (posedge clk) begin
    if(rst) begin
        NumOut <= 0;
        end
    else begin
        NumOut <= NumOut_nxt;
        Sub_mantissa <= Sub_mantissa_nxt;
        M_Norm <= M_Norm_nxt;
        E_Norm <= E_Norm_nxt;
        
        Init_data  <= Init_temp1;
        end
    end
//////////////////////////////////////////////////////////////////////////////////

// Substraction
//////////////////////////////////////////////////////////////////////////////////
always@* begin
    if(ce) begin
        Init_temp  = Init;
        Init_temp1 = Init_temp;
        //Max Eponenta i przesuwanie mantysy
        Sub_mantissa_nxt = ( {1'b1, OneAndHalf[22:0]} ) - ( {1'b1, NumB[22:0]} >> (OneAndHalf[30:23] - NumB[30:23]) ); // 1.5 - ( Num1 shift by diff of exps)
    
    // Normalizacja
    ///////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////
        if(Sub_mantissa[23] == 1) begin
            M_Norm_nxt = Sub_mantissa << 1;
            E_Norm_nxt = E_max - 0;
            end
        else if (Sub_mantissa[22] == 1) begin
            M_Norm_nxt = Sub_mantissa << 2;
            E_Norm_nxt = E_max - 1;
            end
        else if (Sub_mantissa[21] == 1) begin
            M_Norm_nxt = Sub_mantissa << 3;
            E_Norm_nxt = E_max - 2;
            end
        else if (Sub_mantissa[20] == 1) begin
            M_Norm_nxt = Sub_mantissa << 4;
            E_Norm_nxt = E_max - 3;
            end
        else if (Sub_mantissa[19] == 1) begin
            M_Norm_nxt = Sub_mantissa << 5;
            E_Norm_nxt = E_max - 4;
            end
        else if (Sub_mantissa[18] == 1) begin
            M_Norm_nxt = Sub_mantissa << 6;
            E_Norm_nxt = E_max - 5;
            end
        else if (Sub_mantissa[17] == 1) begin
            M_Norm_nxt = Sub_mantissa << 7;
            E_Norm_nxt = E_max - 6;
            end
        else if (Sub_mantissa[16] == 1) begin
            M_Norm_nxt = Sub_mantissa << 8;
            E_Norm_nxt = E_max - 7;
            end
        else if (Sub_mantissa[15] == 1) begin
            M_Norm_nxt = Sub_mantissa << 9;
            E_Norm_nxt = E_max - 8;
            end
        else if (Sub_mantissa[14] == 1) begin
            M_Norm_nxt = Sub_mantissa << 10;
            E_Norm_nxt = E_max - 9;
            end
        else if (Sub_mantissa[13] == 1) begin
            M_Norm_nxt = Sub_mantissa << 11;
            E_Norm_nxt = E_max - 10;
            end
        else if (Sub_mantissa[12] == 1) begin
            M_Norm_nxt = Sub_mantissa << 12;
            E_Norm_nxt = E_max - 11;
            end
        else if (Sub_mantissa[11] == 1) begin
            M_Norm_nxt = Sub_mantissa << 13;
            E_Norm_nxt = E_max - 12;
            end
        else if (Sub_mantissa[10] == 1) begin
            M_Norm_nxt = Sub_mantissa << 14;
            E_Norm_nxt = E_max - 13;
            end
        else if (Sub_mantissa[9] == 1) begin
            M_Norm_nxt = Sub_mantissa << 15;
            E_Norm_nxt = E_max - 14;
            end
        else if (Sub_mantissa[8] == 1) begin
            M_Norm_nxt = Sub_mantissa << 16;
            E_Norm_nxt = E_max - 15;
            end
        else if (Sub_mantissa[7] == 1) begin
            M_Norm_nxt = Sub_mantissa << 17;
            E_Norm_nxt = E_max - 16;
            end
        else if (Sub_mantissa[6] == 1) begin
            M_Norm_nxt = Sub_mantissa << 18;
            E_Norm_nxt = E_max - 17;
            end
        else if (Sub_mantissa[5] == 1) begin
            M_Norm_nxt = Sub_mantissa << 19;
            E_Norm_nxt = E_max - 18;
            end
        else if (Sub_mantissa[4] == 1) begin
            M_Norm_nxt = Sub_mantissa << 20;
            E_Norm_nxt = E_max - 19;
            end
        else if (Sub_mantissa[3] == 1) begin
            M_Norm_nxt = Sub_mantissa << 21;
            E_Norm_nxt = E_max - 20;
            end
        else if (Sub_mantissa[2] == 1) begin
            M_Norm_nxt = Sub_mantissa << 22;
            E_Norm_nxt = E_max - 21;
            end
        else if (Sub_mantissa[1] == 1) begin
            M_Norm_nxt = Sub_mantissa << 23;
            E_Norm_nxt = E_max - 22;
            end
        else begin
            M_Norm_nxt = Sub_mantissa << 24;
            E_Norm_nxt = E_max - 23;
            end
    ///////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////
                
        //Dokonczyc nrmalizacje
        NumOut_nxt = {Sign, E_Norm, M_Norm[23:1]};
        end
    else begin
        NumOut_nxt = NumOut;
        Sub_mantissa_nxt = Sub_mantissa;
        M_Norm_nxt = M_Norm;
        E_Norm_nxt = E_Norm;
        Init_temp = Init_temp1;
        Init_temp1 = Init_data;
        end
    end
endmodule
//////////////////////////////////////////////////////////////////////////////////


////Max Eponenta i przesuwanie mantysy
//if(OneAndHalf[30:23] > NumB[30:23]) begin
//    max_exponent_nxt = OneAndHalf[30:23];
//    Sub_mantissa_nxt = {1'b1, OneAndHalf[22:0]} - ( {1'b1, NumB[22:0]} >> (OneAndHalf[30:23] - NumB[30:23]) ); // 1.5 - ( Num1 shift by diff of exps)
//    end
//else begin
//    max_exponent_nxt = NumB[30:23];
//    Sub_mantissa_nxt = {1'b1, NumB[22:0]} - ( {1'b1, OneAndHalf[22:0]} >> (NumB[30:23] - OneAndHalf[30:23]) );
//    end