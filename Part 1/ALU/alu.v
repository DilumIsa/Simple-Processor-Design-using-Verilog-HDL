
// E19205, E19210
// Group 32

// DATA1 & DATA2 are inputs.
// SELECT is the xelector that select the operation to be performed
// RESULT gives the output of the operation

module alu(DATA1, DATA2, RESULT, SELECT);
	
	//Declaration of input ports
	input [7:0] DATA1, DATA2;
	input [2:0] SELECT;
	
	//Output port declaration
	output reg [7:0] RESULT;
	
	//Set of wires to get the outputs of each functional unit
	wire [7:0] forwardOut, addOut, andOut, orOut;
	
	
	// Creating the instances of deferent units
	FORWARD forwardUnit(DATA2, forwardOut);
	ADD addUnit(DATA1, DATA2, addOut);
	AND andUnit(DATA1, DATA2, andOut);
	OR orUnit(DATA1, DATA2, orOut);
	
	
	// Implimentation of the selector MUX
	// The selected functionality output will be desplayed
	always @ (forwardOut, addOut, andOut, orOut, SELECT)	// When the value of the any element is changed, It will be displayed
	begin
		case (SELECT)		//Case statement to switch between the outputs

			3'b000 :	RESULT = forwardOut;	//SELECT = 0 : FORWARD
			
			3'b001 :	RESULT = addOut;		//SELECT = 1 : ADD
			
			3'b010 :	RESULT = andOut;		//SELECT = 2 : AND
			
			3'b011 :	RESULT = orOut;			//SELECT = 3 : OR
			
		endcase
	end

	module AND(DATA1, DATA2, RESULT);

	//Input port declaration
	input [7:0] DATA1, DATA2;
	
	//Declaration of output port
	output [7:0] RESULT;
	
	//Assigns logical AND result of DATA1 and DATA2 to RESULT after 1 time unit delay
	assign #1 RESULT = DATA1 & DATA2;
	
endmodule
		
endmodule