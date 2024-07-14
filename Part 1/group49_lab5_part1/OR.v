// Module for OR unit
module or_unit(
    input [7:0] DATA1, // Input data 1 for bitwise OR
    input [7:0] DATA2, // Input data 2 for bitwise OR
    output reg [7:0] or_result // Output result for bitwise OR
);
    // Logic for bitwise OR
    always @* begin
        or_result = DATA1 | DATA2; // Perform bitwise OR operation
    end
endmodule // End of module.
