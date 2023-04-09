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
real DataOut_real;
   
//Command window
//////////////////////////////////////////////////////////////////////////////////
initial begin
    $display("Start simulation of InvertSQRoot");
    DataIn = 32'h3dcccccd; // 0.1
    DataOut_real = DataOut;
    $display("Wartoœæ wejœciowa: %h, Wartoœæ wyjœciowa: %f", DataIn, DataOut_real);
    #200
    DataIn = 32'h3efae148; // 0.49
    DataOut_real = DataOut[22:0];
    $display("Wartoœæ wejœciowa: %h, Wartoœæ wyjœciowa: %f", DataIn, DataOut_real);
    #200
    DataIn = 32'h3f800000; // 1
    DataOut_real = DataOut[22:0];
    $display("Wartoœæ wejœciowa: %h, Wartoœæ wyjœciowa: %f", DataIn, DataOut_real);
    $display("Simulation is over, check the waveforms.");
    $stop;
    end
//////////////////////////////////////////////////////////////////////////////////

endmodule