"""
Program	: CO224 Assembler
Author	: Chamath Colombage - E/19/057
Date	: 24-April-2024

Description:
    This code has been reviewed and tested up to Lab 5 Part 4.
    It is not recommended to use this code for any of the subsequent labs, as there may be errors present.
    This code is provided as is, without any guarantees of correctness.
    Please proceed with caution and use at your own risk.

Note: You must define the op-codes assinged to instructions' opearations, to match the definitions in your instruction set architecture. 
	  Edit the relevant section below.

Usage: python assembler.py <input_file>
or
Usage: py assembler.py <input_file>
    
OUTPUT: instr_mem.mem file will be created in the same directory as the input file.

"""

import sys

### EDIT BELOW DICTIONARY TO MATCH YOUR DEFINED OPCODES
# Opcode Definitions dictionary
opcodes = {
    "loadi": "00000000", 
    "mov": "00000001", 
    "add": "00000010", 
    "sub": "00000011",
    "and": "00000100", 
    "or": "00000101", 
    "j": "00000110", 
    "beq": "00000111",
}

def main():
    if len(sys.argv) != 2:
        print("Usage: python assembler.py sample_program.s")
        return

    input_file = sys.argv[1]
    output_file = "instr_mem" + ".mem"

    try:
        with open(input_file, 'r') as fi, open(output_file, 'w') as fo:
            line_num = 0
            for line in fi:
                # Preprocess the line
                line_num = line_num + 1
                pline = preprocess_line(line)

                # Encode the preprocessed line into machine code
                machine_code = encode_instruction(pline,line_num)

                # Write machine code to output file
                if machine_code == "":
                    pass
                else:
                    fo.write(machine_code + "\n")

    except FileNotFoundError:
        print("Error: Input file not found.")
    except Exception as e:
        print("An error occurred:", e)

def preprocess_line(line):
    # Preprocess the line and insert "X" for ignored fields where needed
    pline = ""
    tokens = line.strip().split()

    if tokens[0].startswith("//"):
        # print("comment: ",tokens[1:])
        pline = ""
    else:
        for token in tokens:
            if token.startswith("//"):
                break
            else:
                pline += token + " "

    return pline

def encode_instruction(pline,line_num):
    # Encode the preprocessed line of assembly code into machine code
    tokens = pline.strip().split()

    if len(tokens) == 0:
        return ""
    else:
        instruction = []
        
        if len(tokens) == 3:
            
            instruction.append(get_register_binary(tokens[2]))
                
            instruction.append("00000000")
                
            instruction.append(get_register_binary(tokens[1]))
                
            # Finally opcode
            try:
                instruction.append(get_opcode(tokens[0],line_num))
            except IndexError:
                print("Error no opcode!!\nI give up!")
                exit(1)
            
        else:    
            try:
                instruction.append(get_register_binary(tokens[3]))
            except IndexError:
                instruction.append("00000000")
                
            try:
                instruction.append(get_register_binary(tokens[2]))
            except IndexError:
                instruction.append("00000000")
                
            # Now, RD
            try:
                instruction.append(get_register_binary(tokens[1]))
            except IndexError:
                instruction.append("00000000")
                
            # Finally opcode
            try:
                instruction.append(get_opcode(tokens[0],line_num))
            except IndexError:
                print("Error no opcode!!\nI give up!")
                exit(1)
        

        return " ".join(instruction)

def get_opcode(operation,line_num):
    # Get opcode for the given operation from the opcodes dictionary
    # If operation is not found, give error
    try:
        return opcodes[operation]
    except KeyError:
        print(f"Error: At line {line_num}, \'{operation}\' is not a predefined instruction.")
        exit(1)
    

def get_register_binary(register):
    # Get binary representation of register number
    if register.isdigit():
        # If the input is a decimal value
        return format(int(register), '08b')
    elif register.startswith("0x") or register.startswith("0X"):
        # If the input is a hexadecimal value
        return format(int(register, 16), '08b')
    else:
        # If the input is neither decimal nor hexadecimal
        return "00000000"

if __name__ == "__main__":
    main()
