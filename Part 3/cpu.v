// Computer Architecture (CO224) - Lab 05 Part-3
// Design: CPU of Simple Processor
// Group: Group-49 
// Reg. No.: E/19/038 and E/19/256

`include "alu.v"
`include "reg_file.v"
`include "Other_modules.v"

//The CPU module contains all the necessary components of the CPU
//The various sub-modules of the CPU are instantiated within the module
//The control logic for the operation of the CPU exists within this top module
module cpu(PC, INSTRUCTION, CLK, RESET);

    input [31:0] INSTRUCTION;     // Input Instruction
    input CLK;                    // Clock signal
    input RESET;                  // Reset control signal
    
    output reg [31:0] PC;         // Output PC
    
    wire [2:0] READREG1;          // Read register 1 address
    wire [2:0] READREG2;          // Read register 2 address
    wire [2:0] WRITEREG;          // Write register address
    wire [7:0] REGOUT1;           // Data from register 1
    wire [7:0] REGOUT2;           // Data from register 2
    reg WRITEENABLE;              // Write enable control
    
    wire [7:0] OPERAND1;          // Operand 1 for ALU
    wire [7:0] OPERAND2;          // Operand 2 for ALU
    wire [7:0] ALURESULT;         // Result from ALU
    reg [2:0] ALUOP;              // ALU operation control
    
    wire [7:0] negatedOp;         // Negated operand for ALU
    wire [7:0] registerOp;        // Operand from register for ALU
    reg signSelect;               // Sign selection control
    
    wire [7:0] IMMEDIATE;         // Immediate value
    reg immSelect;                // Immediate selection control
    
    reg [31:0] PCreg;             // Register for holding PC
    
    reg [7:0] OPCODE;             // Opcode

	
	//Instantiation of CPU modules
	reg_file my_reg(ALURESULT, REGOUT1, REGOUT2, WRITEREG, READREG1, READREG2, WRITEENABLE, CLK, RESET);
	alu my_alu(REGOUT1, OPERAND2, ALURESULT, ALUOP);
	twosComp my_twosComp(REGOUT2, negatedOp);
	mux negationMUX(REGOUT2, negatedOp, signSelect, registerOp);
	mux immediateMUX(registerOp, IMMEDIATE, immSelect, OPERAND2);

	// Control Logic for CPU
	
	//PC Update (Fetching Mechanism)
	always @ ( posedge CLK)
	begin
		if (RESET == 1'b1) 
		begin
			#1
			PC = 0;		//If RESET signal is HIGH, set PC to zero
			PCreg = 0;
		end
		else #1 PC = PCreg;		//Else, write new PC value
	end
	
	
	//PC+4 Adder
	always @ (PC)
	begin
		#1 PCreg = PCreg + 4;
	end
	
	
	//Relevant portions of INSTRUCTION are mapped to the respective units
	
	///////////////////////////////////////////////////////////////////
	/*    OP-CODE    /      RD       /       RT      /     RS/IMM    */
	/*    [31:24]    /    [23:16]    /     [15:8]    /      [7:0]    */
	///////////////////////////////////////////////////////////////////
	/*       |       /        |      /        |      /       |       */
	/*    OPCODE     /    WRITEREG   /    READREG1   /    READREG2   */
	/*               /               /               /   IMMEDIATE   */
	/*****************************************************************/
	assign READREG1 = INSTRUCTION[15:8];
	assign IMMEDIATE = INSTRUCTION[7:0];
	assign READREG2 = INSTRUCTION[7:0];
	assign WRITEREG = INSTRUCTION[23:16];
	
	//Decoding the instruction
	always @ (INSTRUCTION)
	begin
	
		OPCODE = INSTRUCTION[31:24];	//Mapping the OP-CODE section of the instruction to OPCODE
		
		#1			//1 Time Unit Delay for Decoding process
		
		case (OPCODE)
		
			//loadi instruction
			8'b00000000:	begin
								ALUOP = 3'b000;			//Set ALU to forward
								immSelect = 1'b1;		//Set MUX to select immediate value
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								WRITEENABLE = 1'b1;		//Enable writing to register
							end
		
			//mov instruction
			8'b00000001:	begin
								ALUOP = 3'b000;			//Set ALU to FORWARD
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								WRITEENABLE = 1'b1;		//Enable writing to register
							end
			
			//add instruction
			8'b00000010:	begin
								ALUOP = 3'b001;			//Set ALU to ADD
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								WRITEENABLE = 1'b1;		//Enable writing to register
							end	
		
			//sub instruction
			8'b00000011:	begin
								ALUOP = 3'b001;			//Set ALU to ADD
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b1;		//Set sign select MUX to negative sign
								WRITEENABLE = 1'b1;		//Enable writing to register
							end

			//and instruction
			8'b00000100:	begin
								ALUOP = 3'b010;			//Set ALU to AND
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								WRITEENABLE = 1'b1;		//Enable writing to register
							end
							
			//or operation
			8'b00000101:	begin
								ALUOP = 3'b011;			//Set ALU to OR
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								WRITEENABLE = 1'b1;		//Enable writing to register
							end

		endcase
		
	end
	
endmodule


