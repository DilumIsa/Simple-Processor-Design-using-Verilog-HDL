
// E19205, E19210
// Group 54


// DATA1 & DATA2 are the inputs.
// Sends the answer to the RESULT 
//Contains a delay of 2 time units
module ADD(DATA1, DATA2, RESULT);

	//Declaration of two 8-bit data inputs
	input [7:0] DATA1, DATA2;
	
	//Declaration of output
	output [7:0] RESULT;
	
	//Assigns evaluated addition of DATA1 and DATA2 to RESULT after 2 time unit delay
	assign #2 RESULT = DATA1 + DATA2;
	
endmodule
