/*
 * Copyright (c) 2026 Essam Mohammed ELkholy
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_alu_4bit (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,

    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,

    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

wire [3:0] alu_out;

wire carry_flag;
wire arith_flag;
wire logic_flag;
wire cmp_flag;
wire shift_flag;

ALU alu_inst (
    .A          (ui_in[3:0]),
    .B          (ui_in[7:4]),
    .ALU_FUN    (uio_in[3:0]),
    .CLK        (clk),

    .ALU_OUT    (alu_out),
    .Carry_Flag (carry_flag),
    .Arith_Flag (arith_flag),
    .Logic_Flag (logic_flag),
    .CMP_Flag   (cmp_flag),
    .Shift_Flag (shift_flag)
);

assign uo_out[3:0] = alu_out;
assign uo_out[7:4] = 4'b0000;

assign uio_out[0] = carry_flag;
assign uio_out[1] = arith_flag;
assign uio_out[2] = logic_flag;
assign uio_out[3] = cmp_flag;
assign uio_out[4] = shift_flag;
assign uio_out[7:5] = 3'b000;

assign uio_oe = 8'b00011111;

wire _unused = &{ena, rst_n, uio_in[7:4], 1'b0};

endmodule
