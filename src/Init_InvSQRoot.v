`timescale 1ns / 1ps

//Conncet and Register + Params
//////////////////////////////////////////////////////////////////////////////////
module Init_InvSQRoot(
    input wire [31:0] DataIn,
    input wire clk,
    input wire rst,
    input wire ce,
    
    output reg [31:0] DataOut,
    output reg [31:0] Half_DataIN,
    output reg ce_out = 1'b1
    );
    
reg [31:0] Half_DataIN_nxt;
reg [31:0] DataOut_nxt;
reg ce_out_nxt;

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
        ce_out <= ce_out_nxt;
        end
    end
//////////////////////////////////////////////////////////////////////////////////

//Algorytm InverSQRoot
//////////////////////////////////////////////////////////////////////////////////
always@* begin
// create DataIN * 0.5
    Half_DataIN_nxt = {1'b0, DataIn[30:23] - 8'b0000_0001, DataIn[22:0]}; //Half is just shifting the exp
    ce_out_nxt = ce;
    
//What the fuck
    if(ce_out) DataOut_nxt = MAGIC - (DataIn >> 1);
    else DataOut_nxt = DataOut;
end
//////////////////////////////////////////////////////////////////////////////////
endmodule