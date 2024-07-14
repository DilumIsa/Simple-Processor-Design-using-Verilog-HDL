// Computer Architecture (CO224) - Lab 05 Part-2
// Design: Testbench-Register File of Simple Processor
// Author: Kisaru Liyanage
// Group: Group-49 
// Edited by: E/19/256 and E/19/038

`timescale 1ns / 1ns    
`include "reg_file.v"     // Including the reg_file module

module reg_file_tb;

    reg [7:0] WRITEDATA;    // Data to be written to register file
    reg [2:0] WRITEREG, READREG1, READREG2;   // Write and read register addresses
    reg CLK, RESET, WRITEENABLE;   // Clock, reset, and write enable signals
    wire [7:0] REGOUT1, REGOUT2;   // Output data from register file

    // Instantiation of the reg_file module
    reg_file myregfile(     
        WRITEDATA,          // Input data
        REGOUT1, REGOUT2,   // Output data
        WRITEREG,           // Input address for writing
        READREG1, READREG2, // Input addresses for reading
        WRITEENABLE,        // Write enable signal
        CLK, RESET          // Clock and reset signals
    );
       
    initial begin
        CLK = 1'b1;  // Initial value for clock
        
        $dumpfile("reg_file_wavedata.vcd"); // Create VCD file for waveform dumping
        $dumpvars(0, reg_file_tb); // Dump variables for waveform
        
        // assign values with time to input signals to see output 
        RESET = 1'b0;  
        
        WRITEENABLE = 1'b0; 
        
        #4  
        
        RESET = 1'b1;   
        READREG1 = 3'd0;    
        READREG2 = 3'd4;    
        
        #6   
        
        RESET = 1'b0;   
        
        #2   
        WRITEREG = 3'd2;   
        WRITEDATA = 8'd95;  
        WRITEENABLE = 1'b1;
        
        #7   
        WRITEENABLE = 1'b0;
        
        #1   
        READREG1 = 3'd2;   
        
        #7  
        WRITEREG = 3'd1;    
        WRITEDATA = 8'd28;
        WRITEENABLE = 1'b1; 
        READREG1 = 3'd1;    
        
        #8   
        WRITEENABLE = 1'b0; 
        
        #8   
        WRITEREG = 3'd4;   
        WRITEDATA = 8'd6;   
        WRITEENABLE = 1'b1; 
        
        #8   
        WRITEDATA = 8'd15; 
        WRITEENABLE = 1'b1; 
        
        #10  
        WRITEENABLE = 1'b0; 
        
        #6   
        WRITEREG = -3'd1; 
        WRITEDATA = 8'd50;  
        WRITEENABLE = 1'b1; 
        
        #5  
        WRITEENABLE = 1'b0; 
        
        #10  
        $finish;    
    end
    
    // Clock signal generation
    always
        #4 CLK = ~CLK; 
endmodule
