`timescale 1ns / 1ps

//Ports and Register + Params
//////////////////////////////////////////////////////////////////////////////////
module TestBench_InvSqRoot;

reg clk;
reg rst = 0;
reg [31:0] DataIn;
wire [31:0] DataOut;

real input_value = 0.5;
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
    DataIn = 32'h3f000000; // 0.5
    #100
    DataOut_real =(2**(DataOut[30:23]-127))*($itor({1'b1,DataOut[22:0]})/2**23)*((-1)**(DataOut[31]));
    $display("Wartoœæ wejœciowa: %h, Wartoœæ wyjœciowa: %f", DataIn, DataOut_real);
    #10
    DataIn = 32'h3efff2e5; // 0.4999
    #100
    DataOut_real =(2**(DataOut[30:23]-127))*($itor({1'b1,DataOut[22:0]})/2**23)*((-1)**(DataOut[31]));
    $display("Wartoœæ wejœciowa: %h, Wartoœæ wyjœciowa: %f", DataIn, DataOut_real);
    #10
    DataIn = 32'h3e75c28f; // 0.24
    #100
    DataOut_real =(2**(DataOut[30:23]-127))*($itor({1'b1,DataOut[22:0]})/2**23)*((-1)**(DataOut[31]));
    $display("Wartoœæ wejœciowa: %h, Wartoœæ wyjœciowa: %f", DataIn, DataOut_real);
    $display("Simulation is over, check the waveforms.");
    $stop;
    end
//////////////////////////////////////////////////////////////////////////////////

endmodule