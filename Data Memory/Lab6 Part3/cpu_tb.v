// Computer Architecture (CO224) - Lab 05
// Design: Testbench of Integrated CPU of Simple Processor
// Author: Kisaru Liyanage
`include "Data_Cache.v"
`include "Instruction_Cache.v"
`include "Instruction memory for Lab 6 Part 3.v"
`include "Data_memory_Lab_06P2.v"
`include "cpu.v"

`timescale 1ns/100ps

module cpu_tb;

    reg CLK, RESET;
	
    wire [31:0] PC;
    wire [31:0] INSTRUCTION;
	
	wire CPU_READ, CPU_WRITE, CPU_BUSYWAIT;
	wire DM_READ, DM_WRITE, DM_BUSYWAIT;
	
	wire [7:0] CPU_ADDRESS, CPU_WRITEDATA, CPU_READDATA;
	wire [31:0] DM_WRITEDATA, DM_READDATA;
	wire [5:0] DM_ADDRESS;
	
	wire INSTR_BUSYWAIT;
	
	wire IM_READ, IM_BUSYWAIT;
	wire [5:0] IM_ADDRESS;
	wire [127:0] IM_INSTR;
	

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
	------------------
	INSTRUCTION CACHE
	------------------
    */
	icache my_icache(CLK, RESET, PC[9:0], INSTRUCTION, INSTR_BUSYWAIT, IM_READ, IM_ADDRESS, IM_INSTR, IM_BUSYWAIT);
	
	/*
	------------------
	INSTRUCTION MEMORY
	------------------
    */
	instruction_memory my_imemory(CLK, IM_READ, IM_ADDRESS, IM_INSTR, IM_BUSYWAIT);
	
    /* 
    -----
     CPU
    -----
    */
    cpu mycpu(PC, INSTRUCTION, CLK, RESET, CPU_READ, CPU_WRITE, CPU_ADDRESS, CPU_WRITEDATA, CPU_READDATA, CPU_BUSYWAIT, INSTR_BUSYWAIT);


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
        $dumpfile("cpu_wavedata.vcd");
		$dumpvars(0, cpu_tb);
        
        CLK = 1'b0;
        RESET = 1'b1;
        
        // TODO: Reset the CPU (by giving a pulse to RESET signal) to start the program execution
		#5
		RESET = 1'b0;
        
        // finish simulation after some time
        #5000
        $finish;
        
    end
    
    // clock signal generation
    always
        #4 CLK = ~CLK;
        

endmodule