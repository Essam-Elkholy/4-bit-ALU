module ALU (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire [3:0] ALU_FUN,
    input  wire       CLK,

    output reg  [3:0] ALU_OUT,
    output reg        Carry_Flag,
    output reg        Arith_Flag,
    output reg        Logic_Flag,
    output reg        CMP_Flag,
    output reg        Shift_Flag
);

reg [3:0] ALU_OUT_Comb;

always @(posedge CLK) begin
    ALU_OUT <= ALU_OUT_Comb;
end

always @(*) begin

    Carry_Flag   = 1'b0;
    Arith_Flag   = 1'b0;
    Logic_Flag   = 1'b0;
    CMP_Flag     = 1'b0;
    Shift_Flag   = 1'b0;
    ALU_OUT_Comb = 4'b0000;

    case (ALU_FUN)

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
            if (B != 4'b0000)
                ALU_OUT_Comb = A / B;
            else
                ALU_OUT_Comb = 4'b0000;

            Arith_Flag = 1'b1;
        end

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

        4'b1101: begin
            ALU_OUT_Comb = A >> 1;
            Shift_Flag = 1'b1;
        end

        4'b1110: begin
            ALU_OUT_Comb = A << 1;
            Shift_Flag = 1'b1;
        end

        default: begin
            ALU_OUT_Comb = 4'b0000;
        end

    endcase

end

endmodule
