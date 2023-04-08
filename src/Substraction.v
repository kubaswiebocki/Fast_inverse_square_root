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

reg [31:0] Shifted_mantissa, Shifted_mantissa_nxt, Substracted_mantissa, Substracted_mantissa_nxt, NumOut_nxt;
reg [7:0] max_exponent, max_exponent_nxt;

always@ (posedge clk) begin
    if(rst) begin
        NumOut <= 0;
        end
    else begin
        NumOut <= NumOut_nxt;
        Substracted_mantissa <= Substracted_mantissa_nxt;
        Shifted_mantissa <= Shifted_mantissa_nxt;
        max_exponent <= max_exponent_nxt;
        end
    end

always@* begin
    if(NumA[30:23] > NumB[30:23]) begin
        max_exponent_nxt = NumA[30:23];
        Shifted_mantissa_nxt = ({1'b1, NumB[22:0]}) << (NumA[30:23] - NumB[30:23]);
        end
    else begin
        max_exponent_nxt = NumB[30:23];
        Shifted_mantissa_nxt = ({1'b1, NumA[22:0]}) << (NumB[30:23] - NumA[30:23]);
        end
    
    Substracted_mantissa_nxt = {1'b1, NumA[22:0]} - {1'b1, NumB[22:0]};
    //Dokonczyc nrmalizacje
    end
endmodule
//////////////////////////////////////////////////////////////////////////////////
