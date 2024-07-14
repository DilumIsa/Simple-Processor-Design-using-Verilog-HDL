// Computer Architecture (CO224) - Lab 05 Part-1
// Design: ALU of Simple Processor
// Group: Group-49 
// Reg. No.: E/19/038 and E/19/256

`timescale 1ns / 1ns // Set the simulation timescale to 1ns for simulation.

`include "ADD.V"
`include "AND.V"
`include "FORWARD.V"
`include "OR.V"

// Module for ALU
module alu(
    input [7:0] DATA1, // Input port for DATA1, an 8-bit vector.
    input [7:0] DATA2, // Input port for DATA2, an 8-bit vector.
    input [2:0] SELECT, // Input port for SELECT, a 3-bit vector.
    output reg [7:0] RESULT // Output port for RESULT, an 8-bit vector.
);

    // Internal signals for functional units
    wire [7:0] forward_result; // Internal register to hold the result for the FORWARD operation.
    wire [7:0] add_result; // Internal register to hold the result for the ADD operation.
    wire [7:0] and_result; // Internal register to hold the result for the AND operation.
    wire [7:0] or_result; // Internal register to hold the result for the OR operation.

    // Instantiation of functional unit modules
    forward_unit forward_unit_inst(.DATA2(DATA2), .forward_result(forward_result)); // Instantiate FORWARD unit
    adder_unit adder_unit_inst(.DATA1(DATA1), .DATA2(DATA2), .add_result(add_result)); // Instantiate ADD unit
    and_unit and_unit_inst(.DATA1(DATA1), .DATA2(DATA2), .and_result(and_result)); // Instantiate AND unit
    or_unit or_unit_inst(.DATA1(DATA1), .DATA2(DATA2), .or_result(or_result)); // Instantiate OR unit

    // Output selection using a MUX
    always @* begin
        case (SELECT)
            3'b000: RESULT = forward_result; // If SELECT is 000, output forward_result.
            3'b001: RESULT = add_result; // If SELECT is 001, output add_result.
            3'b010: RESULT = and_result; // If SELECT is 010, output and_result.
            3'b011: RESULT = or_result; // If SELECT is 011, output or_result.
            default: RESULT = 8'b0; // If SELECT doesn't match any case, set RESULT to 0 (default case).
        endcase
    end

endmodule // End of module.
