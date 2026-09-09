/*
 * Copyright (c) 2026 Essam Mohammed ELkholy
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_ALU (
    input  wire [3:0] A, B,        // 4-bit input signals
    input  wire [3:0] ALU_FUN,     // 4-bit ALU selection signal
    input  wire       CLK,         // Clock signal

    output reg  [3:0] ALU_OUT,     // 4-bit ALU output
    output reg        Carry_Flag,
    output reg        Arith_Flag,
    output reg        Logic_Flag,
    output reg        CMP_Flag,
    output reg        Shift_Flag
);

// Internal signal
reg [3:0] ALU_OUT_Comb;


// Registered output
always @(posedge CLK) begin
    ALU_OUT <= ALU_OUT_Comb;
end


// Combinational ALU logic
always @(*) begin

    // Default values
    Carry_Flag  = 1'b0;
    Arith_Flag  = 1'b0;
    Logic_Flag  = 1'b0;
    CMP_Flag    = 1'b0;
    Shift_Flag  = 1'b0;
    ALU_OUT_Comb = 4'b0000;

    case (ALU_FUN)

        // Arithmetic operations
        4'b0000: begin
            {Carry_Flag, ALU_OUT_Comb} = A + B;
            Arith_Flag = 1'b1;
        end

        4'b0001: begin
            {Carry_Flag, ALU_OUT_Comb} = A - B;
            Arith_Flag = 1'b1;
        end

        4'b0010: begin
            ALU_OUT_Comb = A * B;
            Arith_Flag = 1'b1;
        end

        4'b0011: begin
            ALU_OUT_Comb = A / B;
            Arith_Flag = 1'b1;
        end


        // Logic operations
        4'b0100: begin
            ALU_OUT_Comb = A & B;
            Logic_Flag = 1'b1;
        end

        4'b0101: begin
            ALU_OUT_Comb = A | B;
            Logic_Flag = 1'b1;
        end

        4'b0110: begin
            ALU_OUT_Comb = ~(A & B);
            Logic_Flag = 1'b1;
        end

        4'b0111: begin
            ALU_OUT_Comb = ~(A | B);
            Logic_Flag = 1'b1;
        end

        4'b1000: begin
            ALU_OUT_Comb = A ^ B;
            Logic_Flag = 1'b1;
        end

        4'b1001: begin
            ALU_OUT_Comb = ~(A ^ B);
            Logic_Flag = 1'b1;
        end


        // Comparison operations
        4'b1010: begin
            CMP_Flag = 1'b1;

            if (A == B)
                ALU_OUT_Comb = 4'b0001;
            else
                ALU_OUT_Comb = 4'b0000;
        end

        4'b1011: begin
            CMP_Flag = 1'b1;

            if (A > B)
                ALU_OUT_Comb = 4'b0010;
            else
                ALU_OUT_Comb = 4'b0000;
        end

        4'b1100: begin
            CMP_Flag = 1'b1;

            if (A < B)
                ALU_OUT_Comb = 4'b0011;
            else
                ALU_OUT_Comb = 4'b0000;
        end


        // Shift operations
        4'b1101: begin
            ALU_OUT_Comb = A >> 1;
            Shift_Flag = 1'b1;
        end

        4'b1110: begin
            ALU_OUT_Comb = A << 1;
            Shift_Flag = 1'b1;
        end


        // Default
        default: begin
            ALU_OUT_Comb = 4'b0000;
        end

    endcase
end

endmodule
