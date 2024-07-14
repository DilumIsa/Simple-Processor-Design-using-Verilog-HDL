// Computer Architecture (CO224) - Lab 05 Part-3,4
// Design: Secondary parts (8 bit MUX, 32 bit MUX, Twos'complement, jump branch Adder, pc Adder, flowControl)
// Group: Group-49 
// Reg. No.: E/19/038 and E/19/256
`timescale 1ns/100ps

// Module for Twos'complement
//The twosComp module returns the 2's complement value of the input as the output after a delay of 1 time unit
module twosComp(IN, OUT);

	input [7:0] IN;    // Input
	output [7:0] OUT;  // Output
	
	//Combinational logic to assign two's complement value of input to output after a delay of #1
	assign #1 OUT = ~IN + 1;

endmodule


//The Jump/Branch Adder calculates the target instruction address by adding the offset value to the PC+4 value
//after sign extension and multiplication by 4
//Contains a delay of 2 time units
module jumpbranchAdder(PC, OFFSET, TARGET);
	
	//Declaration of input and output ports
	input [31:0] PC;
	input [7:0] OFFSET;
	output [31:0] TARGET;
	
	wire [21:0] signBits;		//Bus to store extended sign bits
	
	assign signBits = {22{OFFSET[7]}};	//assigning the sign bit (MSB) of OFFSET to all 22 bits in signBits
	
	//GENERATING TARGET address by adding the OFFSET * 4 to the PC value after a delay of 2 time units
	//First 22 bits contain the extended sign bits, next 8 bits contain the actual offset, the next two bits are zeros due to shifting left by 2 (multiplication by 4)
	assign #2 TARGET = PC + {signBits, OFFSET, 2'b0};	
	
endmodule


//The pcAdder module generates the PC+4 value from the PC input after a delay of 1 time unit
module pcAdder(PC, PCplus4);
	
	//Declaration of input and output ports
	input [31:0] PC;
	output [31:0] PCplus4;

	//Assign PC+4 value to the output after 1 time unit delay
	assign #1 PCplus4 = PC + 4;
	
endmodule


// Module for MUX unit
//Generic MUX module to be used inside the CPU
//Operation: SELECT == 0 : OUT = IN1
//			 SELECT == 1 : OUT = IN2
//Does not contain delays
module mux(IN1, IN2, SELECT, OUT);

	//Input and output port declaration
	input [7:0] IN1;       // Input DATA 1
	input [7:0] IN2;       // Input DATA 2
	input SELECT;          // Input port for SELECT
	output reg [7:0] OUT;  // Output DATA
	
	//MUX should update output value upon change of any of the inputs
	always @ (IN1, IN2, SELECT)
	begin
		if (SELECT == 1'b1)		//If SELECT is HIGH, switch to 2nd input
		begin
			OUT = IN2;
		end
		else					//If SELECT is LOW, switch to 1st input
		begin
			OUT = IN1;
		end
	end

endmodule


//32-bit MUX module for flow control operations
//Operation: SELECT == 0 : OUT = IN1
//			 SELECT == 1 : OUT = IN2
//Does not contain delays
module mux32(IN1, IN2, SELECT, OUT);

	//Input and output port declaration
	input [31:0] IN1, IN2;
	input SELECT;
	output reg [31:0] OUT;
	
	//MUX should update output value upon change of any of the inputs
	always @ (IN1, IN2, SELECT)
	begin
		if (SELECT == 1'b1)		//If SELECT is HIGH, switch to 2nd input
		begin
			OUT = IN2;
		end
		else					//If SELECT is LOW, switch to 1st input
		begin
			OUT = IN1;
		end
	end

endmodule


//Combinational Control Unit for flow control operations
//Operation: JUMP = 0  BRANCH = 0          : OUT = 0 (Normal flow)
//			 JUMP = 1                      : OUT = 1 (Offset flow)
//			 JUMP = 0  BRANCH = 1 ZERO = 0 : OUT = 0 (Normal flow)
//			 JUMP = 0  BRANCH = 1 ZERO = 1 : OUT = 1 (Offset flow)
//Contains no delays
module flowControl(JUMP, BRANCH, ZERO, OUT);

	//Input and output port declaration
	input JUMP, BRANCH, ZERO;
	output OUT;
	
	//Assigns OUT based on values of JUMP, BRANCH and ZERO using simple combinational logic
	assign OUT = JUMP | (BRANCH & ZERO);

endmodule