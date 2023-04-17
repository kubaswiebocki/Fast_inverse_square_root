`timescale 1ns / 1ps

//Ports and Register + Params
//////////////////////////////////////////////////////////////////////////////////
module TestBench_InvSqRoot;

localparam Samples = 1000;

reg clk, rst=0, ce=1;
reg [31:0] DataIn;
wire [31:0] DataOut;
wire DataValid;

reg [31:0] memory [0:Samples-1];
reg [31:0] inputs_data [0:Samples-1], verilog_outputs [0:Samples-1], c_outputs [0:Samples-1];
reg [31:0] input_data, c_output, verilog_output, div;
integer i, file_handle, stop;
// Compare results from verilog algortihm with C 
//////////////////////////////////////////////////////////////////////////////////
// input input_file, input verilog_output_file, input c_output_file
task compare_data();
    begin
        $readmemb("InputData.mem", inputs_data);
        $readmemh("OutputData.mem", verilog_outputs);
        $readmemh("Output_C_data.mem", c_outputs);
        $display("Start comparing...");
        for (i=0; i<Samples; i=i+1) begin
            input_data = inputs_data[i];
            c_output = c_outputs[i];
            verilog_output = verilog_outputs[i];
            div = (verilog_output > c_output) ? verilog_output - c_output: c_output - verilog_output;
            if(div > 2) begin
                $display("%d. Different outputs for %h, C output: %h, Verilog output: %h, Difference: %h", i, input_data, c_output, verilog_output, div);
            end
            #10;
        end
        $display("Comparison done...");
    end
endtask
//////////////////////////////////////////////////////////////////////////////////

// Instantiate the InvertSQRoot module.
//////////////////////////////////////////////////////////////////////////////////
InvertSQRoot InvertSQRoot(
.DataOut(DataOut),
.DataValid(DataValid),

.clk(clk),
.rst(rst),
.ce(ce),
.DataIn(DataIn)
);
//////////////////////////////////////////////////////////////////////////////////

//Generate CLK
//////////////////////////////////////////////////////////////////////////////////
always begin
    clk = 1'b0; #5;
    clk = 1'b1; #5;
    end
always begin
    ce = 1'b1; #600;
    ce = 1'b0; #600;
    end

//////////////////////////////////////////////////////////////////////////////////

always begin
    #10; 
    if(DataValid && !stop && ce) $fwriteh(file_handle, "%h\n", DataOut);
    end
//////////////////////////////////////////////////////////////////////////////////
initial begin
    stop = 0;
    file_handle = $fopen("OutputData.mem", "wb");
    $display("OutputData has been opened!");
    
    $readmemb("InputData.mem", memory);
    $display("Reading InputData...");

    for (i=0; i<Samples; i=i+1) begin
        if(ce) begin
            DataIn = memory[i];
        end
        else begin
            i = i - 1;
        end
        #10;
        end
 
    $display("Reading completed!");
    
    #100; $fclose(file_handle);
    $display("OutputData has been closed!");
    stop = 1;
    compare_data();
    $stop;
    end
//////////////////////////////////////////////////////////////////////////////////
    
endmodule