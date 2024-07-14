// Module for ADD unit
module adder_unit(
    input [7:0] DATA1, // Input data 1 for addition
    input [7:0] DATA2, // Input data 2 for addition
    output reg [7:0] add_result // Output result for addition
);
    // Logic for addition
    always @* begin
        add_result = DATA1 + DATA2; // Compute sum of DATA1 and DATA2
    end
endmodule // End of module.
