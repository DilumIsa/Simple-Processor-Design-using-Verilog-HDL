// Computer Architecture (CO224) - Lab 05 Part-1
// Design: ADD module
// Group: Group-49 
// Reg. No.: E/19/038 and E/19/256
`timescale 1ns/100ps

// Module for ADD unit
module ADD(DATA1, DATA2, RESULT);

	input [7:0] DATA1;    // Input data 1 for addition
    input [7:0] DATA2;    // Input data 2 for addition
	output [7:0] RESULT;  // Output result for addition
	
	//Assigns evaluated addition of DATA1 and DATA2 to RESULT after 2 time unit delay
	assign #2 RESULT = DATA1 + DATA2;
	
endmodule
