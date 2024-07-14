// Computer Architecture (CO224) - Lab 05 Part-1
// Design: ALU of Simple Processor
// Group: Group-49 
// Reg. No.: E/19/038 and E/19/256

`include "add.v"
`include"forward.v"
`include "and.v"
`include "or.v"

// Module for ALU
module alu(DATA1, DATA2, RESULT, SELECT, ZERO);
	
	input [7:0] DATA1;       // Input port for DATA1, an 8-bit vector.
    input [7:0] DATA2;       // Input port for DATA2, an 8-bit vector.
    input [2:0] SELECT;      // Input port for SELECT, a 3-bit vector.
    output reg [7:0] RESULT; // Output port for RESULT, an 8-bit vector.
	output ZERO;             // Output port for ZERO
	
    // Internal signals for functional units
	wire [7:0] forwardOut; // Internal register to hold the result for the FORWARD operation.
	wire [7:0] addOut;     // Internal register to hold the result for the ADD operation.
	wire [7:0] andOut;     // Internal register to hold the result for the AND operation.
	wire [7:0] orOut;      // Internal register to hold the result for the OR operation.
	
	
	// Instantiation of functional unit modules
	FORWARD forwardUnit(DATA2, forwardOut); // Instantiate FORWARD unit
	ADD addUnit(DATA1, DATA2, addOut);      // Instantiate ADD unit
	AND andUnit(DATA1, DATA2, andOut);      // Instantiate AND unit
	OR orUnit(DATA1, DATA2, orOut);         // Instantiate OR unit
	
	
    // Output selection using a MUX
	//One of the functional units' results is sent to the RESULT output based on the SELECT value
	always @* //(forwardOut, addOut, andOut, orOut, SELECT)	
	begin
		case (SELECT)
			3'b000 :	RESULT = forwardOut;	// If SELECT is 000, output forward_result.
			3'b001 :	RESULT = addOut;		// If SELECT is 001, output add_result.
			3'b010 :	RESULT = andOut;		// If SELECT is 010, output and_result.
			3'b011 :	RESULT = orOut;			// If SELECT is 011, output or_result.
			
		endcase
	end

	//This section of the ALU contains the combinational logic to generate the ZERO output
	assign ZERO = ~(RESULT[0] | RESULT[1] | RESULT[2] | RESULT[3] | RESULT[4] | RESULT[5] | RESULT[6] | RESULT[7]);

		
endmodule
