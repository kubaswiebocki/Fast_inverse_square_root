`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module Substraction(
    input wire clk,
    input wire rst,
    input wire [31:0] NumA,
    input wire [31:0] NumB,
    
    output reg [31:0] NumOut
);

reg [31:0] NumOut_nxt;
reg [23:0] Shifted_mantissa, Shifted_mantissa_nxt, Sub_mantissa, Sub_mantissa_nxt, Sub2_mantissa, Sub2_mantissa_nxt;
reg [7:0] max_exponent, max_exponent_nxt, max2_exponent, max2_exponent_nxt;
wire [7:0] E_1, E_2, SH;
wire [23:0] M_1, M_2;

assign E_1 = NumA[30:23];
assign M_1 = {1'b1, NumA[22:0]};
assign E_2 = NumB[30:23];
assign M_2 = {1'b1, NumB[22:0]};
assign SH  = NumA[30:23] - NumB[30:23];


always@ (posedge clk) begin
    if(rst) begin
        NumOut <= 0;
        end
    else begin
        NumOut <= NumOut_nxt;
        Sub_mantissa <= Sub_mantissa_nxt;
        Sub2_mantissa <= Sub2_mantissa_nxt;
        Shifted_mantissa <= Shifted_mantissa_nxt;
        max_exponent <= max_exponent_nxt;
        max2_exponent <= max2_exponent_nxt;
        end
    end

always@* begin
    //Max Eponenta i przesuwanie mantysy
    if(NumA[30:23] > NumB[30:23]) begin
        max_exponent_nxt = NumA[30:23];
        Shifted_mantissa_nxt = {1'b1, NumB[22:0]} >> (NumA[30:23] - NumB[30:23]);
        Sub_mantissa_nxt = {1'b1, NumA[22:0]} - Shifted_mantissa[23:0];
        end
    else begin
        max_exponent_nxt = NumB[30:23];
        Shifted_mantissa_nxt = {1'b1, NumA[22:0]} >> (NumB[30:23] - NumA[30:23]);
        Sub_mantissa_nxt = {1'b1, NumB[22:0]} - Shifted_mantissa[23:0];
        end
    
    if(Sub_mantissa[23] == 1) begin
        Sub2_mantissa_nxt = Sub_mantissa << 1;
        max2_exponent_nxt = max_exponent - 0;
        end
    else if (Sub_mantissa[22] == 1) begin
        Sub2_mantissa_nxt = Sub_mantissa << 2;
        max2_exponent_nxt = max_exponent - 1;
        end
    else if (Sub_mantissa[21] == 1) begin
        Sub2_mantissa_nxt = Sub_mantissa << 3;
        max2_exponent_nxt = max_exponent - 2;
        end
    else if (Sub_mantissa[20] == 1) begin
        Sub2_mantissa_nxt = Sub_mantissa << 4;
        max2_exponent_nxt = max_exponent - 3;
        end
    else if (Sub_mantissa[19] == 1) begin
        Sub2_mantissa_nxt = Sub_mantissa << 5;
        max2_exponent_nxt = max_exponent - 4;
        end
    else if (Sub_mantissa[18] == 1) begin
        Sub2_mantissa_nxt = Sub_mantissa << 6;
        max2_exponent_nxt = max_exponent - 5;
        end
    else if (Sub_mantissa[17] == 1) begin
        Sub2_mantissa_nxt = Sub_mantissa << 7;
        max2_exponent_nxt = max_exponent - 6;
        end
    else if (Sub_mantissa[16] == 1) begin
        Sub2_mantissa_nxt = Sub_mantissa << 8;
        max2_exponent_nxt = max_exponent - 7;
        end
    else if (Sub_mantissa[15] == 1) begin
        Sub2_mantissa_nxt = Sub_mantissa << 9;
        max2_exponent_nxt = max_exponent - 8;
        end
    else if (Sub_mantissa[14] == 1) begin
        Sub2_mantissa_nxt = Sub_mantissa << 10;
        max2_exponent_nxt = max_exponent - 9;
        end
    else if (Sub_mantissa[13] == 1) begin
        Sub2_mantissa_nxt = Sub_mantissa << 11;
        max2_exponent_nxt = max_exponent - 10;
        end
    else if (Sub_mantissa[12] == 1) begin
        Sub2_mantissa_nxt = Sub_mantissa << 12;
        max2_exponent_nxt = max_exponent - 11;
        end
    else if (Sub_mantissa[11] == 1) begin
        Sub2_mantissa_nxt = Sub_mantissa << 13;
        max2_exponent_nxt = max_exponent - 12;
        end
    else if (Sub_mantissa[10] == 1) begin
        Sub2_mantissa_nxt = Sub_mantissa << 14;
        max2_exponent_nxt = max_exponent - 13;
        end
    else if (Sub_mantissa[9] == 1) begin
        Sub2_mantissa_nxt = Sub_mantissa << 15;
        max2_exponent_nxt = max_exponent - 14;
        end
    else if (Sub_mantissa[8] == 1) begin
        Sub2_mantissa_nxt = Sub_mantissa << 16;
        max2_exponent_nxt = max_exponent - 15;
        end
    else if (Sub_mantissa[7] == 1) begin
        Sub2_mantissa_nxt = Sub_mantissa << 17;
        max2_exponent_nxt = max_exponent - 16;
        end
    else if (Sub_mantissa[6] == 1) begin
        Sub2_mantissa_nxt = Sub_mantissa << 18;
        max2_exponent_nxt = max_exponent - 17;
        end
    else if (Sub_mantissa[5] == 1) begin
        Sub2_mantissa_nxt = Sub_mantissa << 19;
        max2_exponent_nxt = max_exponent - 18;
        end
    else if (Sub_mantissa[4] == 1) begin
        Sub2_mantissa_nxt = Sub_mantissa << 20;
        max2_exponent_nxt = max_exponent - 19;
        end
    else if (Sub_mantissa[3] == 1) begin
        Sub2_mantissa_nxt = Sub_mantissa << 21;
        max2_exponent_nxt = max_exponent - 20;
        end
    else if (Sub_mantissa[2] == 1) begin
        Sub2_mantissa_nxt = Sub_mantissa << 22;
        max2_exponent_nxt = max_exponent - 21;
        end
    else if (Sub_mantissa[1] == 1) begin
        Sub2_mantissa_nxt = Sub_mantissa << 23;
        max2_exponent_nxt = max_exponent - 22;
        end
    else begin
        Sub2_mantissa_nxt = Sub_mantissa << 24;
        max2_exponent_nxt = max_exponent - 23;
        end
            

    //Dokonczyc nrmalizacje
    NumOut_nxt = {1'b0, max2_exponent, Sub2_mantissa[23:1]};
    end
endmodule
//////////////////////////////////////////////////////////////////////////////////
