// Intermediate pipeline register module for in between Instruction Fetch and Instruction Decode stages

// This module is used to hold the instruction and the program counter value between the IF and ID stages
// of the pipeline. It is a simple register that captures the values on the rising edge of the clock.
// It also has a reset signal to clear the values when needed.
// Use capital letters for module names and signals to follow Verilog conventions.

`timescale 1ns/100ps

module IF_ID_reg (
    INSTRUCTION, // Input instruction from IF stage
    PC_PLUS_4,   // Input PC+4 value from IF stage
    CLK,         // Clock signal
    RESET,       // Reset signal
    OUT_INSTRUCTION, // Output instruction to ID stage
    OUT_PC_PLUS_4     // Output PC+4 value to ID stage
);

    // Defining input/output ports
    input [31:0] INSTRUCTION; // Input instruction
    input [31:0] PC_PLUS_4;   // Input PC+4 value
    input CLK;               // Clock signal
    input RESET;             // Reset signal
    output reg [31:0] OUT_INSTRUCTION; // Output instruction
    output reg [31:0] OUT_PC_PLUS_4;   // Output PC+4 value


    // On the rising edge of the clock or when reset is high
    always @ (posedge CLK or posedge RESET) begin
        if (RESET) begin
            // If reset is high, clear the output registers
            OUT_INSTRUCTION <= 32'd0;
            OUT_PC_PLUS_4 <= 32'd0;
        end else begin
            // Otherwise, capture the input values
            OUT_INSTRUCTION <= INSTRUCTION;
            OUT_PC_PLUS_4 <= PC_PLUS_4;
        end
    end
endmodule