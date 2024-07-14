// Computer Architecture (CO224) - Lab 05 Part-1
// Design: ALU of Simple Processor
// Group: Group-49 
// Reg. No.: E/19/038 and E/19/256

`include "add.v"
`include"forward.v"
`include "and.v"
`include "or.v"
`include "multi.v"
`include "shift_modules.v"

// Module for ALU
module alu(DATA1, DATA2, RESULT, SELECT, ZERO, RSC);
	
	input [7:0] DATA1;       // Input port for DATA1, an 8-bit vector.
    input [7:0] DATA2;       // Input port for DATA2, an 8-bit vector.
    input [2:0] SELECT;      // Input port for SELECT, a 3-bit vector.
	input [1:0] RSC;         // Input port for RSC, a 2-bit vector.
    output reg [7:0] RESULT; // Output port for RESULT, an 8-bit vector.
	output ZERO;             // Output port for ZERO
	
    // Internal signals for functional units
	wire [7:0] forwardOut; // Internal register to hold the result for the FORWARD operation.
	wire [7:0] addOut;     // Internal register to hold the result for the ADD operation.
	wire [7:0] andOut;     // Internal register to hold the result for the AND operation.
	wire [7:0] orOut;      // Internal register to hold the result for the OR operation.
	wire [7:0] multiOut;   // Internal register to hold the result for the MULTIPLY operation.
	wire [7:0] LshiftOut;  // Internal register to hold the result for the Left Shifting operation.
	wire [7:0] RshiftOut;  // Internal register to hold the result for the Right Shifting operation.
	
	
	// Instantiation of functional unit modules
	FORWARD forwardUnit(DATA2, forwardOut);               // Instantiate FORWARD unit
	ADD addUnit(DATA1, DATA2, addOut);                    // Instantiate ADD unit
	AND andUnit(DATA1, DATA2, andOut);                    // Instantiate AND unit
	OR orUnit(DATA1, DATA2, orOut);                       // Instantiate OR unit
	MULTI multiUnit(DATA1, DATA2, multiOut);              // Instantiate MULTI unit
	LEFT_SHIFT lshiftUnit(DATA1, DATA2, LshiftOut);       // Instantiate LEFT_SHIFT unit
	RIGHT_SHIFT rshiftUnit(DATA1, DATA2, RshiftOut, RSC); // Instantiate RIGHT_SHIFT unit
	
	
    // Output selection using a MUX
	//One of the functional units' results is sent to the RESULT output based on the SELECT value
	always @* //(forwardOut, addOut, andOut, orOut, SELECT)	
	begin
		case (SELECT)
			3'b000 :	RESULT = forwardOut;	// If SELECT is 000, output forward_result.
			3'b001 :	RESULT = addOut;		// If SELECT is 001, output add_result.
			3'b010 :	RESULT = andOut;		// If SELECT is 010, output and_result.
			3'b011 :	RESULT = orOut;			// If SELECT is 011, output or_result.	
			3'b100 :	RESULT = multiOut;		// If SELECT is 011, output multiply_result.
			3'b101 :	RESULT = LshiftOut;		// If SELECT is 101, output left shifting_result.
			3'b110 :	RESULT = RshiftOut;		// If SELECT is 110, output Right shifting_result.

		endcase
	end

	//This section of the ALU contains the combinational logic to generate the ZERO output
	assign ZERO = ~(RESULT[0] | RESULT[1] | RESULT[2] | RESULT[3] | RESULT[4] | RESULT[5] | RESULT[6] | RESULT[7]);

		
endmodule
