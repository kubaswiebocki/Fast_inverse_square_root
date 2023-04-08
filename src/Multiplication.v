`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//Multiplication fun
//////////////////////////////////////////////////////////////////////////////////
module Multiplication(
    input wire clk,
    input wire rst,
    input wire [31:0] Num_1,
    input wire [31:0] Num_2,
    
    output reg [31:0] NumOut
);

reg [31:0] NumOut_nxt;
reg [7:0] exp_square, exp_square_nxt, exp_round, exp_round_nxt;
reg [47:0] mantissa_square, mantissa_square_nxt;
reg [22:0] round_square, round_square_nxt;

always@ (posedge clk) begin
    if(rst) begin
        NumOut <= 0;
        end
    else begin
        NumOut <= NumOut_nxt;
        exp_square <= exp_square_nxt;
        exp_round <= exp_round_nxt;
        mantissa_square <= mantissa_square_nxt;
        round_square <= round_square_nxt;
        end
    end

always@* begin // Mul operations
    exp_square_nxt = Num_1[30:23] + Num_2[30:23] - 127; //exponenty
    mantissa_square_nxt = (Num_1[22:0] * Num_2[22:0]); //mantysy
    round_square_nxt = mantissa_square[23:1] >> 1; // zaokr¹glanie mantysy
    exp_round_nxt = exp_square + mantissa_square[24];
    NumOut_nxt = {1'b0, exp_round, round_square};
end

endmodule
//////////////////////////////////////////////////////////////////////////////////
