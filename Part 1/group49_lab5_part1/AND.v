// Module for AND unit
module and_unit(
    input [7:0] DATA1, // Input data 1 for bitwise AND
    input [7:0] DATA2, // Input data 2 for bitwise AND
    output reg [7:0] and_result // Output result for bitwise AND
);
    // Logic for bitwise AND
    always @* begin
        and_result = DATA1 & DATA2; // Perform bitwise AND operation
    end
endmodule // End of module.
