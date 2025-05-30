`include "reg_file.v"
`timescale 1ns/100ps

module reg_file_tb;
    
    // Defining input/output ports
    reg WRITE_ENABLE, CLK, RESET;
    reg [4:0] WRITE_ADDR, OUT_ADDR1, OUT_ADDR2;
    reg [31:0] WRITE_DATA;
    wire [31:0] DATA_OUT1, DATA_OUT2;

    // Instantiate the register file module
    reg_file reg_file_t(
        .WRITE_ENABLE(WRITE_ENABLE),
        .CLK(CLK),
        .RESET(RESET),
        .WRITE_ADDR(WRITE_ADDR),
        .OUT_ADDR1(OUT_ADDR1),
        .OUT_ADDR2(OUT_ADDR2),
        .WRITE_DATA(WRITE_DATA),
        .DATA_OUT1(DATA_OUT1),
        .DATA_OUT2(DATA_OUT2)
    );

    // Clock generation
    initial begin
        CLK = 1;
        forever #4 CLK = ~CLK; // Toggle clock every 4 time units
    end

    // Testbench logic
    initial begin

        // generate files needed to plot the waveform using GTKWave
        $dumpfile("reg_file_tb.vcd");
        $dumpvars(0, reg_file_tb);
        $monitor("Time: %0t | WRITE_ENABLE: %b | WRITE_ADDR: %d | OUT_ADDR1: %d | OUT_ADDR2: %d | WRITE_DATA: %d | DATA_OUT1: %d | DATA_OUT2: %d", 
                 $time, WRITE_ENABLE, WRITE_ADDR, OUT_ADDR1, OUT_ADDR2, WRITE_DATA, DATA_OUT1, DATA_OUT2);

    
        // Initialize inputs
        RESET = 1; // Assert reset
        WRITE_ENABLE = 0;
        WRITE_ADDR = 5'd0;
        OUT_ADDR1 = 5'd0;
        OUT_ADDR2 = 5'd0;
        WRITE_DATA = 32'd0;

        // Wait for a few clock cycles
        #8;

        // Deassert reset
        RESET = 0;
        #8;

        // Test writing to the register file
        WRITE_ENABLE = 1;
        WRITE_ADDR = 5'd1; // Write to register 1
        WRITE_DATA = 32'd42; // Write value 42
        #8; // Wait for a clock cycle
        WRITE_ENABLE = 0; // Disable write
        
        #8; // Wait for a clock cycle
        OUT_ADDR1 = 5'd1; // Read from register 1
        OUT_ADDR2 = 5'd0; // Read from register 0 (should always be 0)
        #8; // Wait for a clock cycle
        // Check outputs
        if (DATA_OUT1 !== 32'd42) begin
            $display("Test failed: DATA_OUT1 = %d, expected 42", DATA_OUT1);
        end else begin
            $display("Test passed: DATA_OUT1 = %d", DATA_OUT1);
        end
        if (DATA_OUT2 !== 32'd0) begin
            $display("Test failed: DATA_OUT2 = %d, expected 0", DATA_OUT2);
        end else begin
            $display("Test passed: DATA_OUT2 = %d", DATA_OUT2);
        end

        // Test writing to another register
        #8;
        WRITE_ENABLE = 1;
        WRITE_ADDR = 5'd2; // Write to register 2
        WRITE_DATA = 32'd100; // Write value 100
        #8; // Wait for a clock cycle
        WRITE_ENABLE = 0; // Disable write


        #8; // Wait for a clock cycle
        OUT_ADDR1 = 5'd2; // Read from register 2
        OUT_ADDR2 = 5'd1; // Read from register 1
        #8; // Wait for a clock cycle
        // Check outputs
        if (DATA_OUT1 !== 32'd100) begin
            $display("Test failed: DATA_OUT1 = %d, expected 100", DATA_OUT1);
        end else begin
            $display("Test passed: DATA_OUT1 = %d", DATA_OUT1);
        end
        if (DATA_OUT2 !== 32'd42) begin
            $display("Test failed: DATA_OUT2 = %d, expected 42", DATA_OUT2);
        end else begin
            $display("Test passed: DATA_OUT2 = %d", DATA_OUT2);
        end

        // Test writing to register 0 (should not change value)
        #8;
        WRITE_ENABLE = 1;
        WRITE_ADDR = 5'd0; // Write to register 0 (should not change value)
        WRITE_DATA = 32'd123; // Write value 123
        #8; // Wait for a clock cycle
        WRITE_ENABLE = 0; // Disable write

        OUT_ADDR1 = 5'd0; // Read from register 0
        OUT_ADDR2 = 5'd1; // Read from register 1
        #8; // Wait for a clock cycle
        // Check outputs
        if (DATA_OUT1 !== 32'd0) begin
            $display("Test failed: DATA_OUT1 = %d, expected 0", DATA_OUT1);
        end else begin
            $display("Test passed: DATA_OUT1 = %d", DATA_OUT1);
        end
        if (DATA_OUT2 !== 32'd42) begin
            $display("Test failed: DATA_OUT2 = %d, expected 42", DATA_OUT2);
        end else begin
            $display("Test passed: DATA_OUT2 = %d", DATA_OUT2);
        end

        $finish;

    end

endmodule