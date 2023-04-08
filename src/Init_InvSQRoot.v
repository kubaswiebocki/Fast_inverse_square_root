`timescale 1ns / 1ps

//Conncet and Register + Params
//////////////////////////////////////////////////////////////////////////////////
module Init_InvSQRoot(
    output reg [31:0] DataOut,
    output reg [31:0] Half_DataIN,
    
    input wire [31:0] DataIn,
    input wire clk,
    input wire rst
    );
    
reg [31:0] Half_DataIN_nxt;
reg [31:0] DataOut_nxt;

reg [22:0] mantissa, mantissa_nxt;
reg [7:0]  exponent, exponent_nxt;

reg [31:0] one_and_half = 32'b0;
  
localparam  MAGIC = 32'h5f3759df;

//////////////////////////////////////////////////////////////////////////////////

//Zegar
//////////////////////////////////////////////////////////////////////////////////
always@ (posedge clk) begin
    if(rst) begin
        DataOut <= 0;
        end
    else begin
        DataOut <= DataOut_nxt;
        Half_DataIN <= Half_DataIN_nxt;
        
        mantissa <= mantissa_nxt;
        exponent <= exponent_nxt;
        end
    end
//////////////////////////////////////////////////////////////////////////////////

//Algorytm InverSQRoot
//////////////////////////////////////////////////////////////////////////////////
always@* begin
// create DataIN * 0.5
    mantissa_nxt = DataIn[22:0];
    exponent_nxt = DataIn[30:23] - 8'b0000_0001;
    Half_DataIN_nxt = {1'b0, exponent, mantissa};
    
// create the 1.5 constant
    one_and_half[31] = 0; // sign bit
    one_and_half[30:23] = 8'b01111111; // exponent
    one_and_half[22:0] = 23'b10000000000000000000000; // mantissa (1.5 in binary)
    
//What the fuck
    DataOut_nxt = MAGIC - (DataIn >> 1);
end
//////////////////////////////////////////////////////////////////////////////////
endmodule