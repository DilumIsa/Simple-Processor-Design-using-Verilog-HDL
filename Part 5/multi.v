// Computer Architecture (CO224) - Lab 05 Part-5
// Design: MULTI module
// Group: Group-49 
// Reg. No.: E/19/038 and E/19/256

//Module for Multiplication unit
//Calculates the product of two 8-bit numbers
module MULTI(DATA1, DATA2, RESULT);

	//Input and output port declaration
	input [7:0] DATA1;
	input [7:0] DATA2;
	output [7:0] RESULT;
	
	//Carry bits for intermediate sums
	wire carry_0 [5:0];
	wire carry_1 [4:0];
	wire carry_2 [3:0];
	wire carry_3 [2:0];
	wire carry_4 [1:0];
	wire carry_5;
	
	//Intermediate sums
	wire sum0 [5:0];
	wire sum1 [4:0];
	wire sum2 [3:0];
	wire sum3 [2:0];
	wire sum4 [1:0];
	wire sum5;
	
	//Bus to store result before output
	wire [7:0] RESULT_DATA;
	
	//First bit of RESULT_DATA can be directly set
	assign RESULT_DATA[0] = DATA2[0] & DATA1[0];	
	
	
	//Full Adder array to calculate result by shifting and adding
	//Layer 0
	FullAdder FA0_0(DATA2[0] & DATA1[1], DATA2[1] & DATA1[0], 1'b0, RESULT_DATA[1], carry_0[0]);
	FullAdder FA0_1(DATA2[0] & DATA1[2], DATA2[1] & DATA1[1], carry_0[0], sum0[0], carry_0[1]);
	FullAdder FA0_2(DATA2[0] & DATA1[3], DATA2[1] & DATA1[2], carry_0[1], sum0[1], carry_0[2]);
	FullAdder FA0_3(DATA2[0] & DATA1[4], DATA2[1] & DATA1[3], carry_0[2], sum0[2], carry_0[3]);
	FullAdder FA0_4(DATA2[0] & DATA1[5], DATA2[1] & DATA1[4], carry_0[3], sum0[3], carry_0[4]);
	FullAdder FA0_5(DATA2[0] & DATA1[6], DATA2[1] & DATA1[5], carry_0[4], sum0[4], carry_0[5]);
	FullAdder FA0_6(DATA2[0] & DATA1[7], DATA2[1] & DATA1[6], carry_0[5], sum0[5], );
	
	//Layer 1
	FullAdder FA1_0(sum0[0], DATA2[2] & DATA1[0], 1'b0, RESULT_DATA[2], carry_1[0]);
	FullAdder FA1_1(sum0[1], DATA2[2] & DATA1[1], carry_1[0], sum1[0], carry_1[1]);
	FullAdder FA1_2(sum0[2], DATA2[2] & DATA1[2], carry_1[1], sum1[1], carry_1[2]);
	FullAdder FA1_3(sum0[3], DATA2[2] & DATA1[3], carry_1[2], sum1[2], carry_1[3]);
	FullAdder FA1_4(sum0[4], DATA2[2] & DATA1[4], carry_1[3], sum1[3], carry_1[4]);
	FullAdder FA1_5(sum0[5], DATA2[2] & DATA1[5], carry_1[4], sum1[4], );
	
	//Layer 2
	FullAdder FA2_0(sum1[0], DATA2[3] & DATA1[0], 1'b0, RESULT_DATA[3], carry_2[0]);
	FullAdder FA2_1(sum1[1], DATA2[3] & DATA1[1], carry_2[0], sum2[0], carry_2[1]);
	FullAdder FA2_2(sum1[2], DATA2[3] & DATA1[2], carry_2[1], sum2[1], carry_2[2]);
	FullAdder FA2_3(sum1[3], DATA2[3] & DATA1[3], carry_2[2], sum2[2], carry_2[3]);
	FullAdder FA2_4(sum1[4], DATA2[3] & DATA1[4], carry_2[3], sum2[3], );
	
	//Layer 3
	FullAdder FA3_0(sum2[0], DATA2[4] & DATA1[0], 1'b0, RESULT_DATA[4], carry_3[0]);
	FullAdder FA3_1(sum2[1], DATA2[4] & DATA1[1], carry_3[0], sum3[0], carry_3[1]);
	FullAdder FA3_2(sum2[2], DATA2[4] & DATA1[2], carry_3[1], sum3[1], carry_3[2]);
	FullAdder FA3_3(sum2[3], DATA2[4] & DATA1[3], carry_3[2], sum3[2], );
	
	//Layer 4
	FullAdder FA4_0(sum3[0], DATA2[5] & DATA1[0], 1'b0, RESULT_DATA[5], carry_4[0]);
	FullAdder FA4_1(sum3[1], DATA2[5] & DATA1[1], carry_4[0], sum4[0], carry_4[1]);
	FullAdder FA4_2(sum3[2], DATA2[5] & DATA1[2], carry_4[1], sum4[1], );
	
	//Layer 5
	FullAdder FA5_0(sum4[0], DATA2[6] & DATA1[0], 1'b0, RESULT_DATA[6], carry_5);
	FullAdder FA5_1(sum4[1], DATA2[6] & DATA1[1], carry_5, sum5, );
	
	//Layer 6
	FullAdder FA6_0(sum5, DATA2[7] & DATA1[0], 1'b0, RESULT_DATA[7], );
	
	//Sending out result after #3 time unit delay
	//Contains a delay of 3 time units
	assign #3 RESULT = RESULT_DATA;

endmodule

//Full Adder
module FullAdder(A, B, C, SUM, CARRY);

	//Input and output port declaration
	input A, B, C;
	output SUM, CARRY;
	
	//Combinational logic for SUM and CARRY bit outputs
	assign SUM = (A ^ B ^ C);
	assign CARRY = (A & B) + (C & (A ^ B));

endmodule
