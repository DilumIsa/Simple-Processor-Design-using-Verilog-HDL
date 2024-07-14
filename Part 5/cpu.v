// Computer Architecture (CO224) - Lab 05 Part-5
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
	
	
	reg [1:0] BJController;      //Controller for flow control unit
	reg [1:0] RSC;               //Controller for Right Shifting control unit
 
	wire flowSelect;              // Flow contral MUX
    
    reg [7:0] OPCODE;             // Opcode

	
	//Instantiation of CPU modules
	reg_file my_reg(ALURESULT, REGOUT1, REGOUT2, WRITEREG, READREG1, READREG2, WRITEENABLE, CLK, RESET);
	alu my_alu(REGOUT1, OPERAND2, ALURESULT, ALUOP, ZERO, RSC);
	twosComp my_twosComp(REGOUT2, negatedOp);
	mux negationMUX(REGOUT2, negatedOp, signSelect, registerOp);
	mux immediateMUX(registerOp, IMMEDIATE, immSelect, OPERAND2);
	pcAdder my_pcAdder(PC, PCplus4);
	jumpbranchAdder my_jumpbranchAdder(PCplus4, OFFSET, TARGET);
	flowControl my_flowControl(BJController, ZERO, flowSelect);
	mux32 flowctrlmux(PCplus4, TARGET, flowSelect, PCout);

	// Control Logic for CPU
	
	//PC Update (Fetching Mechanism)
	always @ ( posedge CLK)
	begin
		if (RESET == 1'b1) 
		begin
			#1
			PC = 0;		//If RESET signal is HIGH, set PC to zero
		end
		else #1 PC = PCout;		//Else, write new PC value
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
								BJController = 2'b00;	//Set flow control signal 
								WRITEENABLE = 1'b1;		//Enable writing to register
								RSC = 2'b00;            //Set Right shifting control signal 
							end
		
			//mov instruction
			8'b00000001:	begin
								ALUOP = 3'b000;			//Set ALU to mov
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								BJController = 2'b00;	//Set flow control signal 
								WRITEENABLE = 1'b1;		//Enable writing to register
								RSC = 2'b00;            //Set Right shifting control signal 
							end
			
			//add instruction
			8'b00000010:	begin
								ALUOP = 3'b001;			//Set ALU to add
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								BJController = 2'b00;	//Set flow control signal
								WRITEENABLE = 1'b1;		//Enable writing to register
								RSC = 2'b00;            //Set Right shifting control signal 
							end	
		
			//sub instruction
			8'b00000011:	begin
								ALUOP = 3'b001;			//Set ALU to add
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b1;		//Set sign select MUX to negative sign
								BJController = 2'b00;	//Set flow control signal
								WRITEENABLE = 1'b1;		//Enable writing to register
								RSC = 2'b00;            //Set Right shifting control signal 
							end

			//and instruction
			8'b00000100:	begin
								ALUOP = 3'b010;			//Set ALU to and
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								BJController = 2'b00;	//Set flow control signal
								WRITEENABLE = 1'b1;		//Enable writing to register
								RSC = 2'b00;            //Set Right shifting control signal 
							end
							
			//or operation
			8'b00000101:	begin
								ALUOP = 3'b011;			//Set ALU to or
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								BJController = 2'b00;	//Set flow control signal
								WRITEENABLE = 1'b1;		//Enable writing to register
								RSC = 2'b00;            //Set Right shifting control signal 
							end

			//multi operation
			8'b00001001:	begin
								ALUOP = 3'b100;			//Set ALU to multiply
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								BJController = 2'b00;	//Set flow control signal
								WRITEENABLE = 1'b1;		//Enable writing to register
								RSC = 2'b00;            //Set Right shifting control signal 
							end 

			//j instruction
			8'b00000110:	begin
								BJController = 2'b01;	//Set flow control signal
								WRITEENABLE = 1'b0;		//Disable writing to register
								RSC = 2'b00;            //Set Right shifting control signal 
							end
			
			//beq instruction
			8'b00000111:	begin
								ALUOP = 3'b001;			//Set ALU to add
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b1;		//Set sign select MUX to negative sign				
								BJController = 2'b10;	//Set flow control signal
								WRITEENABLE = 1'b0;		//Enable writing to register
								RSC = 2'b00;            //Set Right shifting control signal 
							end

			//bne instruction
			8'b00001000:	begin
								ALUOP = 3'b001;			//Set ALU to add
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b1;		//Set sign select MUX to negative sign
								BJController = 2'b11;	//Set flow control signal
								WRITEENABLE = 1'b0;		//Enable writing to register
								RSC = 2'b00;            //Set Right shifting control signal 
							end

			//sll instruction
			8'b00001010:	begin
								ALUOP = 3'b101;			//Set ALU to LEFT_SHIFT
								immSelect = 1'b1;		//Set MUX to select immediate value
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								BJController = 2'b00;	//Set flow control signal 
								WRITEENABLE = 1'b1;		//Enable writing to register
								RSC = 2'b00;            //Set Right shifting control signal 
							end
			
			
			//srl instruction
			8'b00001011:	begin
								ALUOP = 3'b110;			//Set ALU to RIGHT_SHIFT
								immSelect = 1'b1;		//Set MUX to select immediate value
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								BJController = 2'b00;	//Set flow control signal
								WRITEENABLE = 1'b1;		//Enable writing to register
								RSC = 2'b01;            //Set (Logic) Right shifting control signal 
							end
			
			
			//sra instruction
			8'b00001100:	begin
								ALUOP = 3'b110;			//Set ALU to RIGHT_SHIFT
								immSelect = 1'b1;		//Set MUX to select immediate value
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								BJController = 2'b00;	//Set flow control signal
								WRITEENABLE = 1'b1;		//Enable writing to register
								RSC = 2'b10;            //Set (Arithmeeic) Right shifting control signal 
							end
			
			
			//ror instruction
			8'b00001101:	begin
								ALUOP = 3'b110;			//Set ALU to RIGHT_SHIFT
								immSelect = 1'b1;		//Set MUX to select immediate value
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								BJController = 2'b00;	//Set flow control signal
								WRITEENABLE = 1'b1;		//Enable writing to register
								RSC = 2'b11;            //Set (Rotate) Right shifting control signal 
							end

		endcase
		
	end
	
endmodule


