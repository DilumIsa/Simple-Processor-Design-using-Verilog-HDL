// Computer Architecture (CO224) - Lab 05
// Design: Testbench of Integrated CPU of Simple Processor
// Author: Kisaru Liyanage
`timescale 1ns/100ps
`include "cpu.v"
`include "Data_memory_Lab_06P2.v"
`include "Data_Cache.v"

module cpu_tb;

    reg CLK, RESET;
    wire [31:0] PC;
    wire [31:0] INSTRUCTION;

    // Wire connections of the CPU
	wire CPU_READ;
    wire CPU_WRITE;
    wire CPU_BUSYWAIT;
	wire [7:0] CPU_ADDRESS;
    wire [7:0] CPU_WRITEDATA;
    wire [7:0] CPU_READDATA;

    // wire connections of the Data Memory
	wire DM_READ;
    wire DM_WRITE;
    wire DM_BUSYWAIT;
	wire [31:0] DM_WRITEDATA;
    wire [31:0] DM_READDATA;
	wire [5:0] DM_ADDRESS;
    
    /* 
    ------------------------
     SIMPLE INSTRUCTION MEM
    ------------------------
    */
    
    // TODO: Initialize an array of registers (8x1024) named 'instr_mem' to be used as instruction memory
	reg [7:0] instr_mem [1023:0];
    
    // TODO: Create combinational logic to support CPU instruction fetching, given the Program Counter(PC) value 
    //       (make sure you include the delay for instruction fetching here)
	assign #2 INSTRUCTION = {instr_mem[PC+3], instr_mem[PC+2], instr_mem[PC+1], instr_mem[PC]};
    
    initial
    begin
        // Initialize instruction memory with the set of instructions you need execute on CPU
        
        // METHOD 1: manually loading instructions to instr_mem
        //{instr_mem[10'd3], instr_mem[10'd2], instr_mem[10'd1], instr_mem[10'd0]} = 32'b00000000000001000000000000000101;
        //{instr_mem[10'd7], instr_mem[10'd6], instr_mem[10'd5], instr_mem[10'd4]} = 32'b00000000000000100000000000001001;
        //{instr_mem[10'd11], instr_mem[10'd10], instr_mem[10'd9], instr_mem[10'd8]} = 32'b00000010000001100000010000000010;
        
        // METHOD 2: loading instr_mem content from instr_mem.mem file
        $readmemb("instr_mem.mem", instr_mem);
    end
	
	
	/*
	------------
	DATA MEMORY
	------------
    */
	data_memory my_datamem(CLK, RESET, DM_READ, DM_WRITE, DM_ADDRESS, DM_WRITEDATA, DM_READDATA, DM_BUSYWAIT);
	
	/*
	------------
	DATA CACHE
	------------
    */
	data_cache my_datacache (CLK, RESET, CPU_READ, CPU_WRITE, CPU_ADDRESS, CPU_WRITEDATA, CPU_READDATA, CPU_BUSYWAIT, DM_READ, DM_WRITE, DM_ADDRESS, DM_WRITEDATA, DM_READDATA, DM_BUSYWAIT);
	
    /* 
    -----
     CPU
    -----
    */
    cpu mycpu(PC, INSTRUCTION, CLK, RESET, CPU_READ, CPU_WRITE, CPU_ADDRESS, CPU_WRITEDATA, CPU_READDATA, CPU_BUSYWAIT);


/* START DEBUGGING CODE*/
    initial 
    begin 
    // monitor changes in reg file content and print (used to check whether the CPU is running properly)
    #5;
    $display("\n\t\t\t==================================================");
    $display("\t\t\t Change of register Content Starting from Time #5");
    $display("\t\t\t==================================================\n");
    $display("\t\ttime\treg0\treg1\treg2\treg3\treg4\treg5\treg6\treg7");
    $display("\t\t----------------------------------------------------------------------");
    $monitor($time, "\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d", mycpu.my_reg.REGISTER[0], mycpu.my_reg.REGISTER[1], mycpu.my_reg.REGISTER[2], mycpu.my_reg.REGISTER[3], mycpu.my_reg.REGISTER[4], mycpu.my_reg.REGISTER[5], mycpu.my_reg.REGISTER[6], mycpu.my_reg.REGISTER[7]);
    end


    initial
    begin
    
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("cpu_wavedata_new.vcd");
		$dumpvars(0, cpu_tb);
        
        CLK = 1'b0;
        RESET = 1'b1;
        
        // TODO: Reset the CPU (by giving a pulse to RESET signal) to start the program execution
		#5
		RESET = 1'b0;
        
        // finish simulation after some time
        #1000
        $finish;
        
    end
    
    // clock signal generation
    always
        #4 CLK = ~CLK;
        

endmodule