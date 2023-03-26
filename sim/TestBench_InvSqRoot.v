`timescale 1ns / 1ps

//Ports and Register + Params
//////////////////////////////////////////////////////////////////////////////////
module TestBench_InvSqRoot;

reg clk;
reg rst = 0;
reg [31:0] DataIn;
wire [31:0] DataOut;
//////////////////////////////////////////////////////////////////////////////////

// Instantiate the InvertSQRoot module.
//////////////////////////////////////////////////////////////////////////////////
InvertSQRoot InvertSQRoot(
.DataOut(DataOut),

.clk(clk),
.rst(rst),
.DataIn(DataIn)
);
//////////////////////////////////////////////////////////////////////////////////

//Generate CLK
//////////////////////////////////////////////////////////////////////////////////
always begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
    end
    
//////////////////////////////////////////////////////////////////////////////////

//Command window
//////////////////////////////////////////////////////////////////////////////////
initial begin
    $display("Start simulation of InvertSQRoot");
    #20
    DataIn = 32'h3dcccccd; // 0.1
    #20
    $display("Warto�� wej�ciowa: %h, Warto�� wyj�ciowa: %h", DataIn, DataOut);
    DataIn = 32'h3f000000; // 0.5
    #20
    $display("Warto�� wej�ciowa: %h, Warto�� wyj�ciowa: %h", DataIn, DataOut);
    DataIn = 32'h3f800000; // 1
    #10;
    $display("Warto�� wej�ciowa: %h, Warto�� wyj�ciowa: %h", DataIn, DataOut);
    $display("Simulation is over, check the waveforms.");
    $stop;
    end
//////////////////////////////////////////////////////////////////////////////////

endmodule