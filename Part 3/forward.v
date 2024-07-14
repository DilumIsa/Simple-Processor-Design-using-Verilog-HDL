// Computer Architecture (CO224) - Lab 05 Part-1
// Design: FORWARD module
// Group: Group-49 
// Reg. No.: E/19/038 and E/19/256


// Module for FORWARD unit
module FORWARD(DATA, RESULT);

	input [7:0] DATA;    // Input data for addition
	output [7:0] RESULT;  // Output result for addition
	
	//Assigns the value of DATA to RESULT after a delay of 1 time unit
	assign #1 RESULT = DATA;

endmodule
