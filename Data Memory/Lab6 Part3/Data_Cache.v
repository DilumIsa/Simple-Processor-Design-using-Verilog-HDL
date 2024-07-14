/*
Module  : Data Cache 
Author  : Isuru Nawinne, Kisaru Liyanage
Date    : 25/05/2020

Description	:

This file presents a skeleton implementation of the cache controller using a Finite State Machine model. Note that this code is not complete.
*/
`timescale 1ns/100ps
module data_cache(clock, reset, read, write, address, cpu_writeData, cpu_readData, busywait,mem_read, mem_write, mem_address, mem_writedata, mem_readdata, mem_busywait);
    
	//Port declaration for clock and reset
	input clock, reset;
	
	//Port Declaration for CPU side
	input read, write;
	input [7:0] address;
	input [7:0] cpu_writeData;
	
	output reg busywait;
	output reg [7:0] cpu_readData;
	
	
	//Port declaration for Data Memory side
	input mem_busywait;
	input [31:0] mem_readdata;
	
	output reg mem_read, mem_write;
	output reg [5:0] mem_address;
	output reg [31:0] mem_writedata;
	
	
	//Cache Storage
	reg [31:0] cache_block_array [7:0];
	reg tag_array [7:0];
	reg valid_array [7:0];
	reg dirty_array [7:0];
	
	
	//Variables for indexing
	wire [2:0] tag, index;
	wire [1:0] offset;
	
	wire [31:0] cache_block;
	wire [2:0] cache_tag;
	wire valid, dirty;

	//Variables for hit detection
	wire tagMatch, hit;
	
	//Variables for synchronous data writing
	reg cacheWrite;
	
	//Assert busywait signal when read or write control signals are set
	always @ (read, write) 
	begin
		busywait = (read || write)? 1:0;
		
		if (write)	cacheWrite = 1;
	end
	
	//Separating relevant portions of address
	assign {tag, index, offset} = address;
	
	//Indexing
	assign #1 cache_block = cache_block_array[index];
	assign #1 cache_tag = tag_array[index];
	assign #1 valid = valid_array[index];
	assign #1 dirty = dirty_array[index];
	
	
	//Tag Comparison
	assign #0.9 tagMatch = (tag == cache_tag)? 1:0;
	
	//Hit detection
	assign hit = (tagMatch && valid);
	
	
	//Data word selection for read hit
	always @ (*)
	begin
		case (offset)
		
			2'b00 :		cpu_readData = cache_block[7:0];
			
			2'b01 :		cpu_readData = cache_block[15:8];
			
			2'b10 :		cpu_readData = cache_block[23:16];
			
			2'b11 :		cpu_readData = cache_block[31:24];
			
		endcase
	end
	
	//De-assert busywait when hit is detected
	always @ (clock) if (hit) busywait = 0;
	
	
	//Synchronous writing upon write hit
	always @ (posedge clock)
	begin
		if (cacheWrite && hit)
		begin
			case (offset)
				2'b00 :		cache_block_array[index][7:0] = cpu_writeData;
				
				2'b01 :		cache_block_array[index][15:8] = cpu_writeData;
				
				2'b10 :		cache_block_array[index][23:16] = cpu_writeData;
				
				2'b11 :		cache_block_array[index][31:24] = cpu_writeData;
			endcase
			
			dirty_array[index] = 1;		//Set dirty bit after writing to cache
			cacheWrite = 0;
		end
	end
	
    
	
	
    /* Cache Controller FSM Start */

    parameter IDLE = 3'b000, MEM_READ = 3'b001, MEM_WRITE = 3'b010;
    reg [2:0] state, next_state;

    // combinational next state logic
    always @(*)
    begin
        case (state)
            IDLE:
                if ((read || write) && !dirty && !hit)  
                    next_state = MEM_READ;
                else if ((read || write) && dirty && !hit)
                    next_state = MEM_WRITE;
                else
                    next_state = IDLE;
            
            MEM_READ:
                if (!mem_busywait)
                    next_state = IDLE;
                else    
                    next_state = MEM_READ;
					
			MEM_WRITE:
                if (!mem_busywait)
                    next_state = MEM_READ;
                else    
                    next_state = MEM_WRITE;
            
        endcase
    end

    // combinational output logic
    always @(*)
    begin
        case(state)
            IDLE:
            begin
                mem_read = 0;
                mem_write = 0;
                mem_address = 8'dx;
                mem_writedata = 8'dx;
                //busywait = 0;
            end
         
            MEM_READ: 
            begin
                mem_read = 1;
                mem_write = 0;
                mem_address = {tag, index};
                mem_writedata = 32'dx;
                busywait = 1;
				
				
				//Loading data to cache once data memory busywait is de-asserted
				#1
				if (!mem_busywait)
				begin
					cache_block_array[index] = mem_readdata;
					tag_array[index] = tag;
					valid_array[index] = 1;
				end
            end
			
			MEM_WRITE: 
            begin
                mem_read = 0;
                mem_write = 1;
                mem_address = {cache_tag, index};
                mem_writedata = cache_block;
                busywait = 1;
				
				//Set dirty bit to zero after writing to data memory
				if (!mem_busywait)
				begin
					dirty_array[index] = 0;
				end
            end
            
        endcase
    end


	integer i;
    // sequential logic for state transitioning 
    always @(posedge clock, reset)
    begin
        if(reset)
		begin
            state = IDLE;
			
			for (i = 0; i < 8; i=i+1)
			begin
				valid_array[i] = 0;
				dirty_array[i] = 0;
			end
		end	
        else
            state = next_state;
    end

    /* Cache Controller FSM End */

endmodule