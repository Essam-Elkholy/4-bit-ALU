<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->
# 4-bit ALU

## How it works

This project implements a 4-bit Arithmetic Logic Unit (ALU).

The ALU has two 4-bit inputs, A and B, and a 4-bit function selection input.

Supported operations:

| ALU_FUN | Operation |
|---|---|
| 0000 | Addition |
| 0001 | Subtraction |
| 0010 | Multiplication |
| 0011 | Division |
| 0100 | AND |
| 0101 | OR |
| 0110 | NAND |
| 0111 | NOR |
| 1000 | XOR |
| 1001 | XNOR |
| 1010 | A == B |
| 1011 | A > B |
| 1100 | A < B |
| 1101 | Shift Right |
| 1110 | Shift Left |
| 1111 | No Operation |

The ALU result is stored on the rising edge of the clock.

## Inputs

`ui_in[3:0]` contains operand A.

`ui_in[7:4]` contains operand B.

`uio_in[3:0]` contains the ALU function selection.

## Outputs

`uo_out[3:0]` contains the ALU result.

The status flags are:

- `uio_out[0]` Carry Flag
- `uio_out[1]` Arithmetic Flag
- `uio_out[2]` Logic Flag
- `uio_out[3]` Comparison Flag
- `uio_out[4]` Shift Flag

## How to test

Set the A and B operands using `ui_in`.

For example:

A = 5  
B = 3

Set:

ALU_FUN = 0000

for addition.

After a rising clock edge, the output will be:

8

The Cocotb testbench can also be used to automatically test the design.

## External hardware

No external hardware is required.
