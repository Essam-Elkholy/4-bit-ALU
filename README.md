![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# Tiny Tapeout Verilog Project Template

# 4-bit ALU – Tiny Tapeout Project

- [Read the documentation for project](https://github.com/Essam-Elkholy/test/blob/main/docs/info.md)

## How it works

This project implements a 4-bit Arithmetic Logic Unit (ALU) for Tiny Tapeout.

The ALU has two 4-bit input operands:

- A = `ui_in[3:0]`
- B = `ui_in[7:4]`

The ALU operation is selected using:

- `uio_in[3:0]`

The ALU supports arithmetic, logic, comparison, and shift operations.

### Supported operations

| ALU_FUN | Operation |
|---|---|
| `0000` | Addition |
| `0001` | Subtraction |
| `0010` | Multiplication |
| `0011` | Division |
| `0100` | AND |
| `0101` | OR |
| `0110` | NAND |
| `0111` | NOR |
| `1000` | XOR |
| `1001` | XNOR |
| `1010` | A == B |
| `1011` | A > B |
| `1100` | A < B |
| `1101` | Shift Right |
| `1110` | Shift Left |
| `1111` | No Operation |

The ALU output is registered on the rising edge of the clock.

## Outputs

The 4-bit ALU result is available on:

- `uo_out[3:0]`

The upper output bits are unused:

- `uo_out[7:4]`

The ALU also provides status flags:

- `uio_out[0]` = Carry Flag
- `uio_out[1]` = Arithmetic Flag
- `uio_out[2]` = Logic Flag
- `uio_out[3]` = Comparison Flag
- `uio_out[4]` = Shift Flag

## How to test

The project includes a Cocotb testbench.

For example, to test:

`5 + 3`

Set:

`A = 5`

`B = 3`

`ALU_FUN = 0000`

The Tiny Tapeout input mapping is:

`ui_in[3:0] = 0101`

`ui_in[7:4] = 0011`

`uio_in[3:0] = 0000`

After the next rising clock edge:

`uo_out[3:0] = 1000`

which is decimal:
`8`
The Cocotb tests verify the arithmetic, logic, comparison, and shift operations automatically.





## What is Tiny Tapeout?
Tiny Tapeout is an educational project that aims to make it easier and cheaper than ever to get digital and analog designs manufactured on a real chip.
To learn more and get started, visit:
https://tinytapeout.com
Resources
- Tiny Tapeout FAQ
- Digital design lessons
- Learn how semiconductors work
- Tiny Tapeout Discord
- Local hardening guide
