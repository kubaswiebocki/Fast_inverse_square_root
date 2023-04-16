`timescale 1ns / 1ps

//Ports and Register + Params
//////////////////////////////////////////////////////////////////////////////////
module TestBench_InvSqRoot;

localparam Samples = 1000;

reg clk, rst=0;
reg [31:0] DataIn;
wire [31:0] DataOut;
wire DataValid;

reg [31:0] memory [0:Samples-1], memory_out [0:Samples-1];
integer i, file_handle;


//////////////////////////////////////////////////////////////////////////////////

// Instantiate the InvertSQRoot module.
//////////////////////////////////////////////////////////////////////////////////
InvertSQRoot InvertSQRoot(
.DataOut(DataOut),
.DataValid(DataValid),

.clk(clk),
.rst(rst),
.DataIn(DataIn)
);
//////////////////////////////////////////////////////////////////////////////////

//Generate CLK
//////////////////////////////////////////////////////////////////////////////////
always begin
    clk = 1'b0; #5;
    clk = 1'b1; #5;
    end
//////////////////////////////////////////////////////////////////////////////////

always begin
    #10; 
    if(DataValid) $fwriteh(file_handle, "%b\n", DataOut);
    end
//////////////////////////////////////////////////////////////////////////////////
initial begin
    file_handle= $fopen("OutputData.mem", "wb");
    $display("OutputData has been opened!");
    
    $readmemb("InputData.mem", memory);
    $display("Reading InputData...");
    for (i=0; i<Samples; i=i+1) begin
        DataIn = memory[i];
        #10;
        end
    $display("Reading completed!");
    
    #100; $fclose(file_handle);
    $display("OutputData has been closed!");
    $stop;
    end
//////////////////////////////////////////////////////////////////////////////////
    
endmodule