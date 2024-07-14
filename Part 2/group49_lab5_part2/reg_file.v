// Computer Architecture (CO224) - Lab 05 Part-2
// Design: Register File of Simple Processor
// Group: Group-49 
// Reg. No.: E/19/038 and E/19/256

`timescale 1ns/1ns
module reg_file (
    input[7:0] IN,                // Input data
    output[7:0] OUT1,             // Output data 1
    output[7:0] OUT2,             // Output data 2
    input[2:0] INADDRESS,         // Input address 
    input[2:0] OUT1ADDRESS,       // Output 1 address 
    input[2:0] OUT2ADDRESS,       // Output 2 address 
    input WRITE,                  // Write control signal
    input CLK,                    // Clock signal
    input RESET                   // Reset control signal
);

    // Declaration of register file by using 8 element array of 8 bit registers
    reg [7:0] register[0:7];    
    
    // These assign statements are executed asynchronously (data transmitted concurrently).
    // There are artificial delays of two time units for register reading.
    assign #2 OUT1 = register[OUT1ADDRESS];    // Assigning output 1 from register file
    assign #2 OUT2 = register[OUT2ADDRESS];    // Assigning output 2 from register file

    integer i; 
    
    // This block is works in synchronous manner 
    // this is work during the rising edge of the clock pulse.
    always @(posedge CLK) 
    begin
        if (RESET) 
        begin
            // For loop set all register values to zero ( when the RESET signal is in a high state)

            #1  // Artificial delay of one time unit for resetting
            for (i = 0; i < 8; i = i + 1) 
            begin
                register[i] <= 0;    // Resetting register values
            end
        end
        else 
        begin
            // The else condition handles data transfer when WRITE is high.
            // It transfers data from the input IN to the register specified by the address INADDRESS.
            if (WRITE) 
            #1 
            register[INADDRESS] <= IN;    // Writing data into the specified register
            // Artificial delays of one time units for register writing
        end
    end
endmodule
