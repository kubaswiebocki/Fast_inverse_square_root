`timescale 1ns / 1ps

//Registers
//////////////////////////////////////////////////////////////////////////////////
module Multiplication(
    input wire clk,
    input wire rst,
    input wire [31:0] Number_1,
    input wire [31:0] Number_2,
    
    output reg [31:0] Product,
    output reg [31:0] Init_data
);

reg [47:0] M_Square, M_Square_nxt;
reg [31:0] Product_nxt, Init_temp;
reg [7:0]  E_Square, E_Square_nxt;
//////////////////////////////////////////////////////////////////////////////////

//Always
//////////////////////////////////////////////////////////////////////////////////
always@ (posedge clk) begin
    if(rst) begin
        Product <= 0;
        end
    else begin
        Product <= Product_nxt;
        E_Square <= E_Square_nxt;
        M_Square <= M_Square_nxt;
        
        Init_temp <= Number_1;
        Init_data <= Init_temp;
        end
    end
//////////////////////////////////////////////////////////////////////////////////

// Mul operations
//////////////////////////////////////////////////////////////////////////////////
always@* begin 
    E_Square_nxt = Number_1[30:23] + Number_2[30:23] - 127;            //Add exps
    M_Square_nxt = ( {1'b1, Number_1[22:0]} * {1'b1, Number_2[22:0]} );//Mul manti
    
    Product_nxt = {1'b0, E_Square + M_Square[47], M_Square[46:24]};    //(Sign) + (Exponent+overflow) + (RoundMatni)
end
//////////////////////////////////////////////////////////////////////////////////

endmodule
//////////////////////////////////////////////////////////////////////////////////
