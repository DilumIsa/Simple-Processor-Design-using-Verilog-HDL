// Computer Architecture (CO224) - Lab 05 Part-2
// Design: Secondary parts (MUX, Twos'complement)
// Group: Group-49 
// Reg. No.: E/19/038 and E/19/256


// Module for Twos'complement
//The twosComp module returns the 2's complement value of the input as the output after a delay of 1 time unit
module twosComp(IN, OUT);

	input [7:0] IN;    // Input
	output [7:0] OUT;  // Output
	
	//Combinational logic to assign two's complement value of input to output after a delay of #1
	assign #1 OUT = ~IN + 1;

endmodule


// Module for MUX unit
//Generic MUX module to be used inside the CPU
//Operation: SELECT == 0 : OUT = IN1
//			 SELECT == 1 : OUT = IN2
//Does not contain delays
module mux(IN1, IN2, SELECT, OUT);

	//Input and output port declaration
	input [7:0] IN1;       // Input DATA
	input [7:0] IN2;       // Input DATA
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