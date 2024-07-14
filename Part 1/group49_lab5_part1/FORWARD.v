// Module for FORWARD unit
module forward_unit(
    input [7:0] DATA2, // Input data for forwarding
    output reg [7:0] forward_result // Output result for forwarding
);
    // Logic for forwarding
    always @* begin
        forward_result = DATA2; // Output DATA2 for forwarding
    end
endmodule // End of module.
