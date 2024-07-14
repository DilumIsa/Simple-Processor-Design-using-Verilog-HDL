// Computer Architecture (CO224) - Lab 05 Part-2
// Design: Register File of Simple Processor
// Group: Group-49 
// Reg. No.: E/19/038 and E/19/256
`timescale 1ns/100ps

//Module for Register File
module reg_file(IN,OUT1,OUT2,INADDRESS,OUT1ADDRESS,OUT2ADDRESS, WRITE, CLK, RESET);

	input[7:0] IN;                // Input data
    output [7:0] OUT1;            // Output data 1
    output [7:0] OUT2;            // Output data 2
    input[2:0] INADDRESS;         // Input address 
    input[2:0] OUT1ADDRESS;       // Output 1 address 
    input[2:0] OUT2ADDRESS;       // Output 2 address 
    input WRITE;                  // Write control signal
    input CLK;                    // Clock signal
    input RESET;                  // Reset control signal
	
    // Declaration of register file by using 8 element array of 8 bit registers
	reg [7:0] REGISTER [7:0];

	//Iterator variable used in for loop
	integer i;
	
	// These assign statements are executed asynchronously (data transmitted concurrently).
    // There are artificial delays of two time units for register reading.
	assign #2 OUT1 = REGISTER[OUT1ADDRESS];		// Assigning output 1 from register file
	assign #2 OUT2 = REGISTER[OUT2ADDRESS];		// Assigning output 2 from register file
	
	
	// This block is works in synchronous manner 
    // this is work during the rising edge of the clock pulse.
	always @ (posedge CLK)
	begin
		if (RESET == 1'b1)		//If the RESET signal is HIGH, registers must be cleared
		begin
		
			#1 // Artificial delay of one time unit for resetting
            for (i = 0; i < 8; i = i + 1)			//For loop to iterate over all 8 register addresses after 1 time unit delay
			begin
				REGISTER[i] = 8'b00000000;		//Setting each element of the REGISTER array to 0
			end
			
		end
		else if (WRITE == 1'b1)			// The else condition handles data transfer when WRITE is high.
                                        // It transfers data from the input IN to the register specified by the address INADDRESS.
		begin
			#1 // Artificial delays of one time units for register writing
            REGISTER[INADDRESS] = IN;		//Assigns the input value IN to relevant register address 
		end
	end
	
	
		initial begin
			$monitor($time, "\t%d\t%d", OUT1,OUT2);
		end

endmodule