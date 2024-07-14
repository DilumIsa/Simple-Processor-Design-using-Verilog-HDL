`include "alu.v"

module testbench;

	//Input ports for ALU
	reg [7:0] op1, op2;
	reg [2:0] sel;
	
	//Output port of ALU
	wire [7:0] result;
	
	//Instantiate the ALU
	alu my_alu(op1, op2, result, sel);
	
	//Simulate changes to inputs to test ALU output behaviour
	initial begin
		//Forwarding
		op1 = 5;	
		op2 = 7;
		sel = 0;
		
		#5
		//Add operation
		op2 = 7;
		sel = 1;
		
		

		#5
		//AND operation
		op2 = 12;
		sel = 2;
		
		#5
		//OR operation
		op1 = 10;
		sel = 3;

		
		
	end
	
	//Initial block to monitor changes and dump wavedata to vcd file
	initial begin
		$dumpfile("wavedata.vcd");
		$dumpvars(0, my_alu);
		$monitor("TIME = %g OP1 = %d OP2 = %d SEL = %b RESULT = %d", $time, op1, op2, sel, result);
		#50 $finish;
	end

endmodule
