# Function to encode a register based on its binary value
def encode_register(register):
    return bin(register)[2:].zfill(4)

# Function to assemble the instruction and return the encoded representation
def assemble_instruction(instruction_name, *operands):
    # Implementation to assemble each instruction and return the encoded representation
    # Replace this with your own implementation

    # Example implementation:
    if instruction_name == 'Lshift':
        register = int(operands[0][1:])
        encoded_register = encode_register(register)
        return '00000' + encoded_register
    elif instruction_name == 'Rshift':
        register = int(operands[0][1:])
        encoded_register = encode_register(register)
        return '00001' + encoded_register
    elif instruction_name == 'Move':
        register = int(operands[0].strip('[]')[1:])
        encoded_register = encode_register(register)
        return '00010' + encoded_register
    elif instruction_name == 'Inc':
        register = int(operands[0][1:])
        encoded_register = encode_register(register)
        return '00011' + encoded_register
    elif instruction_name == 'Add':
        register = int(operands[0][1:])
        encoded_register = encode_register(register)
        return '00100' + encoded_register
    elif instruction_name == 'XOR':
        register = int(operands[0][1:])
        encoded_register = encode_register(register)
        return '00101' + encoded_register
    elif instruction_name == 'Par':
        register = int(operands[0][1:])
        encoded_register = encode_register(register)
        return '00110' + encoded_register
    elif instruction_name == 'And':
        register = int(operands[0][1:])
        encoded_register = encode_register(register)
        return '00111' + encoded_register
    elif instruction_name == 'Bne':
        label = operands[0][:-1]
        if label in label_table:
            encoded_label = label_table[label]
        # else:
        #     encoded_label = '000'
        register = int(operands[1][1:])
        encoded_register = bin(register)[2:].zfill(4)
        return '01' + encoded_label + encoded_register
    elif instruction_name == 'Load':
        register = int(operands[0].strip('[]')[1:])
        encoded_register = encode_register(register)
        return '10000' + encoded_register
    elif instruction_name == 'Store':
        register = int(operands[0].strip('[]')[1:])
        encoded_register = encode_register(register)
        return '10001' + encoded_register
    elif instruction_name == 'Li':
        if operands[0].startswith('#'):
            immediate = int(operands[0][1:])
        elif operands[0].startswith('b'):
            immediate = int(operands[0][1:], 2)
        else:
            raise ValueError("Invalid immediate format")
        encoded_immediate = bin(immediate)[2:].zfill(7)
        return '11' + encoded_immediate
    elif instruction_name == 'DONE':
        return '101111111'
    # Handle labels embedded within instructions
    if ':' in instruction_name:
        label, _ = instruction_name.split(':')
        return label + ':'

    return ''  # Return empty string for unsupported instructions
label_table = {}
# Function to scan the assembly file and create a label lookup table
def create_label_table(file):
    
    line_number = 0
    label_counter = 0
    label_lines = {}
    for line in file:
        line = line.strip()
        if line:
            parts = line.split()
            instruction_name = parts[0]
            if instruction_name.endswith(':'):
                label = instruction_name[:len(instruction_name)-1]
                binary_label = bin(label_counter)[2:].zfill(3)
                label_table[label] = binary_label
                label_counter+=1
                label_lines[label] = line_number
            line_number += 1
    i=0
    for label in label_lines:
        # print("Label Lines:",label_lines)
        label_lines[label] -= i
        i+=1
    print(label_lines)
    return label_table

# Main function to assemble the assembly code
def assemble(assembly_file, output_file):
    # Read the assembly file and create a label lookup table
    with open(assembly_file, 'r') as file:
        label_table = create_label_table(file)

    # Assemble the instructions and write the encoded representations to the output file
    with open(assembly_file, 'r') as file, open(output_file, 'w') as output:
        for line in file:
            line = line.strip()
            if line:
                parts = line.split()
                instruction_name = parts[0]
                operands = parts[1:]
                encoded_instruction = assemble_instruction(instruction_name, *operands)

                # Handle labels embedded within instructions
                if instruction_name.endswith(':'):
                    label = instruction_name[1:]
                    encoded_instruction = label + ':'
                else:
                    output.write(encoded_instruction + '\n')


# Usage: python assembler.py assembly_code.txt output.txt
if __name__ == '__main__':
    import sys

    if len(sys.argv) != 3:
        print('Usage: python assembler.py <assembly_file> <output_file>')
    else:
        assembly_file = sys.argv[1]
        output_file = sys.argv[2]
        assemble(assembly_file, output_file)
