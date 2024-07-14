
// E19205, E19210
// Group 32

//The AND functional unit performs the logical AND operation on the two 8-bit numbers given in DATA1 and DATA2 and sends the answer to the RESULT output
//Contains a delay of 1 time unit
module AND(DATA1, DATA2, RESULT);

	//Input port declaration
	input [7:0] DATA1, DATA2;
	
	//Declaration of output port
	output [7:0] RESULT;
	
	//Assigns logical AND result of DATA1 and DATA2 to RESULT after 1 time unit delay
	assign #1 RESULT = DATA1 & DATA2;
	
endmodule
