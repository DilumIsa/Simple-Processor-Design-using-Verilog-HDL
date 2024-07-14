import sys

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
    "lwd": "00001000",
    "lwi": "00001001",
    "swd": "00001010",
    "swi": "00001011",
}

def main():
    if len(sys.argv) != 2:
        print("Usage: python assembler.py my_sample_program.s")
        return

    input_file = sys.argv[1]
    output_file = "instr_mem" + ".mem"

    try:
        with open(input_file, 'r', encoding='utf-8') as fi, open(output_file, 'w', encoding='utf-8') as fo:
            line_num = 0
            for line in fi:
                # Preprocess the line
                line_num += 1
                pline = preprocess_line(line)

                # Encode the preprocessed line into machine code
                machine_code = encode_instruction(pline, line_num)

                # Write machine code to output file
                if machine_code:
                    fo.write(machine_code + "\n")

    except FileNotFoundError:
        print("Error: Input file not found.")
    except Exception as e:
        print("An error occurred:", e)

def preprocess_line(line):
    # Preprocess the line and insert "X" for ignored fields where needed
    pline = ""
    tokens = line.strip().split()

    if tokens and tokens[0].startswith("//"):
        pline = ""
    else:
        for token in tokens:
            if token.startswith("//"):
                break
            else:
                pline += token + " "

    return pline

def encode_instruction(pline, line_num):
    # Encode the preprocessed line of assembly code into machine code
    tokens = pline.strip().split()

    if not tokens:
        return ""
    else:
        instruction = []

        if len(tokens) == 3:
            instruction.append(get_register_binary(tokens[2]))
            instruction.append("00000000")
            instruction.append(get_register_binary(tokens[1]))
            instruction.append(get_opcode(tokens[0], line_num))
        else:
            instruction.append(get_register_binary(tokens[3]) if len(tokens) > 3 else "00000000")
            instruction.append(get_register_binary(tokens[2]) if len(tokens) > 2 else "00000000")
            instruction.append(get_register_binary(tokens[1]) if len(tokens) > 1 else "00000000")
            instruction.append(get_opcode(tokens[0], line_num))

        return " ".join(instruction)

def get_opcode(operation, line_num):
    # Get opcode for the given operation from the opcodes dictionary
    try:
        return opcodes[operation]
    except KeyError:
        print(f"Error: At line {line_num}, '{operation}' is not a predefined instruction.")
        exit(1)

def get_register_binary(register):
    # Get binary representation of register number
    try:
        if register.isdigit():
            return format(int(register), '08b')
        elif register.startswith("0x") or register.startswith("0X"):
            return format(int(register, 16), '08b')
        else:
            return "00000000"
    except ValueError:
        print(f"Error: Invalid register value '{register}'")
        return "00000000"

if __name__ == "__main__":
    main()
