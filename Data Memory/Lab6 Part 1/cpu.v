// Computer Architecture (CO224) - Lab 06 Part-1
// Design: CPU of Simple Processor
// Group: Group-49 
// Reg. No.: E/19/038 and E/19/256

`include "alu.v"
`include "reg_file.v"
`include "Other_modules.v"

//The CPU module contains all the necessary components of the CPU
//The various sub-modules of the CPU are instantiated within the module
//The control logic for the operation of the CPU exists within this top module
module cpu(PC, INSTRUCTION, CLK, RESET, READ, WRITE, ADDRESS, WRITEDATA, READDATA, BUSYWAIT);

    input [31:0] INSTRUCTION;     // Input Instruction
    input CLK;                    // Clock signal
    input RESET;                  // Reset control signal


	input [7:0] READDATA;        // Input Read Data
	input BUSYWAIT;				 // control signal for stall the CPU until the Data memory operation complete(Busywait signal) 

    
    output reg [31:0] PC;         // Output PC


	output [7:0] ADDRESS;         // Output Address
	output [7:0] WRITEDATA;	      // Output Write Data
	output reg READ;              // Output Read Signal to access the Data Memory to read
	output reg WRITE;             // Output Write Signal to access the Data Memory to write

    
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
	wire zero;                    // ZERO operand for ALU
    
    wire [7:0] negatedOp;         // Negated operand for MUX
    wire [7:0] registerOp;        // Operand from register for MUX
    reg signSelect;               // Sign selection control
    
    wire [7:0] IMMEDIATE;         // Immediate value
    reg immSelect;                // Immediate selection control
    
	wire [31:0] PCplus4;          // PC+4 value updated
	wire [31:0] PCout;            // PC value updated 

	wire [31:0] TARGET;           // TRAGET operand for jump/branch adder 
	wire [7:0] OFFSET;            // OFFSET operand for jump/branch adder
	
	//Connections for flow control combinational unit
	reg JUMP;
	reg BRANCH;

	wire flowSelect;              // Flow contral MUX
    
    reg [7:0] OPCODE;             // Opcode

	//Connections to Data memory
	assign ADDRESS = ALURESULT;
	assign WRITEDATA = REGOUT1;

	//Connections for data memory MUX
	reg dataSelect;
	wire [7:0] REGIN;
	
	//Instantiation of CPU modules

	//8x8 Register File
	//Register File WRITEENABLE signal is ANDed with the negation of the BUSYWAIT so that writes do not happen while data memory is busy

	reg_file my_reg(REGIN, REGOUT1, REGOUT2, WRITEREG, READREG1, READREG2, (WRITEENABLE & (!BUSYWAIT)), CLK, RESET);
	//reg_file my_reg(ALURESULT, REGOUT1, REGOUT2, WRITEREG, READREG1, READREG2, WRITEENABLE, CLK, RESET);
	alu my_alu(REGOUT1, OPERAND2, ALURESULT, ALUOP, ZERO);
	twosComp my_twosComp(REGOUT2, negatedOp);
	mux negationMUX(REGOUT2, negatedOp, signSelect, registerOp);
	mux immediateMUX(registerOp, IMMEDIATE, immSelect, OPERAND2);

	pcAdder my_pcAdder(PC, PCplus4);
	jumpbranchAdder my_jumpbranchAdder(PCplus4, OFFSET, TARGET);
	flowControl my_flowControl(JUMP, BRANCH, ZERO, flowSelect);
	mux32 flowctrlmux(PCplus4, TARGET, flowSelect, PCout);

	//Data Memory MUX
	mux datamux(ALURESULT, READDATA, dataSelect, REGIN);

	// Control Logic for CPU
	
	//PC Update (Fetching Mechanism)
	always @ ( posedge CLK)
	begin
		if (RESET == 1'b1) #1 PC = 0;		//If RESET signal is HIGH, set PC to zero
		else if (BUSYWAIT == 1'b1);			//If BUSYWAIT signal is HIGH, do nothing (Keep same PC value)
		else #1 PC = PCout;					//Else, write new PC value
	end
	
	//Clearing READ/WRITE controls for Data Memory when BUSYWAIT is de-asserted
	always @ (BUSYWAIT)
	begin
		if (BUSYWAIT == 1'b0)
		begin
			READ = 0;
			WRITE = 0;
		end
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
	assign OFFSET = INSTRUCTION[23:16];
	
	//Decoding the instruction
	always @ (INSTRUCTION)
	begin
	
		OPCODE = INSTRUCTION[31:24];	//Mapping the OP-CODE section of the instruction to OPCODE
		
		#1	//1 Time Unit Delay for Decoding process
		
		case (OPCODE)
		
			//loadi instruction
			8'b00000000:	begin
								ALUOP = 3'b000;			//Set ALU to forward
								immSelect = 1'b1;		//Set MUX to select immediate value
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								JUMP = 1'b0;			//Set JUMP control signal to zero
								BRANCH = 1'b0;			//Set BRANCH control signal to zero
								WRITEENABLE = 1'b1;		//Enable writing to register
								READ = 1'b0;			//Set READ control signal to zero
								WRITE = 1'b0;			//Set WRITE control signal to zero
								dataSelect = 1'b0;		//Set Data Memory MUX to ALU output 
							end
		
			//mov instruction
			8'b00000001:	begin
								ALUOP = 3'b000;			//Set ALU to FORWARD
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								JUMP = 1'b0;			//Set JUMP control signal to zero
								BRANCH = 1'b0;			//Set BRANCH control signal to zero
								WRITEENABLE = 1'b1;		//Enable writing to register
								READ = 1'b0;			//Set READ control signal to zero
								WRITE = 1'b0;			//Set WRITE control signal to zero
								dataSelect = 1'b0;		//Set Data Memory MUX to ALU output 
							end
			
			//add instruction
			8'b00000010:	begin
								ALUOP = 3'b001;			//Set ALU to ADD
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								JUMP = 1'b0;			//Set JUMP control signal to zero
								BRANCH = 1'b0;			//Set BRANCH control signal to zero
								WRITEENABLE = 1'b1;		//Enable writing to register
								READ = 1'b0;			//Set READ control signal to zero
								WRITE = 1'b0;			//Set WRITE control signal to zero
								dataSelect = 1'b0;		//Set Data Memory MUX to ALU output 
							end	
		
			//sub instruction
			8'b00000011:	begin
								ALUOP = 3'b001;			//Set ALU to ADD
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b1;		//Set sign select MUX to negative sign
								JUMP = 1'b0;			//Set JUMP control signal to zero
								BRANCH = 1'b0;			//Set BRANCH control signal to zero
								WRITEENABLE = 1'b1;		//Enable writing to register
								READ = 1'b0;			//Set READ control signal to zero
								WRITE = 1'b0;			//Set WRITE control signal to zero
								dataSelect = 1'b0;		//Set Data Memory MUX to ALU output 
							end

			//and instruction
			8'b00000100:	begin
								ALUOP = 3'b010;			//Set ALU to AND
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								JUMP = 1'b0;			//Set JUMP control signal to zero
								BRANCH = 1'b0;			//Set BRANCH control signal to zero
								WRITEENABLE = 1'b1;		//Enable writing to register
								READ = 1'b0;			//Set READ control signal to zero
								WRITE = 1'b0;			//Set WRITE control signal to zero
								dataSelect = 1'b0;		//Set Data Memory MUX to ALU output 
							end
							
			//or operation
			8'b00000101:	begin
								ALUOP = 3'b011;			//Set ALU to OR
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								JUMP = 1'b0;			//Set JUMP control signal to zero
								BRANCH = 1'b0;			//Set BRANCH control signal to zero
								WRITEENABLE = 1'b1;		//Enable writing to register
								READ = 1'b0;			//Set READ control signal to zero
								WRITE = 1'b0;			//Set WRITE control signal to zero
								dataSelect = 1'b0;		//Set Data Memory MUX to ALU output 
							end

			//j instruction
			8'b00000110:	begin
								JUMP = 1'b1;			//Set JUMP control signal to 1
								BRANCH = 1'b0;			//Set BRANCH control signal to zero
								WRITEENABLE = 1'b0;		//Disable writing to register
								READ = 1'b0;			//Set READ control signal to zero
								WRITE = 1'b0;			//Set WRITE control signal to zero
								dataSelect = 1'b0;		//Set Data Memory MUX to ALU output 
							end
			
			//beq instruction
			8'b00000111:	begin
								ALUOP = 3'b001;			//Set ALU to ADD
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b1;		//Set sign select MUX to negative sign
								JUMP = 1'b0;			//Set JUMP control signal to zero
								BRANCH = 1'b1;			//Set BRANCH control signal to 1
								WRITEENABLE = 1'b0;		//Enable writing to register
								READ = 1'b0;			//Set READ control signal to zero
								WRITE = 1'b0;			//Set WRITE control signal to zero
								dataSelect = 1'b0;		//Set Data Memory MUX to ALU output 
							end

			//lwd instruction
			8'b00001000:	begin
								ALUOP = 3'b000;			//Set ALU to forward
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								JUMP = 1'b0;			//Set JUMP control signal to zero
								BRANCH = 1'b0;			//Set BRANCH control signal to zero
								WRITEENABLE = 1'b1;		//Enable writing to register
								READ = 1'b1;			//Set READ control signal to HIGH
								WRITE = 1'b0;			//Set WRITE control signal to zero
								dataSelect = 1'b1;		//Set Data Memory MUX to Data memory input
							end
							
			//lwi instruction
			8'b00001001:	begin
								ALUOP = 3'b000;			//Set ALU to forward
								immSelect = 1'b1;		//Set MUX to select immediate value
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								JUMP = 1'b0;			//Set JUMP control signal to zero
								BRANCH = 1'b0;			//Set BRANCH control signal to zero
								WRITEENABLE = 1'b1;		//Enable writing to register
								READ = 1'b1;			//Set READ control signal to HIGH
								WRITE = 1'b0;			//Set WRITE control signal to zero
								dataSelect = 1'b1;		//Set Data Memory MUX to Data memory input
							end
			
			//swd instruction
			8'b00001010:	begin
								ALUOP = 3'b000;			//Set ALU to forward
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								JUMP = 1'b0;			//Set JUMP control signal to zero
								BRANCH = 1'b0;			//Set BRANCH control signal to zero
								WRITEENABLE = 1'b0;		//Enable writing to register
								READ = 1'b0;			//Set READ control signal to zero
								WRITE = 1'b1;			//Set WRITE control signal to HIGH
							end
							
			//swi instruction
			8'b00001011:	begin
								ALUOP = 3'b000;			//Set ALU to forward
								immSelect = 1'b1;		//Set MUX to select immediate value
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								JUMP = 1'b0;			//Set JUMP control signal to zero
								BRANCH = 1'b0;			//Set BRANCH control signal to zero
								WRITEENABLE = 1'b0;		//Enable writing to register
								READ = 1'b0;			//Set READ control signal to zero
								WRITE = 1'b1;			//Set WRITE control signal to HIGH
							end

		endcase
		
	end
	
endmodule


