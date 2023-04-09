`timescale 1ns / 1ps

module NewtonApprox(
    input wire clk,
    input wire rst,
    input wire [31:0] Data_in1,
    input wire [31:0] Data_in2,
    
    output wire [31:0] Data_out
    );
    
wire [31:0] InitData_1, InitData_2, InitData_3, Data_mul_square, Data_mul_by_1_5, Data_sub, Data_result;

//Mul x2*y
//**********************************************************************//
Multiplication Multiplication_x2_y(
    .clk(clk),
    .rst(rst),
    .Number_1(Data_in1),
    .Number_2(Data_in2),
    
    .Product(Data_mul_by_1_5),
    .Init_data(InitData_1)
    );
    
//Mul x2y*y
//**********************************************************************//
Multiplication Multiplication_x2y_y(
    .clk(clk),
    .rst(rst),
    .Number_1(InitData_1),
    .Number_2(Data_mul_by_1_5),
    
    .Product(Data_mul_square),
    .Init_data(InitData_2)
    );
       
//Substraction 1.5-x2yy
//**********************************************************************//
Substraction Substraction(
    .clk(clk),
    .rst(rst),
    .NumB(Data_mul_square),
    .Init(InitData_2),

    .NumOut(Data_sub),
    .Init_data(InitData_3)
    );
    
//Mul y*rest
//**********************************************************************//
Multiplication Multiplication_y_by_rest(
    .clk(clk),
    .rst(rst),
    .Number_1(InitData_3),
    .Number_2(Data_sub),
    
    .Product(Data_result)
    );
//Assings
//**********************************************************************//
assign Data_out = Data_result;
    
endmodule
